//
//  TMOFirstLoadControl.h
//  TMOTableViewDemo
//
//  Created by 崔 明辉 on 14-7-10.
//  Copyright (c) 2014年 多玩游戏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMOTableViewDefines.h"

@class TMOTableView;

@interface TMOFirstLoadControl : NSObject

@property (nonatomic, copy) TMOTableviewCallback callback;

@property (nonatomic, strong) UIView *loadingView;

@property (nonatomic, strong) UIView *failView;

@property (nonatomic, assign) BOOL allowRetry;

@property (nonatomic, assign) CGFloat yOffset;

- (instancetype)initWithTableView:(TMOTableView *)argTabelView;

- (void)start;

- (void)done;

- (void)fail;

- (void)setup;

@end
