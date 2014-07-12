//
//  TMOLoadMoreControl.h
//  TMOTableViewDemo
//
//  Created by 崔 明辉 on 14-7-10.
//  Copyright (c) 2014年 多玩游戏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMOTableViewDefines.h"

@interface TMOLoadMoreControl : UIView

@property (nonatomic, readonly) BOOL isLoading;

@property (nonatomic, strong) UIView *loadMoreView;

@property (nonatomic, strong) TMOTableviewCallback loadMoreCallback;

@property (nonatomic, strong) TMOLoadMoreStartBlock startBlock;

@property (nonatomic, strong) TMOLoadMoreStopBlock stopBlock;

@property (nonatomic, strong) TMOLoadMoreFailBlock failBlock;

@property (nonatomic, assign) NSTimeInterval loadMoreDelay;

- (id)initWithTableView:(TMOTableView *)argTabelView;

- (void)start;

- (void)done;

- (void)fail;

- (void)handleRetryButtonTapped;

- (void)invalid:(BOOL)isInvalid hide:(BOOL)isHide;

- (void)removeObserver;

//- (void)stop;

//@property (nonatomic, weak) id<TMOLoadMoreControlDelegate> delegate;




@end
