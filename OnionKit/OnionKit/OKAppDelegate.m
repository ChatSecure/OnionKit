//
//  OKAppDelegate.m
//  OnionKit
//
//  Created by Christopher Ballinger on 11/18/12.
//  Copyright (c) 2012 ChatSecure. All rights reserved.
//
//  Based on AppDelegate.h from OnionBrowser by Mike Tigas
//  Copyright (c) 2012 Mike Tigas. All rights reserved.
//

#import "OKAppDelegate.h"


@implementation OKAppDelegate
@synthesize window = _window;
@synthesize onionKit = _onionKit;
@synthesize webVC = _webVC;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Settings.sqlite"];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _onionKit = [OnionKit sharedInstance];
    _webVC = [[WebViewController alloc] init];

    _window.rootViewController = _webVC;
    
    [_window makeKeyAndVisible];
    return YES;
}

#pragma mark -
#pragma mark App lifecycle

- (void)applicationWillResignActive:(UIApplication *)application {
    [_onionKit.tor disableTorCheckLoop];
}

- (void) applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (!_onionKit.tor.didFirstConnect) {
        // User is trying to quit app before we have finished initial
        // connection. This is basically an "abort" situation because
        // backgrounding while Tor is attempting to connect will almost
        // definitely result in a hung Tor client. Quit the app entirely,
        // since this is also a good way to allow user to retry initial
        // connection if it fails.
#ifdef DEBUG
        NSLog(@"Went to BG before initial connection completed: exiting.");
#endif
        exit(0);
    } else {
        [_onionKit.tor disableTorCheckLoop];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Don't want to call "activateTorCheckLoop" directly since we
    // want to HUP tor first.
    [_onionKit.tor appDidBecomeActive];
}

@end
