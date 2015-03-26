//
//  YChatToolbar.m
//  YChatDemo
//
//  Created by 严安 on 14/12/29.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import "YChatToolbar.h"

#define YRELATIVESURPLUSHEIGHT 15.0
#define YFACEKEYBOARDHEIGHT 216.0

@implementation YChatToolbar

- (instancetype)initWithFrame:(CGRect)frame superViewController:(UIViewController *)ySuperViewController{
    self = [super initWithFrame:frame];
    if (self) {
        yRecoveryPosition = YES;
        _yViewController = ySuperViewController;
        yRecordTextViewContentOffsetY = 0.0;
        [self yRegistrationKeyboardEvent];
        [self yCreateMask];
        [self yCreateToolbarControl];
        [self yCreateFaceView];
    }
    return self;
}

- (void)dealloc {
//    NSLog(@"YChatToolbar");
//    _yViewController = nil;
    
    yExpandingTextView = nil;
    yKeyboardFaceButton = nil;
    yMaskView = nil;
    yFaceView = nil;
    yFaceScrollView = nil;
    yEmojiFaceTransformMutArr = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardWillHideNotification" object:nil];
}

#pragma mark 注册键盘监听事件
- (void)yRegistrationKeyboardEvent {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yKeyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yKeyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

#pragma mark 键盘将要出现
- (void)yKeyboardWillShow:(NSNotification *)yNoti {
//    NSLog(@"yKeyboardWillShow::");
//    NSLog(@"yKeyboardWillShow::%@",yNoti);
//    NSLog(@"UIKeyboardAnimationDurationUserInfoKey::%@",[[yNoti userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"]);
    [self yKeyboardWillShowCall:yNoti];
}

- (void)yKeyboardWillShowCall:(NSNotification *)yNoti {
    
    yMaskView.hidden = NO;
    
    CGSize yKeyboardSize = [[[yNoti userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size;
    yRecordKeyboardHeight = yKeyboardSize.height;
//    NSLog(@"%lf",YSCREENHEIGHT - YTRASLUCENTHEIGHT(_yViewController) - yKeyboardSize.height - (yRecordExpandingTextViewHeight + 12.0));
    if (yKeyboardSize.height > 0.0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, YSCREENHEIGHT - YTRASLUCENTHEIGHT(_yViewController) - yKeyboardSize.height - (yRecordExpandingTextViewHeight + YRELATIVESURPLUSHEIGHT), YSCREENWIDTH, (yRecordExpandingTextViewHeight + YRELATIVESURPLUSHEIGHT));
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark 键盘将要隐藏
- (void)yKeyboardWillHide:(NSNotification *)yNoti {
//    NSLog(@"yKeyboardWillHide::%@",yNoti);
    NSLog(@"yKeyboardWillHide::");
    [self yKeyboardWillHideCall:yNoti];
}

- (void)yKeyboardWillHideCall:(NSNotification *)yNoti {
    if (yRecoveryPosition) {
        [self yRecoveryToolbarLocation];
    } else {
        
    }
    yRecoveryPosition = YES;
}

#pragma mark 恢复Toolbar的位置
- (void)yRecoveryToolbarLocation {
    yMaskView.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, YSCREENHEIGHT - YTRASLUCENTHEIGHT(_yViewController) - (yRecordExpandingTextViewHeight + YRELATIVESURPLUSHEIGHT), YSCREENWIDTH, (yRecordExpandingTextViewHeight + YRELATIVESURPLUSHEIGHT));
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 创建遮罩
- (void)yCreateMask {
    yMaskView = [[YMaskView alloc]init];
    yMaskView.delegate = self;
    yMaskView.frame = CGRectMake(0, 0, YSCREENWIDTH, YSCREENHEIGHT - YTRASLUCENTHEIGHT(_yViewController));
    yMaskView.backgroundColor = [UIColor clearColor];
    [_yViewController.view addSubview:yMaskView];
    yMaskView.hidden = YES;
}

#pragma mark 创建Toolbar上面的控件
- (void)yCreateToolbarControl {
    yRecordExpandingTextViewHeight = 30.0;
    
    ///输入框
    yExpandingTextView = [[YExpandingTextView alloc]initWithFrame:CGRectMake(20.0, 8.0, YSCREENWIDTH - 85.0, 30.0)];
    yExpandingTextView.delegate = self;
    yExpandingTextView.backgroundColor = [UIColor clearColor];
    [self addSubview:yExpandingTextView];
    
    ///键盘表情切换按钮
    yKeyboardFaceButton = [YKeyboardFaceButton buttonWithType:UIButtonTypeCustom];
    yKeyboardFaceButton.frame = CGRectMake(YSCREENWIDTH - 47.5, self.frame.size.height - 40.0, 35.0, 35.0);
    [yKeyboardFaceButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"face@2x" ofType:@"png"]] forState:UIControlStateNormal];
    yKeyboardFaceButton.yState = @"1";
    [yKeyboardFaceButton addTarget:self action:@selector(ySwitchKeyboardAndFace:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:yKeyboardFaceButton];
}

#pragma mark 创建表情view
- (void)yCreateFaceView {
    yFaceView = [[YFaceView alloc]initWithFrame:CGRectMake(0, YSCREENHEIGHT - YTRASLUCENTHEIGHT(_yViewController), YSCREENWIDTH, YFACEKEYBOARDHEIGHT)];
    yFaceView.delegate = self;
    yFaceView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
    [_yViewController.view addSubview:yFaceView];
    [self yEmojiFaceCodeTransform];
}

#pragma mark 键盘和表情切换
- (void)ySwitchKeyboardAndFace:(YKeyboardFaceButton *)sender {
    if (yMaskView.hidden) {
        yMaskView.hidden = NO;
    }
    if ([sender.yState isEqualToString:@"1"]) {///键盘换表情
        yRecordKeyboardHeight = YFACEKEYBOARDHEIGHT;
        [self ySwitchKeyboardAndFaceBackgroundImage:sender];
        [self yCallFaceView];
    } else if ([sender.yState isEqualToString:@"2"]) {///表情换键盘
        [self ySwitchKeyboardAndFaceBackgroundImage:sender];
        [self yCallKeyboard];
    }
}

#pragma mark 更换键盘和表情切换按钮的图片
- (void)ySwitchKeyboardAndFaceBackgroundImage:(YKeyboardFaceButton *)sender {
    if ([sender.yState isEqualToString:@"1"]) {///表情换键盘
        sender.yState = @"2";
        [yKeyboardFaceButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Text@2x" ofType:@"png"]] forState:UIControlStateNormal];
    } else if ([sender.yState isEqualToString:@"2"]) {///键盘换表情
        sender.yState = @"1";
        [yKeyboardFaceButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"face@2x" ofType:@"png"]] forState:UIControlStateNormal];
    }
}

#pragma mark 还原键盘和表情切换按钮
- (void)yRecoveryKeyboardAndFace {
    yKeyboardFaceButton.yState = @"2";
    [self ySwitchKeyboardAndFaceBackgroundImage:yKeyboardFaceButton];
}

#pragma mark YMaskViewDelegate
- (void)yTouchResponse:(YMaskView *)yMaskView {
    
    if (!yExpandingTextView.yExpandingTextViewIsFirstResponder) {
        [self yRecoveryToolbarLocation];
    }
    
    [self yHideKeyboard];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self yHideFaceView];
    }];
    
    [self yRecoveryKeyboardAndFace];
}

