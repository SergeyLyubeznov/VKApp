//
//  VKHelpMethods.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 03.06.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import "VKHelpMethods.h"

@implementation VKHelpMethods

+ (NSString *)getStringDateByDate:(NSDate *)date {
    
    double second = [date timeIntervalSince1970];
    
    return [VKHelpMethods getStringDateByTimeInterval:second];
    
}

+ (NSString *)getStringDateByTimeInterval:(double)timeInterval {
    
    NSDate *date  = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay |
                                                             NSCalendarUnitYear |NSCalendarUnitMonth
                                                             | NSCalendarUnitMinute | NSCalendarUnitHour) fromDate:date];
    
   NSString *lastSeen = [NSString stringWithFormat:@"%02ld/%02ld/%ld %02ld:%02ld",
                dateComponents.day,
                dateComponents.month,
                dateComponents.year,
                dateComponents.hour,
                dateComponents.minute];
    
    return lastSeen;
    
    
}

@end
