//
//  TMORefreshControl.h
//  TMOTableViewDemo
//
//  Created by 崔 明辉 on 14-7-10.
//  Copyright (c) 2014年 多玩游戏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMOTableViewDefines.h"

@interface TMORefreshControl : UIView

@property (nonatomic, readonly) BOOL isRefreshing;

@property (nonatomic, strong) UIView *refreshView;

@property (nonatomic, copy) TMOTableviewCallback refreshCallback;

- (void)setRefreshCallback:(TMOTableviewCallback)refreshCallback;

@property (nonatomic, copy) TMORefreshProcessingBlock processingBlock;

- (void)setProcessingBlock:(TMORefreshProcessingBlock)processingBlock;

@property (nonatomic, copy) TMORefreshStartBlock startBlock;

- (void)setStartBlock:(TMORefreshStartBlock)startBlock;

@property (nonatomic, copy) TMORefreshStopBlock stopBlock;

- (void)setStopBlock:(TMORefreshStopBlock)stopBlock;

@property (nonatomic, assign) NSTimeInterval refreshDelay;

- (id)initWithTableView:(TMOTableView *)argTabelView;

- (void)start;

- (void)done;

- (void)fail;

- (void)refreshAndScrollToTop;

@end

