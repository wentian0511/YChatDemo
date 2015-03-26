//
//  NSString+YCalculateLabelRect.h
//  YChatDemo
//
//  Created by 严安 on 15/1/9.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSString (YCalculateLabelRect)

/**
 *	@brief	在一定的约束条件下 string 所占的bounds
 *
 *	@param 	yFont 	UIFont
 *
 *	@return	CGRect
 */
- (CGRect)boundingRectWithFont:(UIFont *)yFont;

@end