#pragma mark YExpandingTextViewDelegate
- (void)YExpandingTextViewShouldBeginEditing:(UITextView *)textView {
    yKeyboardFaceButton.yState = @"2";
    [self ySwitchKeyboardAndFaceBackgroundImage:yKeyboardFaceButton];
    [UIView animateWithDuration:0.25 animations:^{
        yFaceView.frame = CGRectMake(0, YSCREENHEIGHT - YTRASLUCENTHEIGHT(_yViewController), YSCREENWIDTH, YFACEKEYBOARDHEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)YExpandingTextViewShouldEndEditing:(UITextView *)textView {
    
}

- (void)YExpandingTextViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)YExpandingTextViewDidEndEditing:(UITextView *)textView {
    
}

- (void)YExpandingTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"text");
}

- (void)YExpandingTextViewDelete:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
}

- (void)YExpandingTextViewEnter:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *yTextViewContent = [NSString stringWithString:textView.text];
    if ([yTextViewContent isEqualToString:@""]) {
        return;
    }
    
    // 判断是否是空字符串
    if (0 == [[yTextViewContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        UIAlertView *yAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"不能发送空白消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [yAlertView show];
        textView.text = @"";
        return;
    }
    
    if ([_yChatToolbarDelegate respondsToSelector:@selector(yTellExpandingTextViewText:)]) {
        [_yChatToolbarDelegate yTellExpandingTextViewText:yTextViewContent];
    }
    textView.text = @"";
    
    [yExpandingTextView performSelector:@selector(textViewDidChange:) withObject:textView];
}

- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)YExpandingTextViewDidChange:(UITextView *)textView {
    NSLog(@"YExpandingTextViewDidChange");
//    CGRect yTextViewRect = textView.frame;
    CGSize yConstraintSize = CGSizeMake(textView.frame.size.width, MAXFLOAT);
    CGSize ySize = [textView sizeThatFits:yConstraintSize];
    NSLog(@"size.height:::%f",ySize.height);
    
    if (ySize.height <= 37.0) {
        if (textView.scrollEnabled) {
            textView.scrollEnabled = NO; // 不让textView中的内容滚动
        }
        
        yRecordTextViewContentOffsetY = 0.0;
        
        yRecordExpandingTextViewHeight = 30.0;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, YSCREENHEIGHT - YTRASLUCENTHEIGHT(_yViewController) - yRecordKeyboardHeight - (yRecordExpandingTextViewHeight + YRELATIVESURPLUSHEIGHT), YSCREENWIDTH, (yRecordExpandingTextViewHeight + YRELATIVESURPLUSHEIGHT));
            yExpandingTextView.frame = CGRectMake(20.0, 8.0, YSCREENWIDTH - 85.0, 30.0);
        }];
    } else if (ySize.height > 37.0 && ySize.height <= 110.0) {
        if (textView.scrollEnabled) {
            textView.scrollEnabled = NO; // 不让textView中的内容滚动
        }
        
        ///处理输入框抖动问题
        if (yRecordTextViewContentOffsetY != ySize.height) {
            ///改变输入框的高度
            yRecordExpandingTextViewHeight = ySize.height - 7.0;
            [UIView animateWithDuration:0.25 animations:^{
                self.frame = CGRectMake(0, YSCREENHEIGHT - YTRASLUCENTHEIGHT(_yViewController) - yRecordKeyboardHeight - (yRecordExpandingTextViewHeight + YRELATIVESURPLUSHEIGHT), YSCREENWIDTH, (yRecordExpandingTextViewHeight + YRELATIVESURPLUSHEIGHT));
                yExpandingTextView.frame = CGRectMake(20.0, 8.0, YSCREENWIDTH - 85.0, yRecordExpandingTextViewHeight);
            }];
            
            ///处理正在向输入框中内容时，输入的内容使输入框中的内容变换行的时候光标消失问题
            textView.contentOffset = CGPointMake(0, ySize.height - textView.frame.size.height);
            yRecordTextViewContentOffsetY = ySize.height;
        }
        
    } else {
        if (!textView.scrollEnabled) {
            
            textView.scrollEnabled = YES; // 使textView中的内容可以滚动
            
            ///>>>处理复制粘贴
            yRecordExpandingTextViewHeight = 93.0;
            [UIView animateWithDuration:0.25 animations:^{
                self.frame = CGRectMake(0, YSCREENHEIGHT - YTRASLUCENTHEIGHT(_yViewController) - yRecordKeyboardHeight - (yRecordExpandingTextViewHeight + YRELATIVESURPLUSHEIGHT), YSCREENWIDTH, (yRecordExpandingTextViewHeight + YRELATIVESURPLUSHEIGHT));
                yExpandingTextView.frame = CGRectMake(20.0, 8.0, YSCREENWIDTH - 85.0, yRecordExpandingTextViewHeight);
            }];
            ///<<<
            
            ///处理 输入框定高后，一次性输入的内容超过输入框的高度，输入的可视内容不定位到最后一行
            textView.text = textView.text;
        }
        
        ///处理输入自定义（emoji）表情是，最后一行可视问题
//        [yExpandingTextView.yExpandingTextViewInternal scrollRectToVisible:CGRectMake(1.0, ySize.height - 6.0, 1.0, 1.0) animated:YES];
        [textView scrollRectToVisible:CGRectMake(0, textView.contentSize.height-15, textView.contentSize.width, 10) animated:YES];
        textView.contentInset = UIEdgeInsetsZero;
    }
}

