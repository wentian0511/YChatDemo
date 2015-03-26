//
//  YTSTMutualTransformation.h
//  YChatDemo
//
//  Created by 严安 on 15/1/7.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTSTMutualTransformation : NSObject

/**
 *	@brief	获取当前时间
 *
 *	@param 	yTimeFormate 	时间的格式化字符串 eg. 如果传nil 则按照 @"yyyy-MM-dd HH:MM:ss"
 *
 *	@return	格式化时间
 */
+ (NSString *)yGetCurrentTime:(NSString *)yTimeFormatter;

/**
 *	@brief	获取当前时间戳
 *
 *	@return	时间戳字符串
 */
+ (NSString *)yGetCurrentTimeStamp;

/**
 *	@brief	时间戳转时间
 *
 *	@param 	yTimeFormatter 	时间的格式化字符串 eg. 如果传nil 则按照 @"yyyy-MM-dd HH:MM:ss"
 *	@param 	yTimeStamp 	时间戳字符串
 *
 *	@return	格式化时间字符串
 */
+ (NSString *)yTimeStampToTime:(NSString *)yTimeFormatter
                 withTimeStamp:(NSString *)yTimeStamp;

/**
 *	@brief	时间转时间戳
 *
 *	@param 	yTime 	时间字符串
 *	@param 	yTimeFormatter 	时间的格式化字符串 eg. 如果传nil 则按照 @"yyyy-MM-dd HH:MM:ss"
 *
 *	@return	时间戳字符串
 */
+ (NSString *)yTimeToTimeStamp:(NSString *)yTime
             withTimeFormatter:(NSString *)yTimeFormatter;

@end
