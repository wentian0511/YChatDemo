//
//  YExpandingTextView.m
//  YChatDemo
//
//  Created by 严安 on 14/12/29.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import "YExpandingTextView.h"

#define TEXTVIEWFONT 17.0

@implementation YExpandingTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 创建textView
        [self yCreateTextView:frame];
        
    }
    return self;
}

- (void)dealloc {
//    NSLog(@"YExpandingTextView");
    yExpandingBgImageView = nil;
    _yExpandingTextViewInternal = nil;
    
}

#pragma mark 创建textView
- (void)yCreateTextView:(CGRect)yFrame {
    
//    UIImage *yBgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"InputBack@2x" ofType:@"png"]];
//    yBgImage = [yBgImage stretchableImageWithLeftCapWidth:50 topCapHeight:20];
//    CGRect yBgImageViewRect = CGRectMake(self.bounds.origin.x - 3, self.bounds.origin.y - 3, self.bounds.size.width + 6, self.bounds.size.height + 5);
//    yExpandingBgImageView = [[YExpandingImageView alloc] initWithFrame:yBgImageViewRect];
//    yExpandingBgImageView.image = yBgImage;
//    [self addSubview:yExpandingBgImageView];
    
    _yExpandingTextViewInternal = [[YExpandingTextViewInternal alloc]init];
    _yExpandingTextViewInternal.frame = yFrame;
    _yExpandingTextViewInternal.returnKeyType = UIReturnKeySend;
    _yExpandingTextViewInternal.enablesReturnKeyAutomatically = NO;
    _yExpandingTextViewInternal.backgroundColor = [UIColor whiteColor];
    _yExpandingTextViewInternal.font = [UIFont systemFontOfSize:TEXTVIEWFONT];
    _yExpandingTextViewInternal.delegate = self;
    _yExpandingTextViewInternal.contentInset = UIEdgeInsetsMake(-4,0,-4,0);
//    _yExpandingTextViewInternal.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    _yExpandingTextViewInternal.text = @"";
    _yExpandingTextViewInternal.scrollEnabled = NO;
    _yExpandingTextViewInternal.scrollsToTop = NO;
    _yExpandingTextViewInternal.opaque = NO;
    _yExpandingTextViewInternal.showsHorizontalScrollIndicator = NO;
    _yExpandingTextViewInternal.showsVerticalScrollIndicator = YES;
    _yExpandingTextViewInternal.layer.masksToBounds = YES;
    _yExpandingTextViewInternal.layer.cornerRadius = 5.0;
    [self addSubview:_yExpandingTextViewInternal];
    
    CGRect yTextViewFrame = CGRectInset(self.bounds, 0.0, 0.0); ///<<< 相当关键的设置
    _yExpandingTextViewInternal.frame = yTextViewFrame;
    
    
    
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView { ///becomeFirstResponder<<<2
//    NSLog(@"textViewShouldBeginEditing");
    if ([_delegate respondsToSelector:@selector(YExpandingTextViewShouldBeginEditing:)]) {
        [_delegate YExpandingTextViewShouldBeginEditing:textView];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView { ///结束编辑<<<1
    _yExpandingTextViewInternal.enablesReturnKeyAutomatically = YES;
    if ([_delegate respondsToSelector:@selector(YExpandingTextViewShouldEndEditing:)]) {
        [_delegate YExpandingTextViewShouldEndEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView { ///becomeFirstResponder<<<3
    if ([_delegate respondsToSelector:@selector(YExpandingTextViewDidBeginEditing:)]) {
        [_delegate YExpandingTextViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView { ///结束编辑<<<2
    if ([_delegate respondsToSelector:@selector(YExpandingTextViewDidEndEditing:)]) {
        [_delegate YExpandingTextViewDidEndEditing:textView];
    }
}

// 点击键盘时调用
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text { ///edit<<<1
    NSLog(@"text:::%@:::text",text);
    if ([text isEqualToString:@"\n"]) {
        if ([_delegate respondsToSelector:@selector(YExpandingTextViewEnter:shouldChangeTextInRange:replacementText:)]) {
            [_delegate YExpandingTextViewEnter:textView shouldChangeTextInRange:range replacementText:text];
        }
        return NO;
    } else if ([text isEqualToString:@""]) {
        NSLog(@"删除。。。");
        if ([_delegate respondsToSelector:@selector(YExpandingTextViewDelete:shouldChangeTextInRange:replacementText:)]) {
            [_delegate YExpandingTextViewDelete:textView shouldChangeTextInRange:range replacementText:text];
        }
//        CGRect yTextViewFrame = CGRectInset(self.bounds, 0.0, 0.0); ///<<<
//        _yExpandingTextViewInternal.frame = yTextViewFrame;
//        textView.scrollEnabled = NO;
    } else if ([text isEqualToString:@""]) {
        if ([_delegate respondsToSelector:@selector(YExpandingTextView:shouldChangeTextInRange:replacementText:)]) {
            [_delegate YExpandingTextView:textView shouldChangeTextInRange:range replacementText:text];
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView { ///edit<<<3
    if ([_delegate respondsToSelector:@selector(YExpandingTextViewDidChange:)]) {
        [_delegate YExpandingTextViewDidChange:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView { ///becomeFirstResponder<<<1 ///edit<<<2
//    NSLog(@"textViewDidChangeSelection");
    if ([_delegate respondsToSelector:@selector(YExpandingTextViewDidChangeSelection:)]) {
        [_delegate YExpandingTextViewDidChangeSelection:textView];
    }
}

- (void)yExpandingTextViewResignFirstResponder {
    _yExpandingTextViewIsFirstResponder = NO;
    [_yExpandingTextViewInternal resignFirstResponder];
}

- (void)yExpandingTextViewBecomeFirstResponder {
    _yExpandingTextViewIsFirstResponder = YES;
    [_yExpandingTextViewInternal becomeFirstResponder];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (_yExpandingTextViewInternal) {
//        CGRect yTextViewFrame = CGRectInset(self.bounds, 0.0, 0.0); ///<<<
        _yExpandingTextViewInternal.frame = self.bounds;
    }
}


@end
