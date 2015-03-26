//
//  YExpandingTextView.h
//  YChatDemo
//
//  Created by 严安 on 14/12/29.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YExpandingTextViewInternal.h"
#import "YExpandingImageView.h"

@protocol YExpandingTextViewDelegate <NSObject>

@optional
- (void)YExpandingTextViewShouldBeginEditing:(UITextView *)textView;
- (void)YExpandingTextViewShouldEndEditing:(UITextView *)textView;

- (void)YExpandingTextViewDidBeginEditing:(UITextView *)textView;
- (void)YExpandingTextViewDidEndEditing:(UITextView *)textView;

- (void)YExpandingTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)YExpandingTextViewEnter:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)YExpandingTextViewDelete:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)YExpandingTextViewDidChange:(UITextView *)textView;

- (void)YExpandingTextViewDidChangeSelection:(UITextView *)textView;

@end

@interface YExpandingTextView : UIView<UITextViewDelegate> {
    
    CGFloat yKeyboardHeight; ///键盘的高度
    
    YExpandingImageView *yExpandingBgImageView;
}

@property (nonatomic, assign)id<YExpandingTextViewDelegate>delegate;

@property (nonatomic,readonly)BOOL yExpandingTextViewIsFirstResponder; ///输入框是否成为第一响应者

@property (nonatomic, copy)YExpandingTextViewInternal *yExpandingTextViewInternal; ///输入框

- (void)yExpandingTextViewResignFirstResponder;
- (void)yExpandingTextViewBecomeFirstResponder;

@end
