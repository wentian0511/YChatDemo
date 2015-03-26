//
//  YChatTableViewController.m
//  YChatDemo
//
//  Created by 严安 on 15/1/2.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YChatTableViewController.h"

// 数据库管理类
#import "YDatabaseManager.h"

#warning Potentially 需要根据调用类的不同更改.
#import "YChatViewController.h"

// 消息Model
#import "YMessageModel.h"

// 时间戳装换成时间
#import "YIntelligentTimeDisplay.h"

@interface YChatTableViewController ()

@property (nonatomic, copy)UIView *yMaskHeaderFooterView;

@property (nonatomic, copy)UIView *yTopRefreshView;

@property (nonatomic, copy)UIButton *yUnreadMessageButton;

@end

@implementation YChatTableViewController

- (instancetype)init {
    if (self = [super init]) {
        // 初始化一些对象
        [self yInitObject];
        // 设置通知的监听
        [self ySetNotification];
    }
    return self;
}

#pragma mark dealloc析构
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YHAVENEWDATA" object:nil];
    
    _yChatTableView = nil;
    _yTestSizeLabel = nil;
}

#pragma mark 初始化一些对象
- (void)yInitObject {
    yAccessMutArray = [[NSMutableArray alloc]init];
    isScrollBottom = YES;
    
    if (!_yTestSizeLabel) {
        _yTestSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 35, 20, 22)];
        _yTestSizeLabel.backgroundColor = [UIColor clearColor];
        _yTestSizeLabel.font = [UIFont systemFontOfSize:18.0];
        _yTestSizeLabel.textColor = [UIColor blackColor];
        _yTestSizeLabel.textAlignment = NSTextAlignmentLeft;
        _yTestSizeLabel.numberOfLines = 0;
        _yTestSizeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
}

#pragma mark 设置通知的监听
- (void)ySetNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yHaveNewData:) name:@"YHAVENEWDATA" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置一些基本属性
    [self ySetBasicAttribute];
    
    // 初始化数据库操作
    [self yDatabaseTableHandle];
    
    // 创建聊天的tableView
    [self yCreateChatTableView];
    
    // 取数据刷新界面
    [self yAddTmpChatDataToDatabase:NO];
    
}

