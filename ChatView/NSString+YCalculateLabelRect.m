//
//  NSString+YCalculateLabelRect.m
//  YChatDemo
//
//  Created by 严安 on 15/1/9.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "NSString+YCalculateLabelRect.h"

@implementation NSString (YCalculateLabelRect)

#pragma mark 在一定的约束条件下 string 所占的bounds
- (CGRect)boundingRectWithFont:(UIFont *)yFont {
    CGRect yRect = [self boundingRectWithSize:CGSizeMake(YSCREENWIDTH - 110, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:yFont,NSFontAttributeName, nil] context:nil];
    return yRect;
}

@end
