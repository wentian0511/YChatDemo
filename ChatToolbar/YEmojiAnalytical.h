//
//  YEmojiAnalytical.h
//  YChatDemo
//
//  Created by 严安 on 14/12/31.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YEmojiAnalytical : NSObject

/**
 *	@brief	emoji表情码字符串转换成unicode编码字符串
 *
 *	@param 	inputStr 	emoji表情码字符串
 *
 *	@return	unicode编码字符串
 */
+ (NSString *)convertSimpleUnicodeStr:(NSString *)inputStr;

@end
