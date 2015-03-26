//
//  YObtainStoreTemporaryMessage.m
//  YChatDemo
//
//  Created by 严安 on 15/2/25.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YObtainStoreTemporaryMessage.h"

#import "YTransceiverMessageManager.h"

@implementation YObtainStoreTemporaryMessage

static YObtainStoreTemporaryMessage * yOSTM = nil;
+ (YObtainStoreTemporaryMessage *)ySharedOSTM {
    @synchronized (self) {
        if (!yOSTM) {
            yOSTM = [[YObtainStoreTemporaryMessage alloc]init];
        }
        return yOSTM;
    }
}

- (void)yObtainStoreTemporaryMessageAction {
#warning 根据实际情况更改
    [[YTransceiverMessageManager ySharedTMMAnager] yObtainMessageWithSelfID:@"1" withSuccessBlock:^(NSString *yRequireDataResponse) {
        NSData *yResponseObject = [yRequireDataResponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *yError;
        NSDictionary *yResposeDict = [NSJSONSerialization JSONObjectWithData:yResponseObject options:NSJSONReadingMutableLeaves error:&yError];
        NSLog(@"%@",yResposeDict);
        if ([[yResposeDict objectForKey:@"state"] isEqualToString:@"0"]) {
            [self YStoreChatData:yResposeDict];
        }
    } withFailedBlock:^(NSString *yRequireDataResponse) {
        NSLog(@"failed:%@",yRequireDataResponse);
    }];
}

// 存储临时数据以及发送有新数据通知
- (void)YStoreChatData:(NSDictionary *)yResposeDict {
    NSArray *yResposeArr = [yResposeDict objectForKey:@"List"];
    if (yResposeArr.count > 0) {
        NSArray *yTmpChatDataArr = [NSArray arrayWithContentsOfFile:self.yTmpChatDataStorePath];
        NSMutableArray *yTmpChatDataMutArr = [NSMutableArray arrayWithArray:yTmpChatDataArr];
        if (yTmpChatDataMutArr.count > 0) {
            for (NSDictionary *yItemDict in yResposeArr) {
                int i = 0;
                for (; i < (int)yTmpChatDataMutArr.count; i++) {
                    NSDictionary *yItemTmpDict = [yTmpChatDataMutArr objectAtIndex:i];
                    NSMutableDictionary *yItemTmpMutDict = [NSMutableDictionary dictionaryWithDictionary:yItemTmpDict];
                    if ([(NSString *)[yItemTmpMutDict objectForKey:@"userID"] isEqualToString:(NSString *)[yItemDict objectForKey:@"userID"]]) {
                        NSMutableArray *yItemTmp_list_MutArr = [NSMutableArray arrayWithArray:[yItemTmpMutDict objectForKey:@"list"]];
                        for (NSDictionary *yItem_list_Dict in [yItemDict objectForKey:@"list"]) {
                            [yItemTmp_list_MutArr addObject:yItem_list_Dict];
                        }
                        [yItemTmpMutDict setObject:yItemTmp_list_MutArr forKey:@"list"];
                        [yTmpChatDataMutArr removeObject:yItemTmpDict];
                        [yTmpChatDataMutArr insertObject:yItemTmpMutDict atIndex:0];
                        break;
                    } else {
                        continue;
                    }
                }
                if (i == (int)yTmpChatDataMutArr.count) {
                    [yTmpChatDataMutArr insertObject:yItemDict atIndex:0];
                }
            }
        } else {
            for (NSDictionary *yItemDict in yResposeArr) {
                [yTmpChatDataMutArr addObject:yItemDict];
            }
        }
        do{}while (![yTmpChatDataMutArr writeToFile:self.yTmpChatDataStorePath atomically:NO]);
        
        // 发送有新数据的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YHAVENEWDATA" object:nil];
    }
}

/*
#pragma mark 创建临时存储文件
- (void)yCreateTmpChatDataFile {
    NSArray *yArrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *yDocumentDirectory = [yArrayPaths firstObject];
    [self yCreateDirectory:[NSString stringWithFormat:@"%@/ChatData",yDocumentDirectory]];
#warning 根据实际情况更改
    [self yCreateDirectory:[NSString stringWithFormat:@"%@/ChatData/UserID_2",yDocumentDirectory]];
    [self yCreateFile:[NSString stringWithFormat:@"%@/ChatData/UserID_2/TmpChatData.out",yDocumentDirectory]];
}

#pragma mark 创建文件夹
- (BOOL)yCreateDirectory:(NSString *)yDocumentDirectoryPath {
    NSFileManager *yFileManager = [NSFileManager defaultManager];
    BOOL yIsDir = NO;
    if (![yFileManager fileExistsAtPath:yDocumentDirectoryPath isDirectory:&yIsDir]) {
        BOOL yIsPath = [yFileManager createDirectoryAtPath:yDocumentDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (yIsPath) {
            return YES;
        }
        return NO;
    }
    return YES;
}

#pragma mark 创建文件
- (BOOL)yCreateFile:(NSString *)yDocumentFilePath {
    NSFileManager *yFileManager = [NSFileManager defaultManager];
    BOOL yIsFile = YES;
    if (![yFileManager fileExistsAtPath:yDocumentFilePath]) {
        yIsFile = [yFileManager createFileAtPath:yDocumentFilePath contents:nil attributes:nil];
    }
    return yIsFile;
}
 */

@end
