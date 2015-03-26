//
//  YChatViewController.h
//  YChatDemo
//
//  Created by 严安 on 15/1/7.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YChatToolbar.h"
#import "YChatTableViewController.h"

@interface YChatViewController : UIViewController<YChatToolbarDelegate> {
    
    YChatTableViewController *yChatTableViewController;
    
}

// 完整的数据库路径 eg. ../db12345.db（../db目标用户ID.db）
@property (nonatomic ,copy)NSString *yDBPath;

// 数据库中的表名 eg. t12345（t目标用户ID）
@property (nonatomic ,copy)NSString *yTableName;

@property (nonatomic, copy)NSString *yTargetUserID; // 目标用户ID

@property (nonatomic, copy)NSString *yTargetUserName; // 目标用户的用户名

@property (nonatomic, copy)NSString *yTmpChatDataPath; // 临时消息存放路径

@end
