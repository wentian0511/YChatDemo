//
//  YRightBubbleNoTimeTextCell.h
//  YChatDemo
//
//  Created by 严安 on 15/1/2.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YRightBubbleNoTimeTextCell;

@protocol YRightBubbleNoTimeTextCellDelegate <NSObject>

- (void)yRBNTWhetherAgainSendMessage:(YRightBubbleNoTimeTextCell *)yRightBubbleNoTimeTextCell;

@end

@interface YRightBubbleNoTimeTextCell : UITableViewCell

@property (nonatomic, assign) id<YRightBubbleNoTimeTextCellDelegate>yDelegate;

@property (nonatomic, copy) UIImageView             *yHeadImageView;             // 显示头像的imageview
@property (nonatomic, copy) UIImageView             *yMessageContentBgImageView; // 消息背景imageview
@property (nonatomic, copy) UILabel                 *yMessageContentLabel;       // 显示消息的Label
@property (nonatomic, copy) UIActivityIndicatorView *yActivityIndicatorView;     // 转圈圈
@property (nonatomic, copy) UIButton                *yWhetherAgainSendButton;    // 感叹号

- (void)setYHeadImageViewURL:(NSString *)yHeadImageURL;      // 设置头像
- (void)setYMessageContentBgImageViewPath:(NSString *)yPath; // 设置消息背景
- (void)setYMessageContentLabelText:(NSString *)yText;       // 设置消息内容
- (void)setYActivityIndicatorViewHidden:(BOOL)yBool;         // 设置是否隐藏圈圈
- (void)setYWhetherAgainSendButtonHidden:(BOOL)yBool;        // 设置是否隐藏感叹号button

@end
