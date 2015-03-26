//
//  YRightBubbleHaveTimeTextCell.m
//  YChatDemo
//
//  Created by 严安 on 15/1/2.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YRightBubbleHaveTimeTextCell.h"

#import "NSString+YCalculateLabelRect.h"

#import "YPictureDownloadManager.h"

@interface YRightBubbleHaveTimeTextCell () {
    __block YPictureDownloadManager *yRecordPDM;
}

@end

@implementation YRightBubbleHaveTimeTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self yDrawCellContent];
    }
    return self;
}

- (void)yDrawCellContent {
    
    _yTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 9, YSCREENWIDTH, 19)];
    _yTimeLabel.center = CGPointMake(YSCREENWIDTH/2.0, 10);
    _yTimeLabel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5]; // 
    _yTimeLabel.font = [UIFont systemFontOfSize:13.0];
    _yTimeLabel.textAlignment = NSTextAlignmentCenter;
    _yTimeLabel.textColor = [UIColor whiteColor];
    _yTimeLabel.text = @"2015-2-26 上午00:26";
    CGSize yTimeLabelSize = [_yTimeLabel sizeThatFits:CGSizeMake(YSCREENWIDTH, 15)];
    _yTimeLabel.frame = CGRectMake((YSCREENWIDTH - yTimeLabelSize.width - 10)/2, 5, yTimeLabelSize.width + 10, 15);
    [self.contentView addSubview:_yTimeLabel];
    _yTimeLabel.layer.masksToBounds = YES;
    _yTimeLabel.layer.cornerRadius = 5.0;
    
    _yHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(YSCREENWIDTH - 50, 41, 40, 40)];
    _yHeadImageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    _yHeadImageView.layer.masksToBounds = YES;
//    _yHeadImageView.layer.cornerRadius = 20.0;
    [self.contentView addSubview:_yHeadImageView];
    
    _yMessageContentBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(YSCREENWIDTH - (55 + YMessageContentBgImageViewWidth), 23, YMessageContentBgImageViewWidth, 80)];
//    _yMessageContentBgImageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    _yMessageContentBgImageView.image = [self yGetBundleImage:@"SenderTextNodeBkg"];
    [self.contentView addSubview:_yMessageContentBgImageView];
    
    _yMessageContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, YSCREENWIDTH, 15)];
    _yMessageContentLabel.backgroundColor = [UIColor clearColor];
    _yMessageContentLabel.font = [UIFont systemFontOfSize:18.0];
    _yMessageContentLabel.textColor = [UIColor blackColor];
    _yMessageContentLabel.textAlignment = NSTextAlignmentLeft;
    _yMessageContentLabel.numberOfLines = 0;
    _yMessageContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_yMessageContentLabel];
    
    _yActivityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _yActivityIndicatorView.hidesWhenStopped = YES;
    _yActivityIndicatorView.center = CGPointMake(YSCREENWIDTH -YMessageContentBgImageViewWidth - 55 - 20, 40);
    [self.contentView addSubview:_yActivityIndicatorView];
    [_yActivityIndicatorView startAnimating];
    
    _yWhetherAgainSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _yWhetherAgainSendButton.frame = CGRectMake(YSCREENWIDTH -YMessageContentBgImageViewWidth - 55 - 35, 25, 30, 30);
    [_yWhetherAgainSendButton setBackgroundImage:[UIImage imageNamed:@"MessageSendFail"] forState:UIControlStateNormal];
    [_yWhetherAgainSendButton addTarget:self action:@selector(yWhetherAgainSendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_yWhetherAgainSendButton];
}

- (void)setYTimeLabelText:(NSString *)yText {
    _yTimeLabel.text = yText;
    CGSize yTimeLabelSize = [_yTimeLabel sizeThatFits:CGSizeMake(YSCREENWIDTH, 15)];
    _yTimeLabel.frame = CGRectMake((YSCREENWIDTH - yTimeLabelSize.width - 15)/2, 9, yTimeLabelSize.width + 15, 19);
}

