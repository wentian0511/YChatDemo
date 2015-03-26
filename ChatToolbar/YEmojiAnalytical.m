//
//  YEmojiAnalytical.m
//  YChatDemo
//
//  Created by 严安 on 14/12/31.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import "YEmojiAnalytical.h"

@implementation YEmojiAnalytical

+ (NSString *)convertSimpleUnicodeStr:(NSString *)inputStr{
    
    int unicodeIntValue = (int)strtoul([inputStr UTF8String], 0, 16);
    
    UTF32Char inputChar = unicodeIntValue ;
    
    inputChar = NSSwapHostIntToLittle(inputChar);
    
    NSString *sendStr = [[NSString alloc] initWithBytes:&inputChar length:4 encoding:NSUTF32LittleEndianStringEncoding];
    
//    NSLog(@"sendStr:::%@",sendStr);
    
    return sendStr;
    
}

@end
