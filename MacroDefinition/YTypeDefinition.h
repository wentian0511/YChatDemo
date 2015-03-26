//
//  YTypeDefinition.h
//  YChatDemo
//
//  Created by 严安 on 15/2/25.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef YChatDemo_YTypeDefinition_h
#define YChatDemo_YTypeDefinition_h

/**
 *	@brief	发送数据成功
 *
 *	@param
 */
typedef void(^YSendDataSuccessBlock)(NSString *ySendDataResponse, id ySendedObject);

/**
 *	@brief	发送数据失败
 *
 *	@param
 */
typedef void(^YSendDataFailedBlock)(NSString *ySendDataResponse, id ySendedObject);


/**
 *	@brief	请求数据成功
 *
 *	@param
 */
typedef void(^YRequireDataSuccessBlock)(NSString *yRequireDataResponse);

/**
 *	@brief	请求数据失败
 *
 *	@param
 */
typedef void(^YRequireDataFailedBlock)(NSString *yRequireDataResponse);

#endif
