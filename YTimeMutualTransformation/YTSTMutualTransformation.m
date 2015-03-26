//
//  YTSTMutualTransformation.m
//  YChatDemo
//
//  Created by 严安 on 15/1/7.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YTSTMutualTransformation.h"

@implementation YTSTMutualTransformation

/** 
 *http://blog.csdn.net/ios_che/article/details/8090977 
 */

#pragma mark 获取当前时间
+ (NSString *)yGetCurrentTime:(NSString *)yTimeFormatter {
    NSDate *ySendDate = [NSDate date];
    NSDateFormatter *yDateFormatter=[[NSDateFormatter alloc] init];
    if (yTimeFormatter) {
        [yDateFormatter setDateFormat:yTimeFormatter];
    } else {
        [yDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return [yDateFormatter stringFromDate:ySendDate];
}

#pragma mark 获取当前时间戳
+ (NSString *)yGetCurrentTimeStamp {
    NSInteger yCurrentTimeStamp = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",(long)yCurrentTimeStamp];
}

#pragma mark 时间戳转时间
+ (NSString *)yTimeStampToTime:(NSString *)yTimeFormatter
                 withTimeStamp:(NSString *)yTimeStamp {
    NSDateFormatter* yFormatter = [[NSDateFormatter alloc] init];
    [yFormatter setDateStyle:NSDateFormatterMediumStyle];
    [yFormatter setTimeStyle:NSDateFormatterShortStyle];
    if (yTimeFormatter) {
        [yFormatter setDateFormat:yTimeFormatter];
    } else {
        [yFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString *yStrDate = [yFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[yTimeStamp doubleValue]]];
    return yStrDate;
}

#pragma mark 时间转时间戳
+ (NSString *)yTimeToTimeStamp:(NSString *)yTime
             withTimeFormatter:(NSString *)yTimeFormatter {
    NSDateFormatter *yFormatter = [[NSDateFormatter alloc] init];
    [yFormatter setDateStyle:NSDateFormatterMediumStyle];
    [yFormatter setTimeStyle:NSDateFormatterShortStyle];
    if (yTimeFormatter) {
        [yFormatter setDateFormat:yTimeFormatter];
    } else {
        [yFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate* yDate = [yFormatter dateFromString:yTime]; // 将字符串按yTimeFormatter转成NSDate
    //    NSString *yDateStr = [yFormatter stringFromDate:yDate];// 将nsdate按formatter格式转成nsstring
    NSInteger yTimeStamp = [yDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",(long)yTimeStamp];
}

@end
