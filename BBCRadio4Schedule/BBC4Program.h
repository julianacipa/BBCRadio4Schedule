//
//  BBC4Program.h
//  BBCRadio4Schedule
//
//  Created by Juliana Cipa on 26/06/2016.
//  Copyright © 2016 Super Cool Start-up. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBC4Program : NSObject

@property (nonnull, copy) NSString *startDate;
@property (nonnull, copy) NSString *endDate;
@property (nonnull, strong) NSNumber *programDuration;
@property (nonnull, copy) NSString *pid;
@property (nonnull, copy) NSString *shortSynopsis;
@property (nonnull, copy) NSString *title;
@property (nonnull, copy) NSString *type;

- (instancetype __nonnull)initWithDictionary:(NSDictionary * __nullable)paramDictionary NS_DESIGNATED_INITIALIZER;

-(NSString *__nonnull)readableDuration;
-(NSString *__nonnull)readableStartDate;
-(NSString *__nonnull)readableEndDate;

-(BOOL)isMissedProgramNow;

@end
