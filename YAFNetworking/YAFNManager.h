//
//  YAFNManager.h
//  YChatDemo
//
//  Created by 严安 on 15/1/13.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface YAFNManager : NSObject

//@property (nonatomic, copy)

/**
 *	@brief	获取YAFNManager单例
 *
 *	@return	YAFNManager对象单例
 */
+ (YAFNManager *)yShareAFNManager;

/**
 *	@brief	发送数据
 *
 *	@param 	yContent 	发送的内容
 *	@param 	ySelfID 	发送人的ID
 *	@param 	yTargetID 	目标ID
 *
 *	@return
 */
- (void)ySendDataWithContent:(NSString *)yContent
                  withSelfID:(NSString *)ySelfID
                withTargetID:(NSString *)yTargetID
            withSendedObject:(id)ySendedObject
            withSuccessBlock:(YSendDataSuccessBlock)ySuccess
             withFailedBlock:(YSendDataFailedBlock)yFailed;

/**
 *	@brief	请求数据
 *
 *	@return	
 */
- (void)yRequireDataWithSelfID:(NSString *)ySelfID
              withSuccessBlock:(YRequireDataSuccessBlock)ySuccess
               withFailedBlock:(YRequireDataFailedBlock)yFailed;



@end
