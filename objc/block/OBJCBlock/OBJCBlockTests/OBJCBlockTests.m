//
//  OBJCBlockTests.m
//  OBJCBlockTests
//
//  Created by gongzhen on 11/27/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface OBJCBlockTests : XCTestCase

@end

@implementation OBJCBlockTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
