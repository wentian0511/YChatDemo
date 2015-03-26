//
//  YObtainStoreTemporaryMessage.h
//  YChatDemo
//
//  Created by 严安 on 15/2/25.
//  Copyright (c) 2015年 严安. All rights reserved.
//

/**
 *  获取以及存放临时消息
 */

#import <Foundation/Foundation.h>

@interface YObtainStoreTemporaryMessage : NSObject

// 临时数据存放路径
@property (nonatomic, copy)NSString *yTmpChatDataStorePath;

// 单例
+ (YObtainStoreTemporaryMessage *)ySharedOSTM;

// 获取以及存放临时消息
- (void)yObtainStoreTemporaryMessageAction;

@end
