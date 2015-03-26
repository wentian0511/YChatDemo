//
//  YUIActionSheet.m
//  YChatDemo
//
//  Created by 严安 on 15/2/27.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YUIActionSheet.h"

@implementation YUIActionSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        
    }
    return self;
}

@end