#pragma mark 设置一些基本属性
- (void)ySetBasicAttribute {
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark 初始化数据库操作
- (void)yDatabaseTableHandle {
    [YDatabaseManager yShareDBManager].yDBPath = _yDBPath;
    [YDatabaseManager yShareDBManager].yTableName = _yTableName;
}

#pragma mark 创建聊天的tableView
- (void)yCreateChatTableView {
    if (!_yChatTableView) {
        _yChatTableView = [[YChatTableView alloc]initWithFrame:CGRectMake(0, 0, YSCREENWIDTH, YSCREENHEIGHT - YTRASLUCENTHEIGHT(self) - 45) style:UITableViewStylePlain];
        _yChatTableView.backgroundColor = [UIColor clearColor];
        _yChatTableView.delegate = self;
        _yChatTableView.dataSource = self;
        _yChatTableView.tableHeaderView = [self yCreateMaskHeaderFooterView];
        _yChatTableView.tableFooterView = [self yCreateMaskHeaderFooterView];
        _yChatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _yChatTableView.scrollsToTop = YES;
        /*
        [_yChatTableView addSubview:[self yCreateTopRefreshView]];
         */
        [self.view addSubview:_yChatTableView];
    }
}

#pragma mark 创建遮盖TableView的HeaderView和FooterView的view
- (UIView *)yCreateMaskHeaderFooterView {
    if (!_yMaskHeaderFooterView) {
        _yMaskHeaderFooterView = [[UIView alloc]init];
        _yMaskHeaderFooterView.backgroundColor = [UIColor clearColor];
    }
    return _yMaskHeaderFooterView;
}

// >>> 保留
#pragma mark 创建触顶加载更多指示器
- (UIView *)yCreateTopRefreshView {
    _yTopRefreshView = [[UIView alloc]initWithFrame:CGRectMake(0.0, -40.0, YSCREENWIDTH, 40.0)];
    _yTopRefreshView.backgroundColor = [UIColor redColor];
    
    UIActivityIndicatorView *yActivityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    yActivityIndicatorView.center = CGPointMake(YSCREENWIDTH/3, 20.0);
    [_yTopRefreshView addSubview:yActivityIndicatorView];
    [yActivityIndicatorView startAnimating];
    
    UILabel *yActivityLabel = [[UILabel alloc]initWithFrame:CGRectMake(YSCREENWIDTH/3 + 20.0, 10.0, 70.0, 20.0)];
    yActivityLabel.textAlignment = NSTextAlignmentCenter;
    yActivityLabel.textColor = [UIColor blackColor];
    yActivityLabel.text = @"加载中...";
    yActivityLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [_yTopRefreshView addSubview:yActivityLabel];
    
    return _yTopRefreshView;
}
// <<<

#pragma mark 创建未读消息button
- (void)yCreateUnreadMessageButton:(NSString *)yNewMessageNumber {
    if (!_yUnreadMessageButton) {
        _yUnreadMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _yUnreadMessageButton.frame = CGRectMake(_yChatTableView.bounds.size.width - 47.5, _yChatTableView.bounds.size.height - 45.0, 35.0, 41.5);
        if ([yNewMessageNumber intValue] > 99) {
            [_yUnreadMessageButton setTitle:@"99" forState:UIControlStateNormal];
        } else {
            [_yUnreadMessageButton setTitle:yNewMessageNumber forState:UIControlStateNormal];
        }
        [_yUnreadMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_yUnreadMessageButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_yUnreadMessageButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_yUnreadMessageButton setTitleEdgeInsets:(UIEdgeInsets){-3,0,3,0}];
        [_yUnreadMessageButton setBackgroundImage:[UIImage imageNamed:@"aio_unread_bg"] forState:UIControlStateNormal];
        [_yUnreadMessageButton addTarget:self action:@selector(yScrollToBottomImmediately:) forControlEvents:UIControlEventTouchUpInside];
        [self.view.superview addSubview:_yUnreadMessageButton];
    } else {
        int yTmpNewMessageNumber = [_yUnreadMessageButton.titleLabel.text intValue];
        yTmpNewMessageNumber += [yNewMessageNumber intValue];
        if (yTmpNewMessageNumber > 99) {
            [_yUnreadMessageButton setTitle:@"99" forState:UIControlStateNormal];
        } else {
            [_yUnreadMessageButton setTitle:[NSString stringWithFormat:@"%d",yTmpNewMessageNumber] forState:UIControlStateNormal];
        }
        _yUnreadMessageButton.hidden = NO;
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return yAccessMutArray.count;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /** 动态调整cell高度 */
    
    YMessageModel *yMessageModel = (YMessageModel *)[yAccessMutArray objectAtIndex:indexPath.row];
    _yTestSizeLabel.text = yMessageModel.yMessageContent;
    
    if ([yMessageModel.yMessageSender isEqualToString:@"NO"]) {
        // 左边
        CGSize yTestSizeLabelSize = [_yTestSizeLabel sizeThatFits:CGSizeMake(YSCREENWIDTH - 55*2 - 30, __FLT_MAX__)];
        if ([yMessageModel.yHaveNoTime isEqualToString:@"YES"]) {
            // 显示时间
            return (54 + ((yTestSizeLabelSize.height > 22.0) ? (yTestSizeLabelSize.height - 22.0) : 0) + 51);
        } else {
            // 不显示时间
            return (54 + ((yTestSizeLabelSize.height > 22.0) ? (yTestSizeLabelSize.height - 22.0) : 0) + 20);
        }
    } else {
        // 右边
        CGSize yTestSizeLabelSize = [_yTestSizeLabel sizeThatFits:CGSizeMake(YSCREENWIDTH - 55*2 - 35, __FLT_MAX__)];
        if ([yMessageModel.yHaveNoTime isEqualToString:@"YES"]) {
            // 显示时间
            return (54 + ((yTestSizeLabelSize.height > 22.0) ? (yTestSizeLabelSize.height - 22.0) : 0) + 51);
        } else {
            // 不显示时间
            return (54 + ((yTestSizeLabelSize.height > 22.0) ? (yTestSizeLabelSize.height - 22.0) : 0) + 20);
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YMessageModel *yMessageModel = (YMessageModel *)[yAccessMutArray objectAtIndex:indexPath.row];
    
    if ([yMessageModel.yMessageSender isEqualToString:@"NO"]) {
        // 左边
        if ([yMessageModel.yHaveNoTime isEqualToString:@"YES"]) {
            // 显示时间
            YLeftBubbleHaveTimeTextCell *yTableViewCell = [tableView dequeueReusableCellWithIdentifier:yTableViewCell_LeftBubble_HaveTime];
            
            if (!yTableViewCell) {
                yTableViewCell = [[YLeftBubbleHaveTimeTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yTableViewCell_LeftBubble_HaveTime];
                yTableViewCell.backgroundColor = [UIColor clearColor];
                yTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
//            yTableViewCell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            
            [self ySetLeftBubbleHaveTimeTextCell:yTableViewCell cellForRowAtIndexPath:indexPath];
            
            return yTableViewCell;
        } else {
            // 不显示时间
            YLeftBubbleNoTimeTextCell *yTableViewCell = [tableView dequeueReusableCellWithIdentifier:yTableViewCell_LeftBubble_NoTime];
            
            if (!yTableViewCell) {
                yTableViewCell = [[YLeftBubbleNoTimeTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yTableViewCell_LeftBubble_NoTime];
                yTableViewCell.backgroundColor = [UIColor clearColor];
                yTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
//            yTableViewCell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            
            [self ySetLeftBubbleNoTimeTextCell:yTableViewCell cellForRowAtIndexPath:indexPath];
            
            return yTableViewCell;
        }
    } else {
        // 右边
        if ([yMessageModel.yHaveNoTime isEqualToString:@"YES"]) {
            // 显示时间
            YRightBubbleHaveTimeTextCell *yTableViewCell = [tableView dequeueReusableCellWithIdentifier:yTableViewCell_RightBubble_HaveTime];
            
            if (!yTableViewCell) {
                yTableViewCell = [[YRightBubbleHaveTimeTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yTableViewCell_RightBubble_HaveTime];
                yTableViewCell.backgroundColor = [UIColor clearColor];
                yTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
//            yTableViewCell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            
            yTableViewCell.yDelegate = self;
            
            [self ySetRightBubbleHaveTimeTextCell:yTableViewCell cellForRowAtIndexPath:indexPath];
            
            return yTableViewCell;
        } else {
            // 不显示时间
            YRightBubbleNoTimeTextCell *yTableViewCell = [tableView dequeueReusableCellWithIdentifier:yTableViewCell_RightBubble_NoTime];
            
            if (!yTableViewCell) {
                yTableViewCell = [[YRightBubbleNoTimeTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yTableViewCell_RightBubble_NoTime];
                yTableViewCell.backgroundColor = [UIColor clearColor];
                yTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
//            yTableViewCell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            
            yTableViewCell.yDelegate = self;
            
            [self ySetRightBubbleNoTimeTextCell:yTableViewCell cellForRowAtIndexPath:indexPath];
            
            return yTableViewCell;
        }
    }
    
}

#pragma mark Cell中的内容设置
/** 显示时间的左边气泡 */
- (void)ySetLeftBubbleHaveTimeTextCell:(YLeftBubbleHaveTimeTextCell *)yTableViewCell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMessageModel *yMessageModel = (YMessageModel *)[yAccessMutArray objectAtIndex:indexPath.row];
    
    [yTableViewCell setYMessageContentLabelText:yMessageModel.yMessageContent];
    [yTableViewCell setYTimeLabelText:[YIntelligentTimeDisplay yIntelligentTimeDisplayWithTimeStamp:yMessageModel.yTime]];
    [yTableViewCell setYHeadImageViewURL:yMessageModel.yHeadImage];
}

/** 不显示时间的左边气泡 */
- (void)ySetLeftBubbleNoTimeTextCell:(YLeftBubbleNoTimeTextCell *)yTableViewCell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMessageModel *yMessageModel = (YMessageModel *)[yAccessMutArray objectAtIndex:indexPath.row];
    
    [yTableViewCell setYMessageContentLabelText:yMessageModel.yMessageContent];
    [yTableViewCell setYHeadImageViewURL:yMessageModel.yHeadImage];
}

/** 显示时间的右边气泡 */
- (void)ySetRightBubbleHaveTimeTextCell:(YRightBubbleHaveTimeTextCell *)yTableViewCell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMessageModel *yMessageModel = (YMessageModel *)[yAccessMutArray objectAtIndex:indexPath.row];
    
    [yTableViewCell setYMessageContentLabelText:yMessageModel.yMessageContent];
    [yTableViewCell setYTimeLabelText:[YIntelligentTimeDisplay yIntelligentTimeDisplayWithTimeStamp:yMessageModel.yTime]];
    [yTableViewCell setYHeadImageViewURL:yMessageModel.yHeadImage];
    
    if ([yMessageModel.yMessageSendSuccessFail isEqualToString:@"0"]) {
        [yTableViewCell setYActivityIndicatorViewHidden:YES];
        [yTableViewCell setYWhetherAgainSendButtonHidden:NO];
    } else if ([yMessageModel.yMessageSendSuccessFail isEqualToString:@"1"]) {
        [yTableViewCell setYActivityIndicatorViewHidden:YES];
        [yTableViewCell setYWhetherAgainSendButtonHidden:YES];
    } else if ([yMessageModel.yMessageSendSuccessFail isEqualToString:@"2"]) {
        [yTableViewCell setYActivityIndicatorViewHidden:NO];
        [yTableViewCell setYWhetherAgainSendButtonHidden:YES];
    }
}

/** 不显示时间的右边气泡 */
- (void)ySetRightBubbleNoTimeTextCell:(YRightBubbleNoTimeTextCell *)yTableViewCell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMessageModel *yMessageModel = (YMessageModel *)[yAccessMutArray objectAtIndex:indexPath.row];
    
    [yTableViewCell setYMessageContentLabelText:yMessageModel.yMessageContent];
    [yTableViewCell setYHeadImageViewURL:yMessageModel.yHeadImage];
    
    if ([yMessageModel.yMessageSendSuccessFail isEqualToString:@"0"]) {
        [yTableViewCell setYActivityIndicatorViewHidden:YES];
        [yTableViewCell setYWhetherAgainSendButtonHidden:NO];
    } else if ([yMessageModel.yMessageSendSuccessFail isEqualToString:@"1"]) {
        [yTableViewCell setYActivityIndicatorViewHidden:YES];
        [yTableViewCell setYWhetherAgainSendButtonHidden:YES];
    } else if ([yMessageModel.yMessageSendSuccessFail isEqualToString:@"2"]) {
        [yTableViewCell setYActivityIndicatorViewHidden:NO];
        [yTableViewCell setYWhetherAgainSendButtonHidden:YES];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 0.0f) {
        /** 滚动到顶部 */
        isScrollBottom = NO;
        NSLog(@"滚动到顶部");
        [self yGetDataUpdataUI];
    } else if (scrollView.contentSize.height == (scrollView.bounds.size.height + scrollView.contentOffset.y)) {
        /** 滚动到底部 */
        NSLog(@"滚动到底部");
        isScrollBottom = YES;
        _yUnreadMessageButton.hidden = YES;
        [_yUnreadMessageButton setTitle:@"0" forState:UIControlStateNormal];
    } else {
        if (isScrollBottom) {
            isScrollBottom = NO;
        }
    }
}

#pragma mark 滚动到底部
- (void)scrollviewDidScrollToBottom {
    NSIndexPath *yIndexPath =[NSIndexPath indexPathForRow:(yAccessMutArray.count - 1) inSection:0];
    [_yChatTableView scrollToRowAtIndexPath:yIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark 从数据库的表中取出最新的数据
- (void)yGetLatestSendedData:(NSString *)yNumber {
    if (![yNumber isEqualToString:@"0"]) {
        if (!isScrollBottom) {
            [self yCreateUnreadMessageButton:yNumber];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /** 子线程 */
            NSInteger yTableDataAllNumber = [[YDatabaseManager yShareDBManager] yGetTableDataNumber];
            NSString *yRange = [NSString stringWithFormat:@"(%d,%d)",(int)(yTableDataAllNumber - [yNumber intValue] + 1),(int)(yTableDataAllNumber)];
            NSArray *yTmpArray = [[YDatabaseManager yShareDBManager] yQueryWithClass:[YMessageModel class] withRange:yRange withCondition:nil withOrder:nil];
            for (YMessageModel *yMessageModel in yTmpArray) {
                [yAccessMutArray addObject:yMessageModel];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                /** 主线程 */
                [self yUpdataYChatTableViewAndScrollPositionBottomWithAnimated:YES];
            });
        });
    }
}

#pragma mark 取数据刷新界面
- (void)yGetDataUpdataUI {
    if (yRecordHaveTakeToFew >= LOADDATANUMBER) {
        [self yGetSpecifiedRange:[NSString stringWithFormat:@"(%ld,%ld)",(unsigned long)yRecordHaveTakeToFew - (LOADDATANUMBER - 1),(unsigned long)yRecordHaveTakeToFew]];
    } else if (yRecordHaveTakeToFew == 1) {
        NSLog(@"取完。。。");
    } else if (yRecordHaveTakeToFew < LOADDATANUMBER) {
        [self yGetSpecifiedRange:[NSString stringWithFormat:@"(1,%ld)",(unsigned long)yRecordHaveTakeToFew]];
    }
}

#pragma mark 从数据库的表中取出指定范围的数据（第一次进入该页面以及针对触顶刷新加载更多设计）
- (void)yGetSpecifiedRange:(NSString *)yRange {
    NSLog(@"yRange:%@",yRange);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /** 子线程 */
        NSArray *yTransitionArray = [[NSArray alloc]initWithArray:[[YDatabaseManager yShareDBManager] yQueryWithClass:[YMessageModel class] withRange:yRange withCondition:nil withOrder:nil]];
        if ([yAccessMutArray count] == 0) {
            [yAccessMutArray setArray:yTransitionArray];
        } else {
            for (int i = (int)[yTransitionArray count] - 1; i >= 0; i--) {
                [yAccessMutArray insertObject:[yTransitionArray objectAtIndex:i] atIndex:0];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /** 主线程 */
            
            [_yChatTableView reloadData];
            
            if (yRecordHaveTakeToFew == yRecordDatabaseNumber) {
                [self yUpdataYChatTableViewAndScrollPositionBottomWithAnimated:NO];
                if (yRecordHaveTakeToFew > LOADDATANUMBER) {
                    yRecordHaveTakeToFew -= LOADDATANUMBER;
                } else {
                    yRecordHaveTakeToFew = 1;
                }
            } else if (yRecordHaveTakeToFew < LOADDATANUMBER){
                NSIndexPath *yItemIndexPath = [NSIndexPath indexPathForRow:(yRecordHaveTakeToFew) inSection:0];
                [_yChatTableView scrollToRowAtIndexPath:yItemIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                yRecordHaveTakeToFew = 1;
            } else if (yRecordHaveTakeToFew >= LOADDATANUMBER) {
                NSIndexPath *yItemIndexPath = [NSIndexPath indexPathForRow:LOADDATANUMBER inSection:0];
                [_yChatTableView scrollToRowAtIndexPath:yItemIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                yRecordHaveTakeToFew -= LOADDATANUMBER;
            }
            
            [_yChatTableView flashScrollIndicators];
            
        });
    });
}

#pragma mark 是否重新发送消息（右边有时间的气泡）
- (void)yRBHTWhetherAgainSendMessage:(YRightBubbleHaveTimeTextCell *)yRightBubbleHaveTimeTextCell {
    YUIActionSheet *yActionSheet = [[YUIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"重新发送" otherButtonTitles:nil, nil];
    yActionSheet.tag = 110;
    yActionSheet.yObject = yRightBubbleHaveTimeTextCell;
    [yActionSheet showInView:self.view];
}

#pragma mark 是否重新发送消息（右边没有时间的气泡）
- (void)yRBNTWhetherAgainSendMessage:(YRightBubbleNoTimeTextCell *)yRightBubbleNoTimeTextCell {
    YUIActionSheet *yActionSheet = [[YUIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"重新发送" otherButtonTitles:nil, nil];
    yActionSheet.tag = 119;
    yActionSheet.yObject = yRightBubbleNoTimeTextCell;
    [yActionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    /** 检查网络是否畅通 */
    
    if (actionSheet.tag == 110) {
        if (buttonIndex == 0) { // 重新发送
            YRightBubbleHaveTimeTextCell *yRightBubbleHaveTimeTextCell = (YRightBubbleHaveTimeTextCell *)((YUIActionSheet *)actionSheet).yObject;
            NSIndexPath *yIndexPath = [_yChatTableView indexPathForCell:yRightBubbleHaveTimeTextCell];
            YMessageModel *yMessageModel = (YMessageModel *)[yAccessMutArray objectAtIndex:yIndexPath.row];
            [[YDatabaseManager yShareDBManager] yDeleteWithDataObject:yMessageModel];
            YMessageModel *yTmpMessageModel = [yMessageModel mutableCopy];
            [yAccessMutArray removeObject:yMessageModel];
            yTmpMessageModel.yPrimarykey = @""; // 清空主键（必须设置）
            yTmpMessageModel.yMessageSendSuccessFail = @"2";
            yTmpMessageModel.yTime = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
            if ([self yAddDataContrastCurrentTimeWhetherNeedPresentTime:yTmpMessageModel]) {
                yTmpMessageModel.yHaveNoTime = @"YES";
            } else {
                yTmpMessageModel.yHaveNoTime = @"NO";
            }
            [[YDatabaseManager yShareDBManager] yInsertWithDataObject:yTmpMessageModel isModifyPrimaryKey:YDEFAULT];
            NSArray *yTmpArr = [[YDatabaseManager yShareDBManager] yGetTableLastDataWithClass:[YMessageModel class]];
            [yAccessMutArray addObject:[yTmpArr lastObject]];
            [self yUpdataYChatTableViewAndScrollPositionBottomWithAnimated:NO];
            
            /** 发送消息code */
            [self ySendChatMessageInside:[yTmpArr lastObject]];
        }
    } else if (actionSheet.tag == 119) {
        if (buttonIndex == 0) { // 重新发送
            YRightBubbleNoTimeTextCell *yRightBubbleNoTimeTextCell = (YRightBubbleNoTimeTextCell *)((YUIActionSheet *)actionSheet).yObject;
            NSIndexPath *yIndexPath = [_yChatTableView indexPathForCell:yRightBubbleNoTimeTextCell];
            YMessageModel *yMessageModel = (YMessageModel *)[yAccessMutArray objectAtIndex:yIndexPath.row];
            [[YDatabaseManager yShareDBManager] yDeleteWithDataObject:yMessageModel];
            YMessageModel *yTmpMessageModel = [yMessageModel mutableCopy];
            [yAccessMutArray removeObject:yMessageModel];
            yTmpMessageModel.yPrimarykey = @""; // 清空主键（必须设置）
            yTmpMessageModel.yMessageSendSuccessFail = @"2";
            yTmpMessageModel.yTime = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
            if ([self yAddDataContrastCurrentTimeWhetherNeedPresentTime:yTmpMessageModel]) {
                yTmpMessageModel.yHaveNoTime = @"YES";
            } else {
                yTmpMessageModel.yHaveNoTime = @"NO";
            }
            [[YDatabaseManager yShareDBManager] yInsertWithDataObject:yTmpMessageModel isModifyPrimaryKey:YDEFAULT];
            NSArray *yTmpArr = [[YDatabaseManager yShareDBManager] yGetTableLastDataWithClass:[YMessageModel class]];
            [yAccessMutArray addObject:[yTmpArr lastObject]];
            [self yUpdataYChatTableViewAndScrollPositionBottomWithAnimated:NO];
            
            /** 发送消息code */
            [self ySendChatMessageInside:[yTmpArr lastObject]];
        }
    }
}

#pragma mark 发送聊天消息（外部调用）
- (void)ySendChatMessageOutside:(NSString *)yMessageContent {
    [[YDatabaseManager yShareDBManager] yInsertWithDataObject:[self yCreateSendDataModel:yMessageContent] isModifyPrimaryKey:YDEFAULT];
    NSArray *yTmpArray = [[YDatabaseManager yShareDBManager] yGetTableLastDataWithClass:[YMessageModel class]];
    [yAccessMutArray addObject:[yTmpArray lastObject]];
    [_yChatTableView reloadData];
    NSIndexPath *yIndexPath = [NSIndexPath indexPathForRow:(yAccessMutArray.count - 1) inSection:0];
    [_yChatTableView scrollToRowAtIndexPath:yIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self ySendChatMessageInside:[yAccessMutArray lastObject]];
}

#pragma mark 构建发送的数据模型
- (YMessageModel *)yCreateSendDataModel:(NSString *)yMessageContent {
    YMessageModel *yMessageModel = [[YMessageModel alloc]init];
    yMessageModel.yPrimarykey = @"";
#warning 根据具体情况。。。
    yMessageModel.yUserID = @"1";
#warning 根据具体情况。。。
    yMessageModel.yUserName = @"qwert";
    yMessageModel.yTime = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    if ([self yAddDataContrastCurrentTimeWhetherNeedPresentTime:yMessageModel]) {
        yMessageModel.yHaveNoTime = @"YES";
    } else {
        yMessageModel.yHaveNoTime = @"NO";
    }
#warning 根据具体情况。。。
    yMessageModel.yHeadImage = @"http://e.hiphotos.baidu.com/image/w%3D2048/sign=5454ab5e0bf79052ef1f403e38cbd5ca/c75c10385343fbf2c6e17e6eb27eca8064388faa.jpg";
    yMessageModel.yMessageContent = yMessageContent;
    yMessageModel.yMessageSender = @"YES";
    yMessageModel.yMessageSendSuccessFail = @"2";
    
    return yMessageModel;
}

#pragma mark 发送聊天消息（内部调用）
- (void)ySendChatMessageInside:(YMessageModel *)yMessageModel {
#warning 根据具体情况。。。
    [[YTransceiverMessageManager ySharedTMMAnager] ySendMessage:yMessageModel.yMessageContent withSelfID:@"1" withSendTraget:_yTargetUserID withSendedObject:yMessageModel withMessageType:YMessageText withSuccessBlock:^(NSString *ySendDataResponse, id ySendedObject) {
        YMessageModel *yMessageModel = (YMessageModel *)ySendedObject;
        YMessageModel *yTmpMessageModel = [self yCopyChatDataModel:yMessageModel withMessageSendSuccessFail:@"1"];
        [[YDatabaseManager yShareDBManager] yUpdateWithDataObject:yTmpMessageModel withCondition:nil];
        NSUInteger yLocation = [yAccessMutArray indexOfObject:yMessageModel];
        [yAccessMutArray replaceObjectAtIndex:yLocation withObject:yTmpMessageModel];
        [_yChatTableView reloadData];
    } withFailedBlock:^(NSString *ySendDataResponse, id ySendedObject) {
        YMessageModel *yMessageModel = (YMessageModel *)ySendedObject;
        YMessageModel *yTmpMessageModel = [self yCopyChatDataModel:yMessageModel withMessageSendSuccessFail:@"0"];
        [[YDatabaseManager yShareDBManager] yUpdateWithDataObject:yTmpMessageModel withCondition:nil];
        NSUInteger yLocation = [yAccessMutArray indexOfObject:yMessageModel];
        [yAccessMutArray replaceObjectAtIndex:yLocation withObject:yTmpMessageModel];
        [_yChatTableView reloadData];
    }];
}

#pragma mark copy数据模型
- (YMessageModel *)yCopyChatDataModel:(YMessageModel *)yTmpMessageModel withMessageSendSuccessFail:(NSString *)ySendState{
    YMessageModel *yMessageModel = [[YMessageModel alloc]init];
    yMessageModel.yPrimarykey = yTmpMessageModel.yPrimarykey;
    yMessageModel.yUserID = yTmpMessageModel.yUserID;
    yMessageModel.yUserName = yTmpMessageModel.yUserName;
    yMessageModel.yTime = yTmpMessageModel.yTime;
    yMessageModel.yHaveNoTime = yTmpMessageModel.yHaveNoTime;
    yMessageModel.yHeadImage = yTmpMessageModel.yHeadImage;
    yMessageModel.yMessageContent = yTmpMessageModel.yMessageContent;
    yMessageModel.yMessageSender = yTmpMessageModel.yMessageSender;
    yMessageModel.yMessageSendSuccessFail = ySendState;
    
    return yMessageModel;
}

#pragma mark 增加数据比对是否需要显示时间
- (BOOL)yAddDataContrastCurrentTimeWhetherNeedPresentTime:(YMessageModel *)yMessageModel {
    for (int i = (int)[yAccessMutArray count] - 1; i >= 0; i-- ) {
        YMessageModel *yTmpMessageModel = [yAccessMutArray objectAtIndex:i];
        if ([yTmpMessageModel.yHaveNoTime isEqualToString:@"YES"]) {
            NSString *yCurrentTimeStr = [YIntelligentTimeDisplay yIntelligentTimeDisplayWithTimeStamp:yMessageModel.yTime];
            NSString *yTmpTimeStr = [YIntelligentTimeDisplay yIntelligentTimeDisplayWithTimeStamp:yTmpMessageModel.yTime];
            if ([yCurrentTimeStr isEqualToString:yTmpTimeStr]) {
                return NO;
            } else {
                return YES;
            }
        }
    }
    return YES;
}

#pragma mark 刷新tableView，滚动到底部
- (void)yUpdataYChatTableViewAndScrollPositionBottomWithAnimated:(BOOL)animated {
    [_yChatTableView reloadData];
    if (isScrollBottom && yAccessMutArray.count > 0) {
        NSIndexPath *yIndexPath = [NSIndexPath indexPathForRow:[yAccessMutArray count] - 1 inSection:0];
        [_yChatTableView scrollToRowAtIndexPath:yIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark 将临时数据加入到数据库中
- (void)yAddTmpChatDataToDatabase:(BOOL)yIsProvideUpdataNumber {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /** 子线程 */
        NSArray *yTmpChatDataArr = [NSArray arrayWithContentsOfFile:_yTmpChatDataPath];
        NSMutableArray *yTmpChatDataMutArr = [NSMutableArray arrayWithArray:yTmpChatDataArr];
//        NSLog(@"%@",yTmpChatDataMutArr);
        NSInteger yUpdataNumber = 0;
        for (int i = 0; i < (int)yTmpChatDataMutArr.count; i++) {
            NSDictionary *yItemDict = [yTmpChatDataMutArr objectAtIndex:i];
            NSMutableDictionary *yItemMutDict = [NSMutableDictionary dictionaryWithDictionary:yItemDict];
            if ([[yItemMutDict objectForKey:@"userID"] isEqualToString:_yTargetUserID]) {
                NSMutableArray *yItemMutArr = [NSMutableArray arrayWithArray:[yItemMutDict objectForKey:@"list"]];
                yUpdataNumber = [yItemMutArr count];
                // 将数据构建成数据模型并且存入数据
                [self yCreateChatDataModelAndStoreData:yItemMutArr
                                         withHeadImage:[yItemMutDict objectForKey:@"HeadImage"]
                                          withUserName:[yItemMutDict objectForKey:@"name"]
                                            withUserID:[yItemMutDict objectForKey:@"userID"]];
                [yItemMutArr removeAllObjects];
                [yItemMutDict setObject:yItemMutArr forKey:@"list"];
                [yTmpChatDataMutArr replaceObjectAtIndex:i withObject:yItemMutDict];
                do{}while (![yTmpChatDataMutArr writeToFile:_yTmpChatDataPath atomically:NO]);
                break;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /** 主线程 */
            if (yIsProvideUpdataNumber) {
                [self yGetLatestSendedData:[NSString stringWithFormat:@"%d",(int)(yUpdataNumber)]];
            } else {
                yRecordHaveTakeToFew = yRecordDatabaseNumber = [[YDatabaseManager yShareDBManager] yGetTableDataNumber];
                [self yGetDataUpdataUI];
            }
            
        });
    });
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

#pragma mark NSNotificationCenter 有新的数据来了（存储在临时文件中），需要从临时文件中取出
- (void)yHaveNewData:(NSNotification *)yNoti {
    [self yAddTmpChatDataToDatabase:YES];
}

#pragma mark 将数据构建成数据模型并且存入数据
- (void)yCreateChatDataModelAndStoreData:(NSMutableArray *)yTmpChatDataMutArr
                           withHeadImage:(NSString *)yHeadImage
                            withUserName:(NSString *)yUserName
                              withUserID:(NSString *)yUserID {
    NSArray *yTransitionArray = [[NSArray alloc]initWithArray:[[YDatabaseManager yShareDBManager] yQueryWithClass:[YMessageModel class] withRange:nil withCondition:nil withOrder:nil]];
    NSMutableArray *yTransitionMutArray = [NSMutableArray arrayWithArray:yTransitionArray];
    NSMutableArray *yStoreContrastedDataMutArr = [[NSMutableArray alloc]init];
    for (NSDictionary *yTmpChatDataDict in yTmpChatDataMutArr) {
        YMessageModel *yMessageModel = [self yCreateChatDataModel:yTmpChatDataDict
                                                    withHeadImage:yHeadImage
                                                     withUserName:yUserName
                                                       withUserID:yUserID
                                           withContrastDataMutArr:yTransitionMutArray];
        [yTransitionMutArray addObject:yMessageModel];
        [yStoreContrastedDataMutArr addObject:yMessageModel];
    }
    for (YMessageModel *yMessageModel in yStoreContrastedDataMutArr) {
        [[YDatabaseManager yShareDBManager] yInsertWithDataObject:yMessageModel isModifyPrimaryKey:YDEFAULT];
    }
}

#pragma mark 构建数据模型
- (YMessageModel *)yCreateChatDataModel:(NSDictionary *)yTmpChatDataDict
                          withHeadImage:(NSString *)yHeadImage
                           withUserName:(NSString *)yUserName
                             withUserID:(NSString *)yUserID
                 withContrastDataMutArr:(NSMutableArray *)yContrastDataMutArr{
    YMessageModel *yMessageModel = [[YMessageModel alloc]init];
    yMessageModel.yPrimarykey = @"";
    yMessageModel.yUserID = yUserID;
    yMessageModel.yUserName = yUserName;
    yMessageModel.yTime = [yTmpChatDataDict objectForKey:@"time"];
    
    if (yContrastDataMutArr.count == 0) {
        yMessageModel.yHaveNoTime = @"YES";
    } else {
        for (int i = (int)(yContrastDataMutArr.count - 1); i >= 0; i--) {
            YMessageModel *yMessageOldModel = [yContrastDataMutArr objectAtIndex:i];
            if ([yMessageOldModel.yHaveNoTime isEqualToString:@"YES"]) {
                if ([self yAddDataContrastWhetherNeedPresentTime:yMessageModel withOldTime:yMessageOldModel]) {
                    yMessageModel.yHaveNoTime = @"YES";
                } else {
                    yMessageModel.yHaveNoTime = @"NO";
                }
                break;
            }
        }
    }
    
    yMessageModel.yHeadImage = yHeadImage;
    yMessageModel.yMessageContent = [yTmpChatDataDict objectForKey:@"content"];
    yMessageModel.yMessageSender = @"NO";
    yMessageModel.yMessageSendSuccessFail = @"-1";
    
    return yMessageModel;
}

#pragma mark 增加数据比对是否需要显示时间
- (BOOL)yAddDataContrastWhetherNeedPresentTime:(YMessageModel *)yMessageModel withOldTime:(YMessageModel *)yMessageOldModel{
    NSString *yContrastTimeStr = [YIntelligentTimeDisplay yIntelligentTimeDisplayWithTimeStamp:yMessageModel.yTime];
    NSString *yTmpTimeStr = [YIntelligentTimeDisplay yIntelligentTimeDisplayWithTimeStamp:yMessageOldModel.yTime];
    if ([yContrastTimeStr isEqualToString:yTmpTimeStr]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark 滚动到底部（外部调用）
- (void)yScrollToBottom {
    [self yUpdataYChatTableViewAndScrollPositionBottomWithAnimated:YES];
}

#pragma mark 滚动到底部（内部调用）
- (void)yScrollToBottomImmediately:(UIButton *)ySender {
    ySender.hidden = YES;
    [ySender setTitle:@"0" forState:UIControlStateNormal];
    NSIndexPath *yIndexPath = [NSIndexPath indexPathForRow:[yAccessMutArray count] - 1 inSection:0];
    [_yChatTableView scrollToRowAtIndexPath:yIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)yAdjustmentUnreadMessageButtonFrame {
    _yUnreadMessageButton.frame = CGRectMake(_yChatTableView.bounds.size.width - 47.5, _yChatTableView.bounds.size.height - 45.0, 35.0, 41.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
