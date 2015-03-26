//
//  YChatTableViewController.h
//  YChatDemo
//
//  Created by 严安 on 15/1/2.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCellHeader.h"
#import "YCellIdentifier.h"

#import "YChatTableView.h"

// cell种类
#import "YLeftBubbleHaveTimeTextCell.h"
#import "YLeftBubbleNoTimeTextCell.h"
#import "YRightBubbleHaveTimeTextCell.h"
#import "YRightBubbleNoTimeTextCell.h"

#import "YUIActionSheet.h"

#import "YTransceiverMessageManager.h"

#define LOADDATANUMBER 20 // 一次载入数据的条数

#warning Potentially 需要根据调用类的不同更改.
@class YChatViewController;

@interface YChatTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,YRightBubbleHaveTimeTextCellDelegate,YRightBubbleNoTimeTextCellDelegate> {
    
    NSMutableArray *yAccessMutArray; // 存放需要显示的数据
    
    NSUInteger yRecordDatabaseNumber; // 仅仅记录刚进入该类的时候数据库中有多少条数据
    NSUInteger yRecordHaveTakeToFew; // 记录取出数据已经取到的位置（取到第多少条）
    
    BOOL isScrollBottom;
}

@property (nonatomic, copy)UILabel *yTestSizeLabel; // 用于计算出已有内容在label中占用的空间大小

#warning Potentially 需要根据调用类的不同更改.
@property (nonatomic, copy)YChatViewController *ySuperViewController;

@property (nonatomic ,copy)NSString *yDBPath;

@property (nonatomic ,copy)NSString *yTableName;

@property (nonatomic, copy)NSString *yTargetUserID; // 目标用户ID

@property (nonatomic, copy)NSString *yTargetUserName; // 目标用户的用户名

@property (nonatomic, copy)NSString *yTmpChatDataPath; // 临时消息存放路径

/**
 *	@brief	从数据库的表中取出最新的数据
 *
 *	@param 	yNumber 	要取出数据的条数
 *
 *	@return
 */
- (void)yGetLatestSendedData:(NSString *)yNumber;

/**
 *	@brief	从数据库的表中取出指定范围的数据
 *
 *	@param 	yRange 	范围 eg. @"(10,20)"
 *
 *	@return
 */
- (void)yGetSpecifiedRange:(NSString *)yRange;


@property (nonatomic, copy)YChatTableView *yChatTableView;

/**
 *	@brief	发送聊天消息（外部调用）
 *
 *	@param 	yMessageContent 	消息内容
 *
 *	@return
 */
- (void)ySendChatMessageOutside:(NSString *)yMessageContent;


- (void)yScrollToBottom;

- (void)yAdjustmentUnreadMessageButtonFrame;

@end
