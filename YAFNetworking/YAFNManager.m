//
//  YAFNManager.m
//  YChatDemo
//
//  Created by 严安 on 15/1/13.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YAFNManager.h"

@implementation YAFNManager

#pragma mark 创建YAFNManager对象单例
static YAFNManager *yAFNManager = nil;
+ (YAFNManager *)yShareAFNManager {
    @synchronized (self) {
        if (!yAFNManager) {
            yAFNManager = [[YAFNManager alloc]init];
        }
        return yAFNManager;
    }
}

#pragma mark 发送数据
- (void)ySendDataWithContent:(NSString *)yContent
                  withSelfID:(NSString *)ySelfID
                withTargetID:(NSString *)yTargetID
            withSendedObject:(id)ySendedObject
        withSuccessBlock:(YSendDataSuccessBlock)ySuccess
         withFailedBlock:(YSendDataFailedBlock)yFailed {
    AFHTTPRequestOperationManager *yManager = [AFHTTPRequestOperationManager manager];
    
    //申明返回的结果是json类型
    yManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //申明请求的数据是json类型
    yManager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    yManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    yManager.ySendedObject = ySendedObject;
    yManager.ySendDataSuccessBlock = ySuccess;
    yManager.ySendDataFailedBlock = yFailed;
    
    // 获取当前的时间戳字符串
    NSInteger yCurrentTimeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *yCurrentTimeStr = [NSString stringWithFormat:@"%ld",(long)yCurrentTimeStamp];
    
    //传入的参数
    NSDictionary *yParameters = @{@"msgType":msgType_sendMessage,@"userID":ySelfID,@"targetUserID":yTargetID,@"content":yContent,@"time":yCurrentTimeStr};
    
    //发送请求
    [yManager POST:SERVER_ADDRESS parameters:yParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"responseStr: %@",responseStr);
        operation.ySendDataSuccessBlock(responseStr, operation.ySendedObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        operation.ySendDataFailedBlock(error.domain, operation.ySendedObject);
    }];
}

#pragma mark 请求数据
- (void)yRequireDataWithSelfID:(NSString *)ySelfID
              withSuccessBlock:(YRequireDataSuccessBlock)ySuccess
               withFailedBlock:(YRequireDataFailedBlock)yFailed {
    AFHTTPRequestOperationManager *yManager = [AFHTTPRequestOperationManager manager];
    
    //申明返回的结果是json类型
    yManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //申明请求的数据是json类型
    yManager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    yManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    yManager.yRequireDataSuccessBlock = ySuccess;
    yManager.yRequireDataFailedBlock = yFailed;
    
    //传入的参数
    NSDictionary *yParameters = @{@"msgType":msgType_getMessage,@"userID":ySelfID};
    
//    NSLog(@"%@",yParameters);
    
    //发送请求
    [yManager POST:SERVER_ADDRESS parameters:yParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSError *yError;
//        NSDictionary *yResposeDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&yError];
//        NSLog(@"JSON_Data: %@", responseObject);
        NSLog(@"responseStr: %@",responseStr);
//        NSLog(@"JSON: %@", yResposeDict);
        operation.yRequireDataSuccessBlock(responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        operation.yRequireDataFailedBlock(error.domain);
    }];
}

@end