- (void)setYHeadImageViewURL:(NSString *)yHeadImageURL {
    _yHeadImageView.image = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[YPictureDownloadManager yCreatePicDepositPath:yHeadImageURL]]) {
        _yHeadImageView.image = [UIImage imageWithContentsOfFile:[YPictureDownloadManager yCreatePicDepositPath:yHeadImageURL]];
    } else {
        yRecordPDM = nil;
        yRecordPDM = [[YPictureDownloadManager alloc] initWithPicURL:yHeadImageURL withNeedDownloadObject:self withSuccessCallBack:^(NSString *yPicDepositPath) {
            _yHeadImageView.image = [UIImage imageWithContentsOfFile:yPicDepositPath];
            
            yRecordPDM = nil;
        } withFailedCallBack:^{
            
            yRecordPDM = nil;
        }];
    }
}

- (void)setYMessageContentBgImageViewPath:(NSString *)yPath {
    _yMessageContentBgImageView.image = [UIImage imageWithContentsOfFile:yPath];
}

- (void)setYMessageContentBgImageViewFrame:(CGSize)ySize {
    _yMessageContentBgImageView.frame = CGRectMake(YSCREENWIDTH - (55 + 66 + ((ySize.width > 18.0) ? (ySize.width - 18.0) : 0)), 39, 66 + ((ySize.width > 18.0) ? (ySize.width - 18.0) : 0), 54 + (ySize.height - 22.0));
}

- (void)setYMessageContentLabelText:(NSString *)yText {
//    NSString *yRText = [yText copy];
//    CGRect yRect = [yRText boundingRectWithFont:[UIFont systemFontOfSize:13.0]];
    
    _yMessageContentLabel.text = yText;
    CGSize yMessageContentLabelSize = [_yMessageContentLabel sizeThatFits:CGSizeMake(YSCREENWIDTH - 55*2 - 35, __FLT_MAX__)];
    
    _yMessageContentLabel.frame = CGRectMake(YSCREENWIDTH - 80 - yMessageContentLabelSize.width, 51, yMessageContentLabelSize.width, yMessageContentLabelSize.height);
    
    [self setYMessageContentBgImageViewFrame:yMessageContentLabelSize];
    [self setYActivityIndicatorViewCenter:yMessageContentLabelSize];
    [self setYWhetherAgainSendButtonFrame:yMessageContentLabelSize];
    
}

- (void)setYActivityIndicatorViewCenter:(CGSize)ySize {
    _yActivityIndicatorView.center = CGPointMake(YSCREENWIDTH - (55 + 66 + (ySize.width - 18.0)) - 20, 56);
}

- (void)setYWhetherAgainSendButtonFrame:(CGSize)ySize {
    _yWhetherAgainSendButton.frame = CGRectMake(YSCREENWIDTH - (55 + 66 + (ySize.width - 18.0)) - 35, 41, 30, 30);
}

- (void)setYActivityIndicatorViewHidden:(BOOL)yBool {
    if (yBool) {
        [_yActivityIndicatorView stopAnimating];
    } else {
        [_yActivityIndicatorView startAnimating];
    }
}

- (void)setYWhetherAgainSendButtonHidden:(BOOL)yBool {
    _yWhetherAgainSendButton.hidden = yBool;
}

#pragma mark 是否重新发送消息事件
- (void)yWhetherAgainSendAction:(UIButton *)ySender {
//    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    [_yDelegate yRBHTWhetherAgainSendMessage:self];
}

- (UIImage *)yGetBundleImage:(NSString *)yImageName {
//    NSString *yImagePath = [[NSBundle mainBundle]pathForResource:yImageName ofType:@"png"];
    UIImage *yImage = [UIImage imageNamed:yImageName];
    yImage = [yImage stretchableImageWithLeftCapWidth:33 topCapHeight:32];
    return yImage;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
