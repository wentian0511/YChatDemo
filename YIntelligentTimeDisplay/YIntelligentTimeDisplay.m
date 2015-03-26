//
//  YIntelligentTimeDisplay.m
//  YChatDemo
//
//  Created by 严安 on 15/1/8.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YIntelligentTimeDisplay.h"

//#import <UIKit/UIKit.h> /** 为了解决CGFloat Unknown */

#import "YYearMonthDayObtain.h"

#import "YTSTMutualTransformation.h"

@implementation YIntelligentTimeDisplay

+ (NSString *)yIntelligentTimeDisplayWithTimeStamp:(NSString *)yTimeStamp {
    
    NSString *yRecordCurrentTimeStamp = [YTSTMutualTransformation yGetCurrentTimeStamp]; /** 获取并记录当前的时间戳 */
    NSString *yRecordInputTimeStamp = [yTimeStamp copy]; /** 记录传入的时间戳 */
    
    /** 得到当前的日期信息 */
    NSInteger yCurrentYear = [YYearMonthDayObtain yGetYear:yRecordCurrentTimeStamp];
    NSInteger yCurrentMonth = [YYearMonthDayObtain yGetMonth:yRecordCurrentTimeStamp];
    NSInteger yCurrentDay = [YYearMonthDayObtain yGetDay:yRecordCurrentTimeStamp];
//    NSInteger yCurrentHour = [YYearMonthDayObtain yGetHour:yRecordCurrentTimeStamp];
//    NSInteger yCurrentMinute = [YYearMonthDayObtain yGetMinute:yRecordCurrentTimeStamp];
    NSInteger yCurrentWeekday = [YYearMonthDayObtain yGetWeekday:yRecordCurrentTimeStamp];
    
    /** 得到传入的日期信息 */
    NSInteger yInputYear = [YYearMonthDayObtain yGetYear:yRecordInputTimeStamp];
    NSInteger yInputMonth = [YYearMonthDayObtain yGetMonth:yRecordInputTimeStamp];
    NSInteger yInputDay = [YYearMonthDayObtain yGetDay:yRecordInputTimeStamp];
    NSInteger yInputHour = [YYearMonthDayObtain yGetHour:yRecordInputTimeStamp];
    NSInteger yInputMinute = [YYearMonthDayObtain yGetMinute:yRecordInputTimeStamp];
    NSInteger yInputWeekday = [YYearMonthDayObtain yGetWeekday:yRecordInputTimeStamp];
    
    NSString *yInputHourStr = nil;
    if (yInputHour >= 0 && yInputHour < 10) {
        yInputHourStr = [NSString stringWithFormat:@"0%d",(int)yInputHour];
    } else {
        yInputHourStr = [NSString stringWithFormat:@"%d",(int)yInputHour];
    }
    
    NSString *yInputMinuteStr = nil;
    if (yInputMinute >= 0 && yInputMinute < 10) {
        yInputMinuteStr = [NSString stringWithFormat:@"0%d",(int)yInputMinute];
    } else {
        yInputMinuteStr = [NSString stringWithFormat:@"%d",(int)yInputMinute];
    }
    
    NSString *yIntelligentString = nil;
    if (yInputYear != yCurrentYear) {
        yIntelligentString = [NSString stringWithFormat:@"%d年%d月%d日 %@:%@",(int)yInputYear,(int)yInputMonth,(int)yInputDay,yInputHourStr,yInputMinuteStr];
        return yIntelligentString;
    } else {
        if (yInputMonth != yCurrentMonth) {
            yIntelligentString = [NSString stringWithFormat:@"%d月%d日 %@:%@",(int)yInputMonth,(int)yInputDay,yInputHourStr,yInputMinuteStr];
        } else {
            if (yCurrentDay - yInputDay > (yCurrentWeekday - 1) && yCurrentDay - yInputDay <= (yCurrentWeekday - 1) + 7) {
                yIntelligentString = [NSString stringWithFormat:@"上周%@ %@:%@",[self yWeekdayLitterToBig:(yCurrentWeekday + 7 - (yCurrentDay - yInputDay))],yInputHourStr,yInputMinuteStr];
            } else if (yCurrentDay - yInputDay > 0 && yCurrentDay - yInputDay <= (yCurrentWeekday - 1)) {
                if (yCurrentDay - yInputDay == 1) {
                    yIntelligentString = [NSString stringWithFormat:@"昨天 %@:%@",yInputHourStr,yInputMinuteStr];
                } else if (yCurrentDay - yInputDay == 2) {
                    yIntelligentString = [NSString stringWithFormat:@"前天 %@:%@",yInputHourStr,yInputMinuteStr];
                } else {
                    yIntelligentString = [NSString stringWithFormat:@"周%@ %@:%@",[self yWeekdayLitterToBig:yInputWeekday],yInputHourStr,yInputMinuteStr];
                }
            } else if (yCurrentDay - yInputDay > (yCurrentWeekday - 1) + 7) {
                yIntelligentString = [NSString stringWithFormat:@"%d月%d日 %@:%@",(int)yInputMonth,(int)yInputDay,yInputHourStr,yInputMinuteStr];
            } else {
                yIntelligentString = [NSString stringWithFormat:@"%@:%@",yInputHourStr,yInputMinuteStr];
            }
        }
    }
    return yIntelligentString;
}

#pragma mark 阿拉伯星期数字对应成中文的星期
+ (NSString *)yWeekdayLitterToBig:(NSInteger)ySmallWeekday {
    // 特别注意星期日是一周当中的第一天
    if (ySmallWeekday == 1) {
        return @"日";
    } else if (ySmallWeekday == 2) {
        return @"一";
    } else if (ySmallWeekday == 3) {
        return @"二";
    } else if (ySmallWeekday == 4) {
        return @"三";
    } else if (ySmallWeekday == 5) {
        return @"四";
    } else if (ySmallWeekday == 6) {
        return @"五";
    } else {
        return @"六";
    }
}

@end
