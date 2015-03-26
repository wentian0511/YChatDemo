//
//  YLeftBubbleNoTimeTextCell.h
//  YChatDemo
//
//  Created by 严安 on 15/1/2.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLeftBubbleNoTimeTextCell : UITableViewCell

@property (nonatomic, copy) UIImageView *yHeadImageView;             // 显示头像的imageview
@property (nonatomic, copy) UIImageView *yMessageContentBgImageView; // 消息背景imageview
@property (nonatomic, copy) UILabel     *yMessageContentLabel;       // 显示消息的Label

- (void)setYHeadImageViewURL:(NSString *)yHeadImageURL;      // 设置头像
- (void)setYMessageContentBgImageViewPath:(NSString *)yPath; // 设置消息背景
- (void)setYMessageContentLabelText:(NSString *)yText;       // 设置消息内容

@end
