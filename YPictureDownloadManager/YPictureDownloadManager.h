//
//  YPictureDownloadManager.h
//  YChatDemo
//
//  Created by 严安 on 15/1/9.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	@brief  定义图片下载成功回调 block
 *
 *	@param 	yPicDepositPath  图片下载存储路径
 */
typedef void(^YDownloadSuccessCallBack)(NSString *yPicDepositPath);

/**
 *	@brief	定义图片下载失败回调 block
 *
 *	@param 	 	无
 */
typedef void(^YDownloadFailedCallBack)();

@interface YPictureDownloadManager : NSObject<NSURLConnectionDataDelegate> {
    
    NSMutableData *yDepositMutData; // 下载图片数据存储变量
    
}

/**
 *	@brief	图片下载地址
 */
@property (nonatomic, copy)NSString *yDownloadPicURL;

/**
 *	@brief	需要下载图片的对象
 */
@property (nonatomic, copy)id yObject;

/**
 *	@brief	图片下载成功回调 block
 */
@property (nonatomic, copy) YDownloadSuccessCallBack yDownloadSuccessCallBack;
/**
 *	@brief	图片下载失败回调 block
 */
@property (nonatomic, copy) YDownloadFailedCallBack yDownloadFailedCallBack;


/**
 *	@brief	下载图片
 *
 *	@param 	yPicURL 	图片url
 *	@param 	yNeedDownloadObject 	需要下载图片的对象
 *	@param 	ySuccessCallBackBlock 	下载成功的block回调
 *	@param 	yFailedCallBackBlock 	下载失败的block回调
 *
 *	@return	提供下载功能的对象
 */
- (instancetype)initWithPicURL:(NSString *)yPicURL withNeedDownloadObject:(id)yNeedDownloadObject withSuccessCallBack:(YDownloadSuccessCallBack)ySuccessCallBackBlock withFailedCallBack:(YDownloadFailedCallBack)yFailedCallBackBlock;

/**
 *	@brief	构建图片的存放路径
 *
 *	@param 	yPicDownloadURL 	图片的下载url
 *
 *	@return	图片的存放路径
 */
+ (NSString *)yCreatePicDepositPath:(NSString *)yPicDownloadURL;

@end
