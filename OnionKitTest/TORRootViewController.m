//
//  TORRootViewController.m
//  OnionKit
//
//  Created by Christopher Ballinger on 11/19/13.
//  Copyright (c) 2013 ChatSecure. All rights reserved.
//

#import "TORRootViewController.h"
#import "HITorManager.h"
#import "GCDAsyncProxySocket.h"

NSString * const kHITorManagerIsRunningKey = @"isRunning";
NSString * const CONNECTING_STRING = @"Connecting to Tor...";
NSString * const DISCONNECTING_STRING = @"Disconnecting from Tor...";
NSString * const DISCONNECTED_STRING = @"Disconnected from Tor";
NSString * const CONNECTED_STRING = @"Connected to Tor!";
NSString * const CONNECT_STRING = @"Connect";
NSString * const DISCONNECT_STRING = @"Disconnect";
NSString * const CANNOT_RECONNECT_STRING = @"Cannot Reconnect";
NSString * const TEST_STRING = @"Test";

NSString * const kTorCheckHost = @"check.torproject.org";
uint16_t const kTorCheckPort = 443;

@interface TORRootViewController ()

@end

@implementation TORRootViewController
@synthesize connectionStatusLabel, activityIndicatorView, connectButton, testButton;

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
        self.testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.testButton addTarget:self action:@selector(testButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) testButtonPressed:(id)sender {
    GCDAsyncProxySocket *socket = [[GCDAsyncProxySocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [socket setProxyHost:@"127.0.0.1" port:9050 version:GCDAsyncSocketSOCKSVersion5];
    NSError *error = NULL;
    [socket connectToHost:kTorCheckHost onPort:kTorCheckPort error:&error];
    if (error) {
        NSLog(@"Error connecting to host %@", error.userInfo);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:connectionStatusLabel];
    [self.view addSubview:activityIndicatorView];
    [self.view addSubview:connectButton];
    [self.view addSubview:testButton];
    
    
    // setup label and button titles
    self.connectionStatusLabel.text = DISCONNECTED_STRING;
    self.connectionStatusLabel.textColor = [UIColor redColor];
    [self.connectButton setTitle:CONNECT_STRING forState:UIControlStateNormal];
    [self.testButton setTitle:TEST_STRING forState:UIControlStateNormal];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    // setup frames
    CGFloat padding = 20.0f;
    self.connectionStatusLabel.frame = CGRectMake(padding, padding, 200, 30);
    self.activityIndicatorView.frame = CGRectMake(connectionStatusLabel.frame.origin.x + connectionStatusLabel.frame.size.width + padding, padding, 30, 30);
    self.connectButton.frame = CGRectMake(padding, connectionStatusLabel.frame.origin.y + connectionStatusLabel.frame.size.height + padding, 150, 50);
    CGRect testButtonFrame = self.connectButton.frame;
    testButtonFrame.origin.y = self.connectButton.frame.origin.y + self.connectButton.frame.size.height + padding;
    self.testButton.frame = testButtonFrame;
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

#pragma mark GCDAsyncSocketDelegate methods

- (void) socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"%@ connected to %@ on port %d", sock, host, port);
    [sock startTLS:nil];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"socket %@ disconnected: %@", sock, err.userInfo);
}

- (void) socketDidSecure:(GCDAsyncSocket *)sock {
    NSLog(@"socket secured: %@", sock);
    NSString *requestString = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nhost: %@\r\n\r\n", kTorCheckHost];
    NSData *data = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    [sock readDataWithTimeout:-1 tag:1];
    [sock writeData:data withTimeout:-1 tag:0];
}

- (void) socketDidCloseReadStream:(GCDAsyncSocket *)sock {
    NSLog(@"socket closed readstream: %@", sock);
}

- (void) socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"did write data %@ with tag %ld", sock, tag);
}

- (void) socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@ %ld did read data:\n%@\n", sock, tag, responseString);
    [sock readDataWithTimeout:-1 tag:2];
}

@end
