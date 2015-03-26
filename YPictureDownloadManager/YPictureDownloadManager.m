//
//  YPictureDownloadManager.m
//  YChatDemo
//
//  Created by 严安 on 15/1/9.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YPictureDownloadManager.h"

#import "AppDelegate.h"

#import "NSString+Hashing.h"

@implementation YPictureDownloadManager

- (instancetype)initWithPicURL:(NSString *)yPicURL withNeedDownloadObject:(id)yNeedDownloadObject withSuccessCallBack:(YDownloadSuccessCallBack)ySuccessCallBack withFailedCallBack:(YDownloadFailedCallBack)yFailedCallBack {
    self = [super init];
    if (self) {
        _yDownloadPicURL = yPicURL;
        _yObject = yNeedDownloadObject;
        _yDownloadSuccessCallBack = ySuccessCallBack;
        _yDownloadFailedCallBack = yFailedCallBack;
        NSURLRequest* yURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:yPicURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
        [NSURLConnection connectionWithRequest:yURLRequest delegate:self];
    }
    return self;
}

#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; // 显示菊花
    yDepositMutData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [yDepositMutData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; // 隐藏菊花
    NSString *yPicDepositPath = [YPictureDownloadManager yCreatePicDepositPath:_yDownloadPicURL];
    do {} while (![yDepositMutData writeToFile:yPicDepositPath atomically:NO]);
    if (_yObject != NULL) {
        _yDownloadSuccessCallBack(yPicDepositPath);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; // 隐藏菊花
    _yDownloadFailedCallBack();
}

#pragma mark 构建下载的图片数据存放路径
+ (NSString *)yCreatePicDepositPath:(NSString *)yPicDownloadURL {
    NSString *yTmpPicDepositPath = [NSString stringWithFormat:@"%@/PicDeposit",NSTemporaryDirectory()];
    [YPictureDownloadManager yCreateDirectory:yTmpPicDepositPath];
    return [NSString stringWithFormat:@"%@/PicDeposit/%@",NSTemporaryDirectory(),[yPicDownloadURL MD5Hash]];
}

#pragma mark 创建文件夹
+ (BOOL)yCreateDirectory:(NSString *)yDocumentDirectoryPath {
    NSFileManager *yFileManager = [NSFileManager defaultManager];
    BOOL yIsDir = FALSE;
    if (![yFileManager fileExistsAtPath:yDocumentDirectoryPath isDirectory:&yIsDir]) {
        BOOL yIsPath = [yFileManager createDirectoryAtPath:yDocumentDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (yIsPath) {
            return TRUE;
        }
        return FALSE;
    }
    return TRUE;
}

@end
