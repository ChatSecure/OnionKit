//
//  TORRootViewController.h
//  OnionKit
//
//  Created by Christopher Ballinger on 11/19/13.
//  Copyright (c) 2013 ChatSecure. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TORRootViewController : UIViewController

@property (nonatomic, strong) UILabel *connectionStatusLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIButton *connectButton;

@end
