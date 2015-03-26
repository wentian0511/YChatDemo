//
//  YLeftBubbleHaveTimeTextCell.m
//  YChatDemo
//
//  Created by 严安 on 15/1/2.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YLeftBubbleHaveTimeTextCell.h"

#import "NSString+YCalculateLabelRect.h"

#import "YPictureDownloadManager.h"

@interface YLeftBubbleHaveTimeTextCell () {
    __block YPictureDownloadManager *yRecordPDM;
}

@end

@implementation YLeftBubbleHaveTimeTextCell

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
    _yTimeLabel.text = @"2015-2-26 上午00:19";
    CGSize yTimeLabelSize = [_yTimeLabel sizeThatFits:CGSizeMake(YSCREENWIDTH, 15)];
    _yTimeLabel.frame = CGRectMake((YSCREENWIDTH - yTimeLabelSize.width - 10)/2, 5, yTimeLabelSize.width + 10, 15);
    [self.contentView addSubview:_yTimeLabel];
    _yTimeLabel.layer.masksToBounds = YES;
    _yTimeLabel.layer.cornerRadius = 5.0;
    
    _yHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 41, 40, 40)];
    _yHeadImageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    _yHeadImageView.layer.masksToBounds = YES;
//    _yHeadImageView.layer.cornerRadius = 20.0;
    [self.contentView addSubview:_yHeadImageView];
    
    _yMessageContentBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(55, 23, YMessageContentBgImageViewWidth, 54)]; // 66x54
//    _yMessageContentBgImageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    _yMessageContentBgImageView.image = [self yGetBundleImage:@"ReceiverTextNodeBkg"];
    [self.contentView addSubview:_yMessageContentBgImageView];
    
    _yMessageContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 35, 20, 22)];
    _yMessageContentLabel.backgroundColor = [UIColor clearColor];
    _yMessageContentLabel.font = [UIFont systemFontOfSize:18.0];
    _yMessageContentLabel.textColor = [UIColor blackColor];
    _yMessageContentLabel.textAlignment = NSTextAlignmentLeft;
    _yMessageContentLabel.numberOfLines = 0;
    _yMessageContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    _yMessageContentLabel.text = @"asdfghjkl;lkjhgfdsasdfghjklkjhgfdsdfghjklkjhgfdsdfghjklkjhgf";
//    CGSize yMessageContentLabelSize = [_yMessageContentLabel sizeThatFits:CGSizeMake(YSCREENWIDTH - 55*2 - 30, __FLT_MAX__)];
//    NSLog(@"%@",NSStringFromCGSize(yMessageContentLabelSize));
//    _yMessageContentLabel.frame = CGRectMake(75, 35, yMessageContentLabelSize.width, yMessageContentLabelSize.height);
    [self.contentView addSubview:_yMessageContentLabel];
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
    _yMessageContentBgImageView.frame = CGRectMake(55, 39, 66 + ((ySize.width > 18.0) ? (ySize.width - 18.0) : 0), 54 + (ySize.height - 22.0));
}

- (void)setYMessageContentLabelText:(NSString *)yText {
//    NSString *yRText = [yText copy];
//    CGRect yRect = [yRText boundingRectWithFont:[UIFont systemFontOfSize:13.0]];
    
    _yMessageContentLabel.text = yText;
    CGSize yMessageContentLabelSize = [_yMessageContentLabel sizeThatFits:CGSizeMake(YSCREENWIDTH - 55*2 - 30, __FLT_MAX__)];
    
    _yMessageContentLabel.frame = CGRectMake(75, 51, yMessageContentLabelSize.width, yMessageContentLabelSize.height);
    
    [self setYMessageContentBgImageViewFrame:yMessageContentLabelSize];
    
    
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
