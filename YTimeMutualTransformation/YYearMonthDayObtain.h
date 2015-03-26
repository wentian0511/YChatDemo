//
//  YYearMonthDayObtain.h
//  YChatDemo
//
//  Created by 严安 on 15/1/8.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYearMonthDayObtain : NSObject

/**
 *	@brief	获取年
 *
 *	@param 	yTimeStamp 	时间戳字符串
 *
 *	@return	年
 */
+ (NSInteger)yGetYear:(NSString *)yTimeStamp;

/**
 *	@brief	获取月
 *
 *	@param 	yTimeStamp 	时间戳字符串
 *
 *	@return	月
 */
+ (NSInteger)yGetMonth:(NSString *)yTimeStamp;

/**
 *	@brief	获取日
 *
 *	@param 	yTimeStamp 	时间戳字符串
 *
 *	@return	日
 */
+ (NSInteger)yGetDay:(NSString *)yTimeStamp;

/**
 *	@brief	获取时（24小时制）
 *
 *	@param 	yTimeStamp 	时间戳字符串
 *
 *	@return	时
 */
+ (NSInteger)yGetHour:(NSString *)yTimeStamp;

/**
 *	@brief	获取分
 *
 *	@param 	yTimeStamp 	时间戳字符串
 *
 *	@return	分
 */
+ (NSInteger)yGetMinute:(NSString *)yTimeStamp;

/**
 *	@brief	获取星期
 *
 *	@param 	yTimeStamp 	时间戳字符串
 *
 *	@return	星期几
 */
+ (NSInteger)yGetWeekday:(NSString *)yTimeStamp;

@end
