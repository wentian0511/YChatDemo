//
//  YTransceiverMessageManager.m
//  YChatDemo
//
//  Created by 严安 on 15/1/3.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YTransceiverMessageManager.h"

@implementation YTransceiverMessageManager

#pragma mark 创建消息收发管理单例
static YTransceiverMessageManager *yTransceiverMessageManager = nil;
+ (YTransceiverMessageManager *)ySharedTMMAnager {
    @synchronized (self) {
        if (!yTransceiverMessageManager) {
            yTransceiverMessageManager = [[YTransceiverMessageManager alloc]init];
        }
        return yTransceiverMessageManager;
    }
}

#pragma mark 发送消息
- (void)ySendMessage:(NSString *)yMessage
          withSelfID:(NSString *)ySelfID
      withSendTraget:(NSString *)yTraget
    withSendedObject:(id)ySendedObject
     withMessageType:(MessageType)yType
    withSuccessBlock:(YSendDataSuccessBlock)ySuccess
     withFailedBlock:(YSendDataFailedBlock)yFailed {
    switch (yType) {
        case YMessageText: {
            [[YAFNManager yShareAFNManager] ySendDataWithContent:yMessage
                                                      withSelfID:ySelfID
                                                    withTargetID:yTraget
                                                withSendedObject:ySendedObject
                                                withSuccessBlock:ySuccess
                                                 withFailedBlock:yFailed];
        }
            break;
        case YMessagePicture: { /** 保留 */ } break;
        case YMessageVoice: { /** 保留 */ } break;
        default: break;
    }
}

#pragma mark 获取消息
- (void)yObtainMessageWithSelfID:(NSString *)ySelfID
                withSuccessBlock:(YRequireDataSuccessBlock)ySuccess
                 withFailedBlock:(YRequireDataFailedBlock)yFailed {
    [[YAFNManager yShareAFNManager] yRequireDataWithSelfID:ySelfID
                                          withSuccessBlock:ySuccess
                                           withFailedBlock:yFailed];
}


@end
