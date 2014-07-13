//
//  TMOTableView.h
//  TeemoV2
//
//  Created by 崔明辉 on 14-6-18.
//  Copyright (c) 2014年 com.duowan.zpc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMOTableViewDefines.h"
#import "TMOFirstLoadControl.h"
#import "TMORefreshControl.h"
#import "TMOLoadMoreControl.h"

@interface TMOTableView : UITableView

@property (nonatomic, readonly) BOOL isValid;

@property (nonatomic, readonly) BOOL isTableViewController;

@property (nonatomic, readonly) UIViewController *parentViewController;

@property (nonatomic, readonly) TMOFirstLoadControl *myFirstLoadControl;

/**
 * Use this method init myFirstLoadControl
 **/
- (void)firstLoadWithBlock:(TMOTableviewCallback)argBlock
           withLoadingView:(UIView *)argLoadingView
              withFailView:(UIView *)argFailView;

/**
 * Use this method init myFirstLoadControl
 **/
- (void)firstLoadWithBlock:(TMOTableviewCallback)argBlock
               withYOffset:(CGFloat)argYOffset;

@property (nonatomic, readonly) TMORefreshControl *myRefreshControl;

/**
 * Use this method init myRefreshControl
 **/
- (void)refreshWithCallback:(TMOTableviewCallback)argCallback withDelay:(NSTimeInterval)argDelay;

@property (nonatomic, readonly) TMOLoadMoreControl *myLoadMoreControl;

/**
 * Use this method init myLoadMoreControl
 **/
- (void)loadMoreWithCallback:(TMOTableviewCallback)argCallback withDelay:(NSTimeInterval)argDelay;

@end