- (void)YExpandingTextViewDidChangeSelection:(UITextView *)textView {
    
}

#pragma mark YFaceViewDelegate
- (void)ySelectedEmojiFace:(NSString *)yEmojiFaceStr {
    yExpandingTextView.yExpandingTextViewInternal.text = [NSString stringWithFormat:@"%@%@",yExpandingTextView.yExpandingTextViewInternal.text,[YEmojiAnalytical convertSimpleUnicodeStr:yEmojiFaceStr]];
    [yExpandingTextView performSelector:@selector(textViewDidChange:) withObject:yExpandingTextView.yExpandingTextViewInternal];
}

- (void)yDeleteEmojiFace {
    
    yRecordTextViewContentOffsetY = 0.0;
    
    NSString *newStr = @"";
    if (yExpandingTextView.yExpandingTextViewInternal.text.length > 0) {
        if ([yEmojiFaceTransformMutArr containsObject:[yExpandingTextView.yExpandingTextViewInternal.text substringFromIndex:yExpandingTextView.yExpandingTextViewInternal.text.length - 1]]) {
            newStr= [yExpandingTextView.yExpandingTextViewInternal.text substringToIndex:yExpandingTextView.yExpandingTextViewInternal.text.length - 1];
        } else if ([yEmojiFaceTransformMutArr containsObject:[yExpandingTextView.yExpandingTextViewInternal.text substringFromIndex:yExpandingTextView.yExpandingTextViewInternal.text.length - 2]]) {
            newStr= [yExpandingTextView.yExpandingTextViewInternal.text substringToIndex:yExpandingTextView.yExpandingTextViewInternal.text.length - 2];
        } else {
            newStr=[yExpandingTextView.yExpandingTextViewInternal.text substringToIndex:yExpandingTextView.yExpandingTextViewInternal.text.length - 1];
        }
        yExpandingTextView.yExpandingTextViewInternal.text = newStr;
        [yExpandingTextView performSelector:@selector(textViewDidChange:) withObject:yExpandingTextView.yExpandingTextViewInternal];
    }
}

