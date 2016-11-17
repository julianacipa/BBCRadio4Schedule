//
//  BBC4ProgramTests.m
//  BBCRadio4Schedule
//
//  Created by Juliana Cipa on 27/06/2016.
//  Copyright © 2016 Super Cool Start-up. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BBC4Program.h"

@interface BBC4ProgramTests : XCTestCase

@end

@implementation BBC4ProgramTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testProgramInit {
    NSString *jsonPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"programs"
                                                                          ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:jsonPath
                                                     encoding:NSUTF8StringEncoding
                                                        error:NULL];
    NSError *error;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionaryInPath = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:0
                                                                       error:&error];
    NSDictionary *programsDictionary = dictionaryInPath[@"schedule"][@"day"][@"broadcasts"];
    NSMutableArray *bbc4Programs = [NSMutableArray array];
    
    for(NSDictionary *programDict in programsDictionary) {
        BBC4Program *bbcProgram = [[BBC4Program alloc] initWithDictionary:programDict];
        
        if(bbcProgram) {
            [bbc4Programs addObject:bbcProgram];
        }
    }
    
    BBC4Program *bbcProgram = bbc4Programs[0];

    XCTAssertTrue(bbc4Programs.count == 1);
    XCTAssertTrue([bbcProgram.startDate isEqualToString:@"2016-06-26T00:00:00+01:00"]);
    XCTAssertTrue([bbcProgram.endDate isEqualToString:@"2016-06-26T00:30:00+01:00"]);
    XCTAssertTrue([bbcProgram.programDuration isEqualToNumber:@1800]);
    XCTAssertTrue([bbcProgram.pid isEqualToString:@"p01lcbf6"]);
    XCTAssertTrue([bbcProgram.shortSynopsis isEqualToString:@"The latest national and international news from BBC Radio 4."]);
    XCTAssertTrue([bbcProgram.title isEqualToString:@"Midnight News"]);
    XCTAssertTrue([bbcProgram.type isEqualToString:@"episode"]);
}

@end
