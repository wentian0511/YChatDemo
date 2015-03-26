//
//  AppDelegate.m
//  YChatDemo
//
//  Created by 严安 on 14/12/29.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#warning 注意！！！
/**
 * 只要用户一登录，就要创建聊天的数据库、表以及对应的临时存储文件
 */

#import "AppDelegate.h"

#import "ViewController.h"
#import "YChatViewController.h"


#import "YDatabaseManager.h"
#import "YMessageModel.h"

#import "YObtainStoreTemporaryMessage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    ViewController *YView = [[ViewController alloc]init];
    UINavigationController *YNav = [[UINavigationController alloc]initWithRootViewController:YView];
    
    self.window.rootViewController = YNav;
    
//    YChatViewController *yChatVC = [[YChatViewController alloc]init];
//    UINavigationController *yNav = [[UINavigationController alloc]initWithRootViewController:yChatVC];
//    
//    self.window.rootViewController = yNav;
    
    [self.window makeKeyAndVisible];
    
    [self yGetPath];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; //
    
//    [self yCreateFalseData];x/
    
    
    
    
    // 推送
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    
    
//    NSArray *DocumentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    [YObtainStoreTemporaryMessage ySharedOSTM].yTmpChatDataStorePath = [NSString stringWithFormat:@"%@/ChatData/UserID_2/TmpChatData.out",[DocumentPaths lastObject]];
//    [[YObtainStoreTemporaryMessage ySharedOSTM] yObtainStoreTemporaryMessageAction];
    
    
    NSMutableArray *yTmpChatDataMutArr = [[NSMutableArray alloc]initWithContentsOfFile:[YObtainStoreTemporaryMessage ySharedOSTM].yTmpChatDataStorePath];
//    [yTmpChatDataMutArr removeAllObjects];
    [yTmpChatDataMutArr writeToFile:[YObtainStoreTemporaryMessage ySharedOSTM].yTmpChatDataStorePath atomically:NO];
    NSLog(@"yTmpChatDataMutArr = %@",yTmpChatDataMutArr);
//    NSMutableArray *yTmpChatDataMutArr2 = [[NSMutableArray alloc]initWithContentsOfFile:[YObtainStoreTemporaryMessage ySharedOSTM].yTmpChatDataStorePath];
//    NSLog(@"yTmpChatDataMutArr2 = %@",yTmpChatDataMutArr2);
    
    // >>>> 创建数据库和表
    [self ySetDbPathAndTableName_CreateDatabaseAndTable];
    
    // >>>> 创建存储聊天消息的临时文件
    [self yCreateTmpChatDataFile];
    
    return YES;
}

- (void)yGetPath {
    
    ///YChatDemo.app
    NSLog(@"NSBundle::%@",[[NSBundle mainBundle] resourcePath]);
    
    ///Documents
    NSArray *DocumentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"Documents:%@",[DocumentPaths firstObject]);
    //
    
    ///Caches
    NSArray *CachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSLog(@"Caches::::%@",[CachesPaths firstObject]);
    
    ///tmp
    NSLog(@"tmp:::::::%@",NSTemporaryDirectory());
    
    ///HomeDir
    NSLog(@"HomeDir:::%@",NSHomeDirectory());
    
//    NSLog(@"%@",[[NSFileManager defaultManager] subpathsAtPath:[[NSBundle mainBundle] resourcePath]]);
    
//    NSLog(@"%d",[[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/djfs",[DocumentPaths firstObject]] isDirectory:nil]);
    
//    NSLog(@"%@",[[NSFileManager defaultManager] subpathsAtPath:NSTemporaryDirectory()]);
    
    
    /** iOS8
     NSBundle::/var/mobile/Containers/Bundle/Application/90B98CBA-4B65-41D5-9107-D615E60E573F/YChatDemo.app
     Documents:/var/mobile/Containers/Data/Application/8986DEA9-75FA-4A2E-8FCC-9C8D2F7C5671/Documents
     Caches::::/var/mobile/Containers/Data/Application/8986DEA9-75FA-4A2E-8FCC-9C8D2F7C5671/Library/Caches
     tmp:::::::/var/mobile/Containers/Data/Application/8986DEA9-75FA-4A2E-8FCC-9C8D2F7C5671/tmp/
     */
    
    /**iOS7
     NSBundle::/var/mobile/Applications/5BF35CB9-6402-45F0-978B-1B08D92B487E/YChatDemo.app
     Documents:/var/mobile/Applications/5BF35CB9-6402-45F0-978B-1B08D92B487E/Documents
     Caches::::/var/mobile/Applications/5BF35CB9-6402-45F0-978B-1B08D92B487E/Library/Caches
     tmp:::::::/var/mobile/Applications/5BF35CB9-6402-45F0-978B-1B08D92B487E/tmp/
     */
    
}