#pragma mark 调用表情view
- (void)yCallFaceView {
    yRecoveryPosition = NO;
    
    [self yHideKeyboard];
    
    if (!yExpandingTextView.yExpandingTextViewIsFirstResponder) {
        yRecoveryPosition = YES;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        yFaceView.frame = CGRectMake(0, YSCREENHEIGHT - YTRASLUCENTHEIGHT(_yViewController) - YFACEKEYBOARDHEIGHT, YSCREENWIDTH, YFACEKEYBOARDHEIGHT);
        self.frame = CGRectMake(0, YSCREENHEIGHT - YTRASLUCENTHEIGHT(_yViewController) - YFACEKEYBOARDHEIGHT - (yRecordExpandingTextViewHeight + YRELATIVESURPLUSHEIGHT), YSCREENWIDTH, (yRecordExpandingTextViewHeight + YRELATIVESURPLUSHEIGHT));
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 隐藏表情view
- (void)yHideFaceView {
    yFaceView.frame = CGRectMake(0, YSCREENHEIGHT - YTRASLUCENTHEIGHT(_yViewController), YSCREENWIDTH, YFACEKEYBOARDHEIGHT);
}

#pragma mark 调用键盘
- (void)yCallKeyboard {
    yRecoveryPosition = YES;
    [yExpandingTextView yExpandingTextViewBecomeFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        [self yHideFaceView];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 隐藏键盘
- (void)yHideKeyboard {
    [yExpandingTextView yExpandingTextViewResignFirstResponder];
}

#pragma mark 设置self的frame
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (yKeyboardFaceButton) {
        yKeyboardFaceButton.frame = CGRectMake(YSCREENWIDTH - 47.5, self.frame.size.height - 40.0, 35.0, 35.0);
        if ([_yChatToolbarDelegate respondsToSelector:@selector(yTellChatToolbarFrame:)]) {
            [_yChatToolbarDelegate yTellChatToolbarFrame:frame];
        }
    }
}

#pragma mark 表情编码转化
- (void)yEmojiFaceCodeTransform {
    NSArray *yEmojiFaceArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"emoji" ofType:@"plist"]];
    yEmojiFaceTransformMutArr = [[NSMutableArray alloc]initWithCapacity:165];
    for (NSString *yEmojiFaceString in yEmojiFaceArray) {
        [yEmojiFaceTransformMutArr addObject:[YEmojiAnalytical convertSimpleUnicodeStr:yEmojiFaceString]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
