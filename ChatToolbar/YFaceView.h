//
//  YFaceView.h
//  YChatDemo
//
//  Created by 严安 on 14/12/29.
//  Copyright (c) 2014年 严安. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YFaceViewDelegate <NSObject>

- (void)ySelectedEmojiFace:(NSString *)yEmojiFaceStr;
- (void)yDeleteEmojiFace;

@end

@interface YFaceView : UIView<UIScrollViewDelegate> {
    
    NSArray *yFacesArray;
    
    UIScrollView *yScrollView;
    
    NSInteger yPageNumber;
    
    UIPageControl *yPageControl;
}

@property (nonatomic, assign)id<YFaceViewDelegate>delegate;

@end
