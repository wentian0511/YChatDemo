//
//  YExpandingTextViewInternal.m
//  YChatDemo
//
//  Created by 严安 on 14/12/29.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import "YExpandingTextViewInternal.h"

#define kTopContentInset -4
#define lBottonContentInset 12

@implementation YExpandingTextViewInternal

- (void)setContentOffset:(CGPoint)s {
    
    /* Check if user scrolled */
    if (self.tracking || self.decelerating) {
        self.contentInset = UIEdgeInsetsMake(kTopContentInset, 0, 0, 0);
    } else {
        float bottomContentOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
        if(s.y < bottomContentOffset && self.scrollEnabled) {
            self.contentInset = UIEdgeInsetsMake(kTopContentInset, 0, 0, 0);
        }
    }
    
    [super setContentOffset:s];
    
}

- (void)setContentInset:(UIEdgeInsets)s {
    
    UIEdgeInsets edgeInsets = s;
    edgeInsets.top = kTopContentInset;
    if(s.bottom > 12) {
        edgeInsets.bottom = 4;
    }
    
    [super setContentInset:edgeInsets];
    
}

- (void)dealloc {
//    NSLog(@"YExpandingTextViewInternal");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
