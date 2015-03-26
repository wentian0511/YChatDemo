//
//  YMessageModel.h
//  YChatDemo
//
//  Created by 严安 on 15/1/5.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
typedef NS_ENUM(NSUInteger, YYOUANDME) {
    YYOU = 0,
    YME     ,
};

typedef NS_ENUM(NSUInteger, YHAVENOTIME) {
    YNOTIME   = 0,
    YHAVETIME    ,
};

typedef NS_ENUM(NSUInteger, YMESSAGESENDSUCCESSFAIL) {
    YMESSAGESENDFAIL   = 0,
    YMESSAGESENDSUCCESS    ,
};
 */

@interface YMessageModel : NSObject<NSMutableCopying>

/**
 *	@brief	设置主键 要想被设置为主键必须将该属性放在模型的的第一个属性位置
 */
@property (nonatomic, retain)NSString *yPrimarykey;

/**
 *	@brief	用户ID
 */
@property (nonatomic, retain)NSString *yUserID;

/**
 *	@brief	用户名
 */
@property (nonatomic, retain)NSString *yUserName;

/**
 *	@brief	时间
 */
@property (nonatomic, retain)NSString *yTime;

/**
 *	@brief	是否显示时间 @"YES" @"NO"
 */
@property (nonatomic, retain)NSString *yHaveNoTime;

/**
 *	@brief	头像URL
 */
@property (nonatomic, retain)NSString *yHeadImage;

/**
 *	@brief	消息内容
 */
@property (nonatomic, retain)NSString *yMessageContent;

/**
 *	@brief	消息发送者 @"YES" @"NO"
 */
@property (nonatomic, retain)NSString *yMessageSender;

/**
 *	@brief	消息发送是否成功 @"1"成功 @"0"失败 @"2"正在发送
 */
@property (nonatomic, retain)NSString *yMessageSendSuccessFail;


@end
