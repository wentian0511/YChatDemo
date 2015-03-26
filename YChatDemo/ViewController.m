//
//  ViewController.m
//  YChatDemo
//
//  Created by 严安 on 14/12/29.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import "ViewController.h"

#import "YChatViewController.h"

#import "SSViewController.h"

#import "YTSTMutualTransformation.h"

#import "YIntelligentTimeDisplay.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)ySetBasicAttribute {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIImage *navBarImage = [[UIImage imageNamed:@"111"] stretchableImageWithLeftCapWidth:22.5 topCapHeight:18.0];
    if (YCURRENTSYSTEMVERSION >= 7.0) {
        [self.navigationController.navigationBar setBackgroundImage:navBarImage forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self ySetBasicAttribute];
//
//    [self yCreateChatTableViewController];
//    
//    [self yCreateChatToolbar];
    
//    NSInteger iiii = [[NSDate date] timeIntervalSince1970];
    
//    NSLog(@"%ld",iiii);  ///1420686646.580370
                         ///1420686716
                         ///254317405
    
    
//    NSLog(@"%@",[YTSTMutualTransformation yGetCurrentTime:@"yyyy-MM-dd HH:mm:ss"]); ///1420709647
                                                                                    ///1420709647
    
//    NSLog(@"%@",[YTSTMutualTransformation yTimeToTimeStamp:@"2015-01-08 17:34:07" withTimeFormatter:nil]);
    
    
//    NSLog(@"%@",[YIntelligentTimeDisplay yIntelligentTimeDisplayWithTimeStamp:@"1420300000"]);
    
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDate *now;
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    now=[NSDate dateWithTimeIntervalSince1970:[[YTSTMutualTransformation yTimeToTimeStamp:@"2015-01-10 00:12:35" withTimeFormatter:nil] longLongValue]];
//    comps = [calendar components:unitFlags fromDate:now];
//    NSLog(@"%ld",(long)[comps weekday]);
    
    
    
    
    UIButton *yButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yButton.frame = CGRectMake(100, 100, 100, 100);
    [yButton setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:yButton];
    [yButton addTarget:self action:@selector(yGotoChatVC:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)yGotoChatVC:(UIButton *)sender {
    YChatViewController *yChatVC = [[YChatViewController alloc]init];
    
    NSArray *DocumentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
#warning 根据需要修改
    yChatVC.yDBPath = [NSString stringWithFormat:@"%@/ChatData/UserID_1/ChatData.db",[DocumentPaths firstObject]];
#warning 根据需要修改
    yChatVC.yTableName = @"TargetID_2";
#warning 根据需要修改
    yChatVC.yTargetUserID = @"2";
#warning 根据需要修改
    yChatVC.yTargetUserName = @"alalal";
#warning 根据需要修改
    yChatVC.yTmpChatDataPath = [NSString stringWithFormat:@"%@/ChatData/UserID_1/TmpChatData.out",[DocumentPaths firstObject]];;
    
    
    [self.navigationController pushViewController:yChatVC animated:YES];
}












- (void)yGotoSSVC:(UIButton *)sender {
    SSViewController *yChatVC = [[SSViewController alloc]init];
    [self.navigationController pushViewController:yChatVC animated:YES];
}

#pragma mark 创建聊天Toolbar
- (void)yCreateChatToolbar {
    YChatToolbar *yChatToolbar = [[YChatToolbar alloc]initWithFrame:CGRectMake(0, YSCREENHEIGHT - YTRASLUCENTHEIGHT(self) - 45, YSCREENWIDTH, 45) superViewController:self];
    yChatToolbar.yChatToolbarDelegate = self;
    [yChatToolbar setBarStyle:UIBarStyleBlack];
    [self.view addSubview:yChatToolbar];
}

#pragma mark 反馈ChatToolbar的时时位置
- (void)yTellChatToolbarFrame:(CGRect)yFrame {
    NSLog(@"%@",NSStringFromCGRect(yFrame));
//    yChatTableViewController.tableView.frame = CGRectMake(0, -(YSCREENHEIGHT - YTRASLUCENTHEIGHT(self) - yFrame.origin.y - 45), YSCREENWIDTH, YSCREENHEIGHT - YTRASLUCENTHEIGHT(self) - 45);
}

#pragma mark 反馈发送的输入框的内容
- (void)yTellExpandingTextViewText:(NSString *)yText {
    NSLog(@"%@",yText);
}

#pragma mark 创建ChatTableViewController
- (void)yCreateChatTableViewController {
    if (!yChatTableViewController) {
//        yChatTableViewController = [[YChatTableViewController alloc]initWithStyle:UITableViewStylePlain];
//        NSLog(@"YSCREENHEIGHT:::%f",YSCREENHEIGHT);
//        [yChatTableViewController setTableView:[self yCreateTableView]];
//        UIView * yMaskHeaderFooterView = [self yCreateMaskHeaderFooterView];
//        [yChatTableViewController.tableView setTableHeaderView:yMaskHeaderFooterView];
//        [yChatTableViewController.tableView setTableFooterView:yMaskHeaderFooterView];
//        [self addChildViewController:yChatTableViewController];
//        [self.view addSubview:yChatTableViewController.tableView];
    }
}

#pragma mark 创建TableView，替换TableViewController中的TableView
- (YChatTableView *)yCreateTableView {
    YChatTableView *yTableView = [[YChatTableView alloc]initWithFrame:CGRectMake(0, 0, YSCREENWIDTH, YSCREENHEIGHT - YTRASLUCENTHEIGHT(self) - 45) style:UITableViewStylePlain];
    yTableView.backgroundColor = [UIColor orangeColor];
    return yTableView;
}

- (UIView *)yCreateMaskHeaderFooterView {
    UIView *yMaskHeaderFooterView = [[UIView alloc]init];
    yMaskHeaderFooterView.backgroundColor = [UIColor clearColor];
    return yMaskHeaderFooterView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
