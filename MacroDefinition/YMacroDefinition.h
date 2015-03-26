//
//  YMacroDefinition.h
//  YChatDemo
//
//  Created by 严安 on 14/12/29.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#ifndef YChatDemo_YMacroDefinition_h
#define YChatDemo_YMacroDefinition_h

///当前屏幕的高
#define YSCREENHEIGHT [[UIScreen mainScreen]bounds].size.height
///当前屏幕的宽
#define YSCREENWIDTH [[UIScreen mainScreen]bounds].size.width

///当前系统的版本
#define YCURRENTSYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]

///计算是否保留navigationBar的高度
#define YTRASLUCENTHEIGHT(yViewController) (yViewController.navigationController.navigationBar.isTranslucent ? 0.0 : 64.0)

///计算16进制的色值转化成RGB
#define UIColorFromRGB(rgbValue) \
        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.0]

///RGB 0 ~ 255
#define  YUIColorRGB(r,g,b,a)  [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)]

///发送请求的地址
#define SERVER_ADDRESS @"http://182.92.221.233/constellation/CommunityJSON.php"

///发送请求的路径
//#define YCHATPATH @"constellation/CommunityJSON.php"

#define msgType_getMessage              @"7120" // 获取消息

#define msgType_sendMessage             @"7117" // 发送消息

#define YMessageContentBgImageViewWidth 66 // (YSCREENWIDTH - 55*2)

#endif
