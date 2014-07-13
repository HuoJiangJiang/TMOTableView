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

@property (nonatomic, strong) TMOTableviewCallback refreshCallback;

@property (nonatomic, strong) TMORefreshProcessingBlock processingBlock;

@property (nonatomic, strong) TMORefreshStartBlock startBlock;

@property (nonatomic, strong) TMORefreshStopBlock stopBlock;

@property (nonatomic, assign) NSTimeInterval refreshDelay;

- (id)initWithTableView:(TMOTableView *)argTabelView;

- (void)start;

- (void)done;

- (void)fail;

@end

