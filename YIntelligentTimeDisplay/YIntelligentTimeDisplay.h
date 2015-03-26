//
//  YIntelligentTimeDisplay.h
//  YChatDemo
//
//  Created by 严安 on 15/1/8.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YIntelligentTimeDisplay : NSObject

/**
 *	@brief	将时间戳转换成相对于当前时间的智能化表现形式
 *
 *	@param 	yTimeStamp 	要比对的时间戳字符串(精确到秒)
 *
 *	@return	相对于当前时间的智能化表现形式
 */
+ (NSString *)yIntelligentTimeDisplayWithTimeStamp:(NSString *)yTimeStamp;

@end
