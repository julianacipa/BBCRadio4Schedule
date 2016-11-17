//
//  ProgramsService.m
//  BBCRadio4Schedule
//
//  Created by Juliana Cipa on 26/06/2016.
//  Copyright © 2016 Super Cool Start-up. All rights reserved.
//

#import "ProgramsService.h"
#import "WebServiceRequest.h"
#import "BBC4Program.h"

@implementation ProgramsService

+ (void)getProgramsFromServiceWithFileName:(NSString *)fileName
                         completionHandler:(void (^)(NSArray *, NSError *))handler  {
    [WebServiceRequest startGetRequestWithFileName:fileName
                                           handler:^(NSDictionary *response, NSError *error) {
                                               NSDictionary *programsDictionary = response[@"schedule"][@"day"][@"broadcasts"];
                                               NSMutableArray *bbc4Programs = [NSMutableArray array];
                                               
                                               for(NSDictionary *programDict in programsDictionary) {
                                                   BBC4Program *bbcProgram = [[BBC4Program alloc] initWithDictionary:programDict];
                                                   
                                                   if(bbcProgram) {
                                                       [bbc4Programs addObject:bbcProgram];
                                                   }
                                               }
                                               
                                               if (handler) {
                                                   handler([bbc4Programs copy], error);
                                               }
                                           }];
}

+ (void)getTodaysProgramsWithCompletionHandler:(void (^)(NSArray *, NSError *))handler {
    [ProgramsService getProgramsFromServiceWithFileName:@"today" completionHandler:handler];
}

+ (void)getTomorrowsProgramsWithCompletionHandler:(void (^)(NSArray *, NSError *))handler {
    [ProgramsService getProgramsFromServiceWithFileName:@"tomorrow" completionHandler:handler];
}

+ (void)getYesterdaysProgramsWithCompletionHandler:(void (^)(NSArray *, NSError *))handler {
    [ProgramsService getProgramsFromServiceWithFileName:@"yesterday" completionHandler:handler];
}

@end
