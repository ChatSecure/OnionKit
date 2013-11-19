//
//  TORRootViewController.m
//  OnionKit
//
//  Created by Christopher Ballinger on 11/19/13.
//  Copyright (c) 2013 ChatSecure. All rights reserved.
//

#import "TORRootViewController.h"
#import "HITorManager.h"


NSString * const kHITorManagerIsRunningKey = @"isRunning";
NSString * const CONNECTING_STRING = @"Connecting to Tor...";
NSString * const DISCONNECTING_STRING = @"Disconnecting from Tor...";
NSString * const DISCONNECTED_STRING = @"Disconnected from Tor";
NSString * const CONNECTED_STRING = @"Connected to Tor!";
NSString * const CONNECT_STRING = @"Connect";
NSString * const DISCONNECT_STRING = @"Disconnect";
NSString * const CANNOT_RECONNECT_STRING = @"Cannot Reconnect";


@interface TORRootViewController ()

@end

@implementation TORRootViewController
@synthesize connectionStatusLabel, activityIndicatorView, connectButton;

- (void) dealloc {
    [[HITorManager defaultManager] removeObserver:self forKeyPath:kHITorManagerIsRunningKey];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.connectionStatusLabel = [[UILabel alloc] init];
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.connectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.connectButton addTarget:self action:@selector(connectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [[HITorManager defaultManager] addObserver:self forKeyPath:kHITorManagerIsRunningKey options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:connectionStatusLabel];
    [self.view addSubview:activityIndicatorView];
    [self.view addSubview:connectButton];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat padding = 20.0f;
    self.connectionStatusLabel.frame = CGRectMake(padding, padding, 200, 30);
    self.connectionStatusLabel.text = DISCONNECTED_STRING;
    self.connectionStatusLabel.textColor = [UIColor redColor];
    [self.connectButton setTitle:CONNECT_STRING forState:UIControlStateNormal];
    self.activityIndicatorView.frame = CGRectMake(connectionStatusLabel.frame.origin.x + connectionStatusLabel.frame.size.width + padding, padding, 30, 30);
    self.connectButton.frame = CGRectMake(padding, connectionStatusLabel.frame.origin.y + connectionStatusLabel.frame.size.height + padding, 150, 50);
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void) connectButtonPressed:(id)sender {
    [self.activityIndicatorView startAnimating];
    if (!self.connectButton.enabled) {
        // do nothing if already connecting
        return;
    }
    self.connectButton.enabled = NO;
    self.connectionStatusLabel.textColor = [UIColor orangeColor];
    if (![HITorManager defaultManager].isRunning) {
        self.connectionStatusLabel.text = CONNECTING_STRING;
        [[HITorManager defaultManager] start];
    } else {
        self.connectionStatusLabel.text = DISCONNECTING_STRING;
        [[HITorManager defaultManager] stop];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:kHITorManagerIsRunningKey]) {
        BOOL isRunning = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if (isRunning) {
            self.connectionStatusLabel.text = CONNECTED_STRING;
            self.connectionStatusLabel.textColor = [UIColor greenColor];
            [self.connectButton setTitle:DISCONNECT_STRING forState:UIControlStateNormal];
            self.connectButton.enabled = YES;
        } else {
            self.connectionStatusLabel.text = DISCONNECTED_STRING;
            self.connectionStatusLabel.textColor = [UIColor redColor];
            [self.connectButton setTitle:CANNOT_RECONNECT_STRING forState:UIControlStateNormal];
            self.connectButton.enabled = NO; // Tor crashes if you disconnect and reconnect, so only allow connecting once.
        }
        [self.activityIndicatorView stopAnimating];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
