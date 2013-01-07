//
//  OnionKit.m
//  OnionKit
//
//  Created by Christopher Ballinger on 1/6/13.
//  Copyright (c) 2013 ChatSecure. All rights reserved.
//

#import "OnionKit.h"
#include <Openssl/sha.h>
#import "Bridge.h"
#import "ProxyURLProtocol.h"

@implementation OnionKit
@synthesize
spoofUserAgent,
dntHeader,
usePipelining,
sslWhitelistedDomains,
tor = _tor,
doPrepopulateBookmarks
;

- (id) init {
    if (self = [super init]) {
        [NSURLProtocol registerClass:[ProxyURLProtocol class]];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Settings.sqlite"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        doPrepopulateBookmarks = (![fileManager fileExistsAtPath:[storeURL path]]);
        
        [self updateTorrc];
        _tor = [[TorController alloc] init];
        [_tor startTor];
        
        sslWhitelistedDomains = [[NSMutableArray alloc] init];
        
        spoofUserAgent = UA_SPOOF_NO;
        dntHeader = DNT_HEADER_UNSET;
        usePipelining = YES;
        
        // Start the spinner for the "connecting..." phase
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        /*******************/
        // Clear any previous caches/cookies
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
    }
    return self;
}


- (void)updateTorrc {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *destTorrc = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"torrc"] relativePath];
    if ([fileManager fileExistsAtPath:destTorrc]) {
        [fileManager removeItemAtPath:destTorrc error:NULL];
    }
    NSString *sourceTorrc = [[NSBundle mainBundle] pathForResource:@"torrc" ofType:nil];
    NSError *error = nil;
    [fileManager copyItemAtPath:sourceTorrc toPath:destTorrc error:&error];
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        if (![fileManager fileExistsAtPath:sourceTorrc]) {
            NSLog(@"(Source torrc %@ doesnt exist)", sourceTorrc);
        }
    }
    
    NSMutableArray *bridges = [[Bridge MR_findAll] mutableCopy];
    
    if ([bridges count] == 0) {
        return;
    }
    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:destTorrc];
    [myHandle seekToEndOfFile];
    [myHandle writeData:[@"UseBridges 1\n" dataUsingEncoding:NSUTF8StringEncoding]];
    for (Bridge *bridge in bridges) {
        if ([bridge.conf isEqualToString:@"Tap Here To Edit"]||[bridge.conf isEqualToString:@""]) {
            // skip
        } else {
            [myHandle writeData:[[NSString stringWithFormat:@"bridge %@\n", bridge.conf]
                                 dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


+ (OnionKit *)sharedInstance {
    static OnionKit *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[OnionKit alloc] init];
    });
    
    return _sharedInstance;
}



@end
