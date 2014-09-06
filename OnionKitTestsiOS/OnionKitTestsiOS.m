//
//  OnionKitTestsiOS.m
//  OnionKitTestsiOS
//
//  Created by Christopher Ballinger on 9/5/14.
//  Copyright (c) 2014 ChatSecure. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OnionKit.h"

@interface OnionKitTestsiOS : XCTestCase

@end

@implementation OnionKitTestsiOS

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialization
{
    OnionKit *onionKit = [OnionKit sharedInstance];
    XCTAssertNotNil(onionKit, "onionKit failed to initialize");
}

@end
