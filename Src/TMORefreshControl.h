//
//  TMORefreshControl.h
//  TMOTableViewDemo
//
//  Created by 崔 明辉 on 14-7-10.
//  Copyright (c) 2014年 多玩游戏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TMORefreshControlDelegate <NSObject>

@optional

/**
 *  返回一个下拉刷新自定义样式的UIView
 *
 *  @return UIView
 */
- (UIView *)refreshView;

/**
 *  当用户下拉tableView直至触发刷新操作的过程中，TMORefreshControl会进行回调
 *
 *  @param argCustomRefreshView 已经自定义的UIView
 *  @param argProcess           float 0~1
 */
- (void)refreshViewInProcess:(UIView *)argCustomRefreshView withProcess:(CGFloat)argProcess;

/**
 *  触发刷新后的回调
 *
 *  @param argCustomRefreshView 已经自定义的UIView
 */
- (void)refreshViewWillStartRefresh:(UIView *)argCustomRefreshView;

/**
 *  刷新完毕后的回调
 *
 *  @param argCustomRefreshView 已经自定义的UIView
 */
- (void)refreshViewWillEndRefresh:(UIView *)argCustomRefreshView;

@end

@interface TMORefreshControl : UIView

/**
 *  下拉刷新，自定义样式Delegate
 */
@property (nonatomic, weak) id<TMORefreshControlDelegate> delegate;

/**
 *  下拉刷新是否正在执行，只读
 */
@property (nonatomic, readonly) BOOL isRefreshing;

@end

