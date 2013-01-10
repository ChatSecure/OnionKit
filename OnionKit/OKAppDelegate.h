//
//  OKAppDelegate.h
//  OnionKit
//
//  Created by Christopher Ballinger on 11/18/12.
//  Copyright (c) 2012 ChatSecure. All rights reserved.
//
//  Based on AppDelegate.h from OnionBrowser by Mike Tigas
//  Copyright (c) 2012 Mike Tigas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnionKit.h"
#import "WebViewController.h"

@interface OKAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) OnionKit *onionKit;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) WebViewController *webVC;


@end
