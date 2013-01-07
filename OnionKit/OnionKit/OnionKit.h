//
//  OnionKit.h
//  OnionKit
//
//  Created by Christopher Ballinger on 1/6/13.
//  Copyright (c) 2013 ChatSecure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorController.h"


#define DNT_HEADER_UNSET 0
#define DNT_HEADER_CANTRACK 1
#define DNT_HEADER_NOTRACK 2

#define UA_SPOOF_NO 0
#define UA_SPOOF_WIN7_TORBROWSER 1
#define UA_SPOOF_SAFARI_MAC 2

@interface OnionKit : NSObject

+ (OnionKit *)sharedInstance;

@property (strong, nonatomic) TorController *tor;


@property (nonatomic) Byte spoofUserAgent;
@property (nonatomic) Byte dntHeader;
@property (nonatomic) Boolean usePipelining;

@property (nonatomic) NSMutableArray *sslWhitelistedDomains; // for self-signed

@property (nonatomic) Boolean doPrepopulateBookmarks;

- (void)updateTorrc;
- (NSURL *)applicationDocumentsDirectory;

@end
