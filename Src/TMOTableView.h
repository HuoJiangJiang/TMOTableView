//
//  TMOTableView.h
//  TeemoV2
//
//  Created by 崔明辉 on 14-6-18.
//  Copyright (c) 2014年 com.duowan.zpc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMOFirstLoadControl.h"
#import "TMORefreshControl.h"
#import "TMOLoadMoreControl.h"

@interface TMOTableView : UITableView

/**
 *  Rrefresh & LoadMore Callback Block
 *
 *  @param tableView      使用此变量以避免循环引用，调用前请使用 tableView.isValid 检测 tableView 是否已经失效
 *  @param viewController 代表tableView的父级viewController，使用此变量以避免循环引用
 */
typedef void(^TMOTableviewCallback)(TMOTableView *tableView, id viewController);

/**
 *  tableView是否已经移出superView，若已经移出，则勿执行任何UI相关操作
 */
@property (nonatomic, readonly) BOOL isValid;

/**
 *  首次加载控制器
 */
@property (nonatomic, readonly) TMOFirstLoadControl *myFirstLoadControl;

/**
 *  下拉刷新控制器，使用refreshWithCallback:withDelay:执行初始化
 */
@property (nonatomic, readonly) TMORefreshControl *myRefreshControl;

/**
 *  上拉加载控制器，使用loadMoreWithCallback:withDelay:执行初始化
 */
@property (nonatomic, readonly) TMOLoadMoreControl *myLoadMoreControl;

/**
 *  首次加载控制器
 *  加载完成后，调用[myFirstLoadControl done]
 *  加载失败后，调用[myFirstLoadControl fail]
 *  如需要重试，调用[myFirstLoadControl start]
 *
 *  @param argBlock       加载Block
 *  @param argLoadingView 可选，一个自定义的loadingView
 *  @param argFailView    可选，一个自定义的failView
 */
- (void)firstLoadWithBlock:(TMOTableviewCallback)argBlock
           withLoadingView:(UIView *)argLoadingView
              withFailView:(UIView *)argFailView;

/**
 *  首次加载控制器，使用默认的样式
 *
 *  @param argBlock       加载Block
 *  @param argYOffset     菊花、失败提示Y偏移值
 */
- (void)firstLoadWithBlock:(TMOTableviewCallback)argBlock
               withYOffset:(CGFloat)argYOffset;

/**
 *  下拉刷新完成后，你需要执行此方法，此方法会为你完成菊花停转、表视图刷新等操作
 */
- (void)refreshDone;

/**
 *  下拉刷新初始化
 *
 *  @param argCallback 当下拉刷新被触发后执行的Block，切勿将self直接传入block，你需要传入一个weak的self，否则会引起循环引用
 *  @param argDelay    触发下拉刷新后，延时执行Block
 */
- (void)refreshWithCallback:(TMOTableviewCallback)argCallback withDelay:(NSTimeInterval)argDelay;

/**
 *  立即触发下拉刷新，并将tableView滑动至顶部
 */
- (void)refreshAndScrollToTop;

/**
 *  上拉加载完成后，你需要执行此方法，此方法会为你完成菊花停转、表视图刷新等操作
 */
- (void)loadMoreDone;

/**
 *  上拉加载初始化
 *
 *  @param argCallback 当上拉加载被触发后执行的Block，切勿将self直接传入block，你需要传入一个weak的self，否则会引起循环引用
 *  @param argDelay    触发上拉加载后，延时执行Block
 */
- (void)loadMoreWithCallback:(TMOTableviewCallback)argCallback withDelay:(NSTimeInterval)argDelay;

- (UIViewController *)tableViewParentViewController;

- (BOOL)isTableViewController;

@end
