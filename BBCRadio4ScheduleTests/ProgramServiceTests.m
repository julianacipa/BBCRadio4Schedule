//
//  ProgramServiceTests.m
//  BBCRadio4Schedule
//
//  Created by Juliana Cipa on 27/06/2016.
//  Copyright © 2016 Super Cool Start-up. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProgramsService.h"

@interface ProgramServiceTests : XCTestCase

@end

@implementation ProgramServiceTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetTodaysPrograms {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test Todays Programs"];
    
    [ProgramsService getTodaysProgramsWithCompletionHandler:^(NSArray *programs, NSError *error) {
        XCTAssertNil(error, @"there should not be an error");
        XCTAssertNotNil(programs, @"transactions should not be nil");
        XCTAssertTrue(programs.count > 0, @"there should be some programs");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testGetTomorrowsPrograms {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test Tomorrows Programs"];
    
    [ProgramsService getTomorrowsProgramsWithCompletionHandler:^(NSArray *programs, NSError *error) {
        XCTAssertNil(error, @"there should not be an error");
        XCTAssertNotNil(programs, @"transactions should not be nil");
        XCTAssertTrue(programs.count > 0, @"there should be some programs");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testGetYesterdaysPrograms {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test Yesterdays Programs"];
    
    [ProgramsService getYesterdaysProgramsWithCompletionHandler:^(NSArray *programs, NSError *error) {
        XCTAssertNil(error, @"there should not be an error");
        XCTAssertNotNil(programs, @"transactions should not be nil");
        XCTAssertTrue(programs.count > 0, @"there should be some programs");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

@end
