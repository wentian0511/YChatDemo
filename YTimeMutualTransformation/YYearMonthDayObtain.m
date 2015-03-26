//
//  YYearMonthDayObtain.m
//  YChatDemo
//
//  Created by 严安 on 15/1/8.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YYearMonthDayObtain.h"

@implementation YYearMonthDayObtain

#pragma mark 获取年
+ (NSInteger)yGetYear:(NSString *)yTimeStamp {
    NSDate *yDate = [self yGetDateWithTimeStamp:yTimeStamp];
    NSCalendar *yCalendar = [NSCalendar currentCalendar];
    NSDateComponents *yComps =[yCalendar components:(NSYearCalendarUnit) fromDate:yDate];
    return [yComps year];
}

#pragma mark 获取月
+ (NSInteger)yGetMonth:(NSString *)yTimeStamp {
    NSDate *yDate = [self yGetDateWithTimeStamp:yTimeStamp];
    NSCalendar *yCalendar = [NSCalendar currentCalendar];
    NSDateComponents *yComps =[yCalendar components:(NSMonthCalendarUnit) fromDate:yDate];
    return [yComps month];
}

#pragma mark 获取日
+ (NSInteger)yGetDay:(NSString *)yTimeStamp {
    NSDate *yDate = [self yGetDateWithTimeStamp:yTimeStamp];
    NSCalendar *yCalendar = [NSCalendar currentCalendar];
    NSDateComponents *yComps =[yCalendar components:(NSDayCalendarUnit) fromDate:yDate];
    return [yComps day];
}

#pragma mark 获取时
+ (NSInteger)yGetHour:(NSString *)yTimeStamp {
    NSDate *yDate = [self yGetDateWithTimeStamp:yTimeStamp];
    NSCalendar *yCalendar = [NSCalendar currentCalendar];
    NSDateComponents *yComps =[yCalendar components:(NSHourCalendarUnit) fromDate:yDate];
    return [yComps hour];
}

#pragma mark 获取分
+ (NSInteger)yGetMinute:(NSString *)yTimeStamp {
    NSDate *yDate = [self yGetDateWithTimeStamp:yTimeStamp];
    NSCalendar *yCalendar = [NSCalendar currentCalendar];
    NSDateComponents *yComps =[yCalendar components:(NSMinuteCalendarUnit) fromDate:yDate];
    return [yComps minute];
}

#pragma mark 获取星期
+ (NSInteger)yGetWeekday:(NSString *)yTimeStamp {
    NSDate *yDate = [self yGetDateWithTimeStamp:yTimeStamp];
    NSCalendar *yCalendar = [NSCalendar currentCalendar];
    NSDateComponents *yComps =[yCalendar components:(NSWeekdayCalendarUnit) fromDate:yDate];
    return [yComps weekday];
}

#pragma mark 标准日期时间
+ (NSDate *)yGetDateWithTimeStamp:(NSString *)yTimeStamp {
//    NSDateFormatter* yFormatter = [[NSDateFormatter alloc] init];
//    [yFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [yFormatter setTimeStyle:NSDateFormatterShortStyle];
//    [yFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *yDate = [NSDate dateWithTimeIntervalSince1970:[yTimeStamp doubleValue]];
    return yDate;
}

@end
