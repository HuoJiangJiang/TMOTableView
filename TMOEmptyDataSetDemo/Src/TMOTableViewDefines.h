//
//  TMOTableViewDefines.h
//  TMOTableViewDemo
//
//  Created by 崔 明辉 on 14-7-12.
//  Copyright (c) 2014年 多玩游戏. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMOTableView, TMOFirstLoadControl, TMORefreshControl, TMOLoadMoreControl, XHActivityIndicatorView;

typedef void(^TMOTableviewCallback)(TMOTableView *tableView, id viewController);

typedef void(^TMORefreshProcessingBlock)(UIView *refreshView, CGFloat progress);

typedef void(^TMORefreshStartBlock)(UIView *refreshView);

typedef void(^TMORefreshStopBlock)(UIView *refreshView);

typedef void(^TMOLoadMoreStartBlock)(UIView *loadMoreView);

typedef void(^TMOLoadMoreStopBlock)(UIView *loadMoreView);

typedef void(^TMOLoadMoreFailBlock)(UIView *loadMoreView);