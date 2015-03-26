//
//  YMaskView.h
//  YChatDemo
//
//  Created by 严安 on 14/12/30.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMaskView;

@protocol YMaskViewDelegate <NSObject>

- (void)yTouchResponse:(YMaskView *)yMaskView;

@end

@interface YMaskView : UIView

@property (nonatomic, assign)id<YMaskViewDelegate>delegate;

@end
