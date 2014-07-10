//
//  TMOLoadMoreControl.h
//  TMOTableViewDemo
//
//  Created by 崔 明辉 on 14-7-10.
//  Copyright (c) 2014年 多玩游戏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TMOLoadMoreControlDelegate <NSObject>

@optional

/**
 *  返回一个上拉加载自定式样式UIView
 *
 *  @return UIView
 */
- (UIView *)loadMoreView;

/**
 *  当上拉加载将要触发时，回调
 *
 *  @param argCustomView 已经自定义的UIView
 */
- (void)loadMoreViewWillStartLoading:(UIView *)argCustomView;

/**
 *  当上拉加载完成时，回调
 *
 *  @param argCustomView 已经自定义的UIView
 */
- (void)loadMoreViewWillEndLoading:(UIView *)argCustomView;

/**
 *  当上拉加载失败时，回调
 *
 *  @param argCustomView 已经自定义的UIView
 */
- (void)loadMoreViewLoadFail:(UIView *)argCustomView;

@end

@interface TMOLoadMoreControl : UIView

@property (nonatomic, weak) id<TMOLoadMoreControlDelegate> delegate;

/**
 *  上拉加载是否正在执行，只读
 */
@property (nonatomic, readonly) BOOL isLoading;

/**
 *  上拉加载是否生效
 *  传入YES，上拉加载失效
 *  传入NO，上拉加载生效
 */
@property (nonatomic, assign) BOOL isInvalid;

/**
 *  上拉加载是否为失败状态
 *  传入YES，停止任何尝试
 *  传入NO，继续尝试加载
 */
@property (nonatomic, assign) BOOL isFail;

@end