// 构建假数据
- (void)yCreateFalseData {
    
    // >>>> 创建数据库和表
    [self ySetDbPathAndTableName_CreateDatabaseAndTable];
    
    // >>>> 创建存储聊天消息的临时文件
    [self yCreateTmpChatDataFile];
    
    NSMutableArray *yFalseDataMutArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 100; i++) {
        YMessageModel *yFalseMessageModel = [[YMessageModel alloc]init];
        yFalseMessageModel.yUserID = [NSString stringWithFormat:@"%d",i+1];
        yFalseMessageModel.yUserName = [NSString stringWithFormat:@"hh%d",i+1];
        yFalseMessageModel.yTime = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        
        if (arc4random()%2 == 0) {
            yFalseMessageModel.yHaveNoTime = @"NO";
        } else {
            yFalseMessageModel.yHaveNoTime = @"YES";
        }
        
        yFalseMessageModel.yHeadImage = @"http://e.hiphotos.baidu.com/image/w%3D2048/sign=5454ab5e0bf79052ef1f403e38cbd5ca/c75c10385343fbf2c6e17e6eb27eca8064388faa.jpg";
        
        yFalseMessageModel.yMessageContent = @"深刻的发生空间大公，司开几个地方，阿卡家是个打卡机构，的思考方式卡斯高度空，间是官方公会考试结果，阿克苏固定卡，还是代购费";
        
        if (arc4random()%2 == 0) {
            yFalseMessageModel.yMessageSender = @"NO";
        } else {
            yFalseMessageModel.yMessageSender = @"YES";
        }
        
        if (arc4random()%3 == 0) {
            yFalseMessageModel.yMessageSendSuccessFail = @"0";
        } else if (arc4random()%3 == 1) {
            yFalseMessageModel.yMessageSendSuccessFail = @"1";
        } else {
            yFalseMessageModel.yMessageSendSuccessFail = @"2";
        }
        
        [yFalseDataMutArr addObject:yFalseMessageModel];
    }
    
    for (int i = 0; i < [yFalseDataMutArr count]; i++) {
        YMessageModel *yFalseMessageModel2 = [yFalseDataMutArr objectAtIndex:i];
        [[YDatabaseManager yShareDBManager] yInsertWithDataObject:yFalseMessageModel2 isModifyPrimaryKey:YDEFAULT];
    }
    
}

#pragma mark 创建数据库和表
- (void)ySetDbPathAndTableName_CreateDatabaseAndTable {
    NSArray *DocumentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
#warning 根据实际情况更改
    [YDatabaseManager yShareDBManager].yDBPath = [NSString stringWithFormat:@"%@/ChatData/UserID_1/ChatData.db",[DocumentPaths firstObject]];
    [YDatabaseManager yShareDBManager].yTableName = @"TargetID_2";
    if (![[YDatabaseManager yShareDBManager] yCheckIsExistenceTable]) {
        [[YDatabaseManager yShareDBManager] yCreateTableWithClass:[YMessageModel class]];
    }
}

#pragma mark 创建临时存储文件
- (void)yCreateTmpChatDataFile {
    NSArray *yArrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *yDocumentDirectory = [yArrayPaths firstObject];
    [self yCreateDirectory:[NSString stringWithFormat:@"%@/ChatData",yDocumentDirectory]];
#warning 根据实际情况更改
    [self yCreateDirectory:[NSString stringWithFormat:@"%@/ChatData/UserID_1",yDocumentDirectory]];
    [self yCreateFile:[NSString stringWithFormat:@"%@/ChatData/UserID_1/TmpChatData.out",yDocumentDirectory]];
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




// APNs注册成功调用
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    //此token唯一与设备相关，同一设备上不同应用获取的token是一样的；
    NSLog(@"My token is: %@", deviceToken);
}

// APNs注册失败调用
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

// 接受到APNs的推送后调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@",userInfo);
    
    
    // 主动获取聊天消息
    
    NSArray *DocumentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
#warning 根据具体情况。。。
    [YObtainStoreTemporaryMessage ySharedOSTM].yTmpChatDataStorePath = [NSString stringWithFormat:@"%@/ChatData/UserID_1/TmpChatData.out",[DocumentPaths lastObject]];
    [[YObtainStoreTemporaryMessage ySharedOSTM] yObtainStoreTemporaryMessageAction];
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // 特殊处理
    
    
    
    
    
}

@end
