//
//  TMOFirstLoadControl.h
//  TMOTableViewDemo
//
//  Created by 崔 明辉 on 14-7-10.
//  Copyright (c) 2014年 多玩游戏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMOFirstLoadControl : NSObject

@property (nonatomic, assign) BOOL allowRetry;

- (void)start;
- (void)done;
- (void)fail;

@end
