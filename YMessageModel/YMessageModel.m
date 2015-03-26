//
//  YMessageModel.m
//  YChatDemo
//
//  Created by 严安 on 15/1/5.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YMessageModel.h"

@implementation YMessageModel

- (id)mutableCopyWithZone:(NSZone *)zone {
    YMessageModel *yMessageModel = [[YMessageModel allocWithZone:zone]init];
    yMessageModel.yPrimarykey = self.yPrimarykey;
    yMessageModel.yUserID = self.yUserID;
    yMessageModel.yUserName = self.yUserName;
    yMessageModel.yTime = self.yTime;
    yMessageModel.yHaveNoTime = self.yHaveNoTime;
    yMessageModel.yHeadImage = self.yHeadImage;
    yMessageModel.yMessageContent = self.yMessageContent;
    yMessageModel.yMessageSender = self.yMessageSender;
    yMessageModel.yMessageSendSuccessFail = self.yMessageSendSuccessFail;
    
    return yMessageModel;
}

@end
