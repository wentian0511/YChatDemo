//
//  YFaceView.m
//  YChatDemo
//
//  Created by 严安 on 14/12/29.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import "YFaceView.h"

#import "YEmojiAnalytical.h"

@implementation YFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self yCreateEmojiFace];
    }
    return self;
}

- (void)yCreateEmojiFace {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /** 子线程 */
        yFacesArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"emoji" ofType:@"plist"]];
        
        yPageNumber = 0;
        if ([yFacesArray count]%27 == 0) {
            yPageNumber = [yFacesArray count]/27;
        } else {
            yPageNumber = [yFacesArray count]/27 + 1;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /** 主线程 */
            [self yCreateEmojiFaceScrollView];
            [self yCreateEmojiFacePageControl];
            
            for (NSInteger yI = 0; yI < yPageNumber; yI++) {
                [self yLoadFaceView:yI];
            }
            
            // 创建发送button
            [self yCreateSendButton];
        });
    });
}

- (void)yCreateEmojiFaceScrollView {
    yScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    yScrollView.delegate = self;
    yScrollView.contentSize = CGSizeMake(self.bounds.size.width*yPageNumber, self.bounds.size.height);
    yScrollView.pagingEnabled = YES;
    yScrollView.showsHorizontalScrollIndicator = NO;
    yScrollView.scrollsToTop = NO;
    [self addSubview:yScrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger yCurrentPage = scrollView.contentOffset.x/self.bounds.size.width;
    yPageControl.currentPage = yCurrentPage;
}

- (void)yCreateEmojiFacePageControl {
    yPageControl = [[UIPageControl alloc]init];
    yPageControl.numberOfPages = yPageNumber;
    yPageControl.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 20);
    yPageControl.currentPage = 0;
    yPageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
    yPageControl.pageIndicatorTintColor = [UIColor colorWithRed:204.0/255.0 green:202.0/255.0 blue:202.0/255.0 alpha:1.0];
    [self addSubview:yPageControl];
}

-(void)yLoadFaceView:(NSInteger)yCurrentPageNumber {
        for (NSInteger jRow = 0; jRow < 4; jRow++) {
            NSInteger kColumn = 0;
            for (; kColumn < 7; kColumn++) {
                if ((yCurrentPageNumber*27 + jRow*7 + kColumn) < [yFacesArray count]) {
                    if (jRow*7 + kColumn < 27) {
                        UIButton *yEmojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        yEmojiButton.frame = CGRectMake(15 + (35 + (YSCREENWIDTH - 7*35 - 30)/6)*kColumn + yCurrentPageNumber*YSCREENWIDTH, 15 + (35 + 8)*jRow, 35, 35);
                        yEmojiButton.tag = (yCurrentPageNumber*27 + jRow*7 + kColumn);
                        [yEmojiButton.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
                        [yEmojiButton setTitle:[YEmojiAnalytical convertSimpleUnicodeStr:(NSString *)[yFacesArray objectAtIndex:(yCurrentPageNumber*27 + jRow*7 + kColumn)]] forState:UIControlStateNormal];
                        [yEmojiButton addTarget:self action:@selector(ySelectedFace:) forControlEvents:UIControlEventTouchUpInside];
                        [yScrollView addSubview:yEmojiButton];
                    } else {
                        UIButton *yDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        yDeleteButton.frame = CGRectMake(16 + (35 + (YSCREENWIDTH - 7*35 - 30)/6)*kColumn + yCurrentPageNumber*YSCREENWIDTH, 15 + (35 + 10)*jRow, 33, 26);
                        [yDeleteButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceDelete@2x" ofType:@"png"]] forState:UIControlStateNormal];
                        [yDeleteButton addTarget:self action:@selector(yDeleteFace:) forControlEvents:UIControlEventTouchUpInside];
                        [yScrollView addSubview:yDeleteButton];
                        break;
                    }
                } else {
                    UIButton *yDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    yDeleteButton.frame = CGRectMake(16 + (35 + (YSCREENWIDTH - 7*35 - 30)/6)*6 + yCurrentPageNumber*YSCREENWIDTH, 15 + (35 + 10)*3, 33, 26);
                    [yDeleteButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceDelete@2x" ofType:@"png"]] forState:UIControlStateNormal];
                    [yDeleteButton addTarget:self action:@selector(yDeleteFace:) forControlEvents:UIControlEventTouchUpInside];
                    [yScrollView addSubview:yDeleteButton];
                    break;
                }
            }
            if (kColumn != 7) {
                break;
            }
        }
    
}

- (void)ySelectedFace:(UIButton *)sender {
//    NSLog(@"sender.tag:::%ld",(long)sender.tag);
//    NSLog(@"emojiFace:::%@",[YEmojiAnalytical convertSimpleUnicodeStr:(NSString *)[yFacesArray objectAtIndex:sender.tag]]);
    if ([_delegate respondsToSelector:@selector(ySelectedEmojiFace:)]) {
        [_delegate ySelectedEmojiFace:(NSString *)[yFacesArray objectAtIndex:sender.tag]];
    }
}

- (void)yDeleteFace:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(yDeleteEmojiFace)]) {
        [_delegate yDeleteEmojiFace];
    }
}

// 创建辅助发送按钮
- (void)yCreateSendButton {
    UIButton *ySendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ySendButton.frame = CGRectMake(0.0, self.bounds.size.height - 34.0, 70.0, 34.0);
    [ySendButton setTitle:@"发送" forState:UIControlStateNormal];
    [ySendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ySendButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [ySendButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [ySendButton setBackgroundImage:[UIImage imageNamed:@"aio_pic_btn_bg_blue_nor"] forState:UIControlStateNormal];
    [ySendButton setBackgroundColor:YUIColorRGB(48.0,141.0,239.0,1.0)]; // 48 141 239
//    [self addSubview:ySendButton];
}

- (void)dealloc {
//    NSLog(@"YFaceView");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
