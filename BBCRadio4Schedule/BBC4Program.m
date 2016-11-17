//
//  BBC4Program.m
//  BBCRadio4Schedule
//
//  Created by Juliana Cipa on 26/06/2016.
//  Copyright © 2016 Super Cool Start-up. All rights reserved.
//

#import "BBC4Program.h"
#import <math.h>

@implementation BBC4Program

- (instancetype) init {
    return [self initWithDictionary:nil];
}

- (instancetype __nonnull)initWithDictionary:(NSDictionary * __nullable)paramDictionary {
    self = [super init];
    
    if(self) {
        _startDate = paramDictionary[@"start"];
        _endDate = paramDictionary[@"end"];
        _programDuration = paramDictionary[@"duration"];
        _pid = paramDictionary[@"programme"][@"programme"][@"image"][@"pid"];
        _shortSynopsis = paramDictionary[@"programme"][@"short_synopsis"];
        _type = paramDictionary[@"programme"][@"type"];
        _title = paramDictionary[@"programme"][@"display_titles"][@"title"];
    }
    
    return self;
}

-(NSString *)readableDuration {
    int programDurationInt = [self.programDuration intValue];
    
    int minutes = (programDurationInt / 60) % 60;
    int hours = programDurationInt / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d",hours, minutes];
}

-(NSString *)readableDate:(NSString *)aDate { //start	String	2016-06-29T00:00:00+01:00
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    NSDate *date  = [dateFormatter dateFromString:aDate];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    
    return formattedDate;
}

-(NSString *)readableStartDate {
    return [self readableDate:self.startDate];
}

-(NSString *)readableEndDate {
    return [self readableDate:self.endDate];
}

-(BOOL)isMissedProgramNow {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    NSDate *endDate  = [dateFormatter dateFromString:self.endDate];
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    BOOL missed = [calendar compareDate:now
                                 toDate:endDate
                      toUnitGranularity:NSCalendarUnitSecond] == NSOrderedDescending;
    
    return missed;
}

@end
