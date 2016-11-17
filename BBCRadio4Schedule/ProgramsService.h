//
//  ProgramsService.h
//  BBCRadio4Schedule
//
//  Created by Juliana Cipa on 26/06/2016.
//  Copyright © 2016 Super Cool Start-up. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgramsService : NSObject

+ (void)getTodaysProgramsWithCompletionHandler:(void (^)(NSArray *, NSError *))handler;
+ (void)getTomorrowsProgramsWithCompletionHandler:(void (^)(NSArray *, NSError *))handler;
+ (void)getYesterdaysProgramsWithCompletionHandler:(void (^)(NSArray *, NSError *))handler;

@end
