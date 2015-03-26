//
//  YChatViewController.m
//  YChatDemo
//
//  Created by 严安 on 15/1/7.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YChatViewController.h"

@interface YChatViewController ()

@end

@implementation YChatViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self ySetBasicProperty];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"YChatViewController");
    
    yChatTableViewController = nil;
    self.yDBPath = nil;
    self.yTableName = nil;
    self.yTargetUserID = nil;
    self.yTargetUserName = nil;
    
}

- (void)ySetBasicProperty {
    
}

#pragma mark 设置界面的基本属性
- (void)ySetBasicAttribute {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIImage *navBarImage = [[UIImage imageNamed:@"tab01"] stretchableImageWithLeftCapWidth:160.0 topCapHeight:40.0];
    if (YCURRENTSYSTEMVERSION >= 7.0) {
        [self.navigationController.navigationBar setBackgroundImage:navBarImage forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 设置界面的基本属性
    [self ySetBasicAttribute];
    
    // 创建聊天的气泡显示tableView
    [self yCreateChatTableViewController];
    
    // 创建聊天Toolbar
    [self yCreateChatToolbar];
    
}

#pragma mark 创建聊天Toolbar
- (void)yCreateChatToolbar {
    YChatToolbar *yChatToolbar = [[YChatToolbar alloc]initWithFrame:CGRectMake(0, YSCREENHEIGHT - YTRASLUCENTHEIGHT(self) - 45, YSCREENWIDTH, 45) superViewController:self];
    yChatToolbar.yChatToolbarDelegate = self;
    [yChatToolbar setBarStyle:UIBarStyleBlack];
    [self.view addSubview:yChatToolbar];
}

#pragma mark YChatToolbarDelegate 反馈ChatToolbar的时时位置 
- (void)yTellChatToolbarFrame:(CGRect)yFrame {
    NSLog(@"%@",NSStringFromCGRect(yFrame));
    // 给yChatTableViewController设置新的tableView
//    yChatTableViewController.yChatTableView.frame = CGRectMake(0, -(YSCREENHEIGHT - YTRASLUCENTHEIGHT(self) - 45 - yFrame.origin.y), YSCREENWIDTH, YSCREENHEIGHT - YTRASLUCENTHEIGHT(self) - 45);
    yChatTableViewController.yChatTableView.frame = CGRectMake(0, 0, YSCREENWIDTH, yFrame.origin.y);
    [yChatTableViewController yScrollToBottom];
    [yChatTableViewController yAdjustmentUnreadMessageButtonFrame];
}

#pragma mark YChatToolbarDelegate 反馈发送的输入框的内容
- (void)yTellExpandingTextViewText:(NSString *)yText {
    NSLog(@"%@",yText);
    [yChatTableViewController ySendChatMessageOutside:yText];
}

#pragma mark 创建装载cell的ChatTableViewController
- (void)yCreateChatTableViewController {
    if (!yChatTableViewController) {
        yChatTableViewController = [[YChatTableViewController alloc]init];
        yChatTableViewController.yDBPath = _yDBPath;
        yChatTableViewController.yTableName = _yTableName;
        yChatTableViewController.yTargetUserID = _yTargetUserID;
        yChatTableViewController.yTargetUserName = _yTargetUserName;
        yChatTableViewController.yTmpChatDataPath = _yTmpChatDataPath;
        [self.view addSubview:yChatTableViewController.view];
    }
}

#pragma mark 创建TableView，替换TableViewController中的TableView
- (YChatTableView *)yCreateTableView {
    YChatTableView *yTableView = [[YChatTableView alloc]initWithFrame:CGRectMake(0, 0, YSCREENWIDTH, YSCREENHEIGHT - YTRASLUCENTHEIGHT(self) - 45) style:UITableViewStylePlain];
    yTableView.backgroundColor = [UIColor orangeColor];
    return yTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
