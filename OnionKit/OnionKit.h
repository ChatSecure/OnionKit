//
//  OnionKit.h
//
//  Modified from HITorManager.h
//
//  Created by Bazyli Zygan on 23.07.2013.
//  Copyright (c) 2013 Hive Developers. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Real Tor Manager. Allows you to start and stop tor proxy server that
 *  allows you to route your network via tor.
 */

extern NSString * const kOnionKitStartedNotification; //<< Notification informing that the tor manager has started
extern NSString * const kOnionKitStoppedNotification; //<< Notification informing that the tor manager has stopped

@interface OnionKit : NSObject

@property (nonatomic, assign) NSUInteger port;                                       //<< Sets a port for tor proxy server. Default is 9050
@property (nonatomic, readonly, getter = isRunning) BOOL isRunning;                  //<< Flag informing that the server is currently running
@property (nonatomic, copy) NSURL *dataDirectoryURL;                                 //<< Where the tor data should be kept

/** Class method returning defult tor manager.
 *
 * Please not that you shouldn't been creating 
 * objects of this class on your own and should rely only on this 
 * single singleton.
 *
 * @returns Tor Manager object
 */
+ (OnionKit *)sharedInstance;

/** Starts tor proxy server */
- (void)start;

/** Stops tor proxy server */
- (void)stop;

@end
