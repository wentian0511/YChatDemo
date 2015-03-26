//
//  YChatToolbar.h
//  YChatDemo
//
//  Created by 严安 on 14/12/29.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YExpandingTextView.h"
#import "YKeyboardFaceButton.h"
#import "YMaskView.h"
#import "YFaceView.h"
#import "YEmojiAnalytical.h"

@protocol YChatToolbarDelegate <NSObject>

- (void)yTellChatToolbarFrame:(CGRect)yFrame; // 反馈ChatToolbar的实时frame

- (void)yTellExpandingTextViewText:(NSString *)yText; // 反馈发送的输入框的内容

@optional

@end

@interface YChatToolbar : UIToolbar<YMaskViewDelegate,YExpandingTextViewDelegate,YFaceViewDelegate> {
    
    YExpandingTextView *yExpandingTextView;
    
    YKeyboardFaceButton *yKeyboardFaceButton;
    
    CGFloat yRecordExpandingTextViewHeight; // 记录textView实时高度
    
    BOOL yRecoveryPosition;
    
    YMaskView *yMaskView;
    
    YFaceView *yFaceView; // 表情键盘视图
    
    UIScrollView *yFaceScrollView; // 表情键盘scrollView
    
    CGFloat yRecordKeyboardHeight; // 记录键盘实时的高度
    
    CGFloat yRecordTextViewContentOffsetY; // 记录textView里面的内容的实际高度
    
    NSMutableArray *yEmojiFaceTransformMutArr; // 存储转译（可以被控件直接使用）过后的emoji表情字符串
    
}

@property (nonatomic, weak)UIViewController *yViewController;

@property (nonatomic, assign)id<YChatToolbarDelegate>yChatToolbarDelegate;

@property (nonatomic, assign)CGFloat ySetChatToolbarStartPostion; // 设置聊天Toolbar的y坐标的起始位置

- (instancetype)initWithFrame:(CGRect)frame superViewController:(UIViewController *)ySuperViewController;

@end
