//
//  YMaskView.m
//  YChatDemo
//
//  Created by 严安 on 14/12/30.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import "YMaskView.h"

@implementation YMaskView

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_delegate respondsToSelector:@selector(yTouchResponse:)]) {
        [_delegate yTouchResponse:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_delegate respondsToSelector:@selector(yTouchResponse:)]) {
        [_delegate yTouchResponse:self];
    }
}

- (void)dealloc {
//    NSLog(@"YMaskView");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
