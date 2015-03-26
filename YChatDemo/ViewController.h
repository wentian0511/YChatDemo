//
//  ViewController.h
//  YChatDemo
//
//  Created by 严安 on 14/12/29.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YChatToolbar.h"
#import "YChatTableView.h"
#import "YChatTableViewController.h"

@interface ViewController : UIViewController<YChatToolbarDelegate> {
    
    YChatTableViewController *yChatTableViewController;
    
}


@end

