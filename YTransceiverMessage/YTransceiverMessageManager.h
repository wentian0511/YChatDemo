//
//  YTransceiverMessageManager.h
//  YChatDemo
//
//  Created by 严安 on 15/1/3.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YAFNManager.h"

typedef NS_ENUM(NSUInteger, MessageType) {
    YMessageText    = 0, // 收发文本
    YMessagePicture    , // 收发图片
    YMessageVoice      , // 收发语音
};

@interface YTransceiverMessageManager : NSObject

/**
 *	@brief	获取消息收发管理单例
 *
 *	@return	消息收发管理单例
 */
+ (YTransceiverMessageManager *)ySharedTMMAnager;

/**
 *	@brief	发送消息，发送发送消息的请求
 *
 *	@param 	yMessage 	消息内容
 *	@param 	ySelfID 	发消息人的ID
 *	@param 	yTraget 	消息送达人ID
 *	@param 	yType       消息类型
 *	@param 	ySuccess 	发送成功回调
 *	@param 	yFailed 	发送失败回调
 *
 *	@return
 */
- (void)ySendMessage:(NSString *)yMessage
          withSelfID:(NSString *)ySelfID
      withSendTraget:(NSString *)yTraget
    withSendedObject:(id)ySendedObject
     withMessageType:(MessageType)yType
    withSuccessBlock:(YSendDataSuccessBlock)ySuccess
     withFailedBlock:(YSendDataFailedBlock)yFailed;


/**
 *	@brief	获取消息，发送获取消息的请求
 *
 *	@param 	ySelfID 	接受消息人的ID
 *	@param 	ySuccess 	接收成功回调
 *	@param 	yFailed 	接受失败回调
 *
 *	@return
 */
- (void)yObtainMessageWithSelfID:(NSString *)ySelfID
                withSuccessBlock:(YRequireDataSuccessBlock)ySuccess
                 withFailedBlock:(YRequireDataFailedBlock)yFailed
;

@end
