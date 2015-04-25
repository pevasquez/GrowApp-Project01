//
//  BoardsServiceTests.m
//  Inkit
//
//  Created by Cristian Pena on 4/11/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DBBoard+Management.h"

@interface BoardsServiceTests : XCTestCase
@property (strong, nonatomic) XCTestExpectation* expectation;
@end

@implementation BoardsServiceTests

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
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testCreateBoard {
    //Expectation
    self.expectation = [self expectationWithDescription:@"Testing Async Method Works!"];
    
//    DBBoard* board = [DBBoard createWithTitle:@"New Board 3" AndDescription:@"New Boards Description"];
//    [board postWithTarget:self completeAction:@selector(serviceComplete) completeError:@selector(serviceError:)];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
    
}

- (void)testEditBoard {
    //Expectation
    self.expectation = [self expectationWithDescription:@"Testing Async Method Works!"];
    
//    DBBoard* board = [DBBoard createWithTitle:@"New Board" AndDescription:@"New Boards Description"];
//    //board.boardID = @1;
//    [board updateWithTarget:self completeAction:@selector(serviceComplete) completeError:@selector(serviceError:)];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
    
}

- (void)testDeleteBoard {
    //Expectation
    self.expectation = [self expectationWithDescription:@"Testing Async Method Works!"];
    
//    DBBoard* board = [DBBoard createWithTitle:@"New Board" AndDescription:@"New Boards Description"];
//    [board deleteWithTarget:self completeAction:@selector(serviceComplete) completeError:@selector(serviceError:)];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
    
}

- (void)serviceComplete{
    NSLog(@"Board Created successfully");
    [self.expectation fulfill];
}

- (void)serviceError:(NSString *)stringError
{
    NSLog(@"error is: %@", stringError);
    [self.expectation fulfill];
}

@end
