//
//  TMORefreshControl.m
//  TMOTableViewDemo
//
//  Created by 崔 明辉 on 14-7-10.
//  Copyright (c) 2014年 多玩游戏. All rights reserved.
//

#import "TMORefreshControl.h"
#import "XHActivityIndicatorView.h"
#import "TMOTableView.h"

@interface TMORefreshControl (){
    CGFloat _controlViewHeight;
    BOOL _isCustomize;
}

@property (nonatomic, strong) XHActivityIndicatorView *activityView;

@property (nonatomic, weak) TMOTableView *tableView;

@end

@implementation TMORefreshControl

- (void)dealloc {
    
}

- (instancetype)initWithTableView:(TMOTableView *)argTabelView {
    self = [super initWithFrame:CGRectMake(0, 0, argTabelView.frame.size.width, 60)];
    if (self) {
        _controlViewHeight = 60;
        self.tableView = argTabelView;
        [self defaultSetup];
        [self addScrollViewObserver];
    }
    return self;
}

- (void)setRefreshView:(UIView *)refreshView {
    if (refreshView == nil) {
        _refreshView = nil;
        [self.refreshView removeFromSuperview];
        [self defaultSetup];
        _isCustomize = NO;
    }
    else {
        _refreshView = refreshView;
        [self.activityView.superview removeFromSuperview];
        _controlViewHeight = self.refreshView.frame.size.height;
        self.frame = CGRectMake(0, 0, self.tableView.frame.size.width, _controlViewHeight);
        [self addSubview:self.refreshView];
        _isCustomize = YES;
    }
}

- (void)defaultSetup {
    self.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 60);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _controlViewHeight = 60;
    self.activityView = [[XHActivityIndicatorView alloc] initWithFrame:CGRectMake(22, 28, 44, 44)];
    self.activityView.tintColor = [UIColor grayColor];
    
    UIView *activityParentView = [[UIView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width/2-22.0, 0, 44, 44)];
    [activityParentView addSubview:self.activityView];
    activityParentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self addSubview:activityParentView];
}

- (void)addScrollViewObserver {
    [self.tableView addObserver:self
                     forKeyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        if (self.isRefreshing) {
            if (self.tableView.contentOffset.y > -_controlViewHeight) {
                CGFloat adjustInset = -MIN(self.tableView.contentOffset.y, 0.0);
                [self.tableView setContentInset:UIEdgeInsetsMake(adjustInset,
                                                                 0,
                                                                 self.tableView.contentInset.bottom,
                                                                 0)];
            }
        }
        
        if (self.tableView.contentOffset.y < -_controlViewHeight && !_isRefreshing) {
            _isRefreshing = YES;
            
            if (self.startBlock != nil) {
                self.startBlock(self.refreshView);
            }
            else if (!_isCustomize) {
                [self.activityView beginRefreshing];
            }
            
            [self performSelector:@selector(fingerReleaseCheck:) withObject:nil afterDelay:0.10];

        }
        
        if (!self.isRefreshing) {
            CGFloat currentY = -MIN(0.0, self.tableView.contentOffset.y);
            if (currentY < 16.0) {
                if (!_isCustomize) {
                    [self.activityView setTimeOffset:0.0];
                }
            }
            else {
                CGFloat offset = (MIN(currentY, _controlViewHeight) - 16.0) / (_controlViewHeight - 16.0);
                if (self.processingBlock != nil) {
                    self.processingBlock(self.refreshView, offset);
                }
                else if (!_isCustomize) {
                    [self.activityView setTimeOffset:offset];
                }
            }
        }
        
        if ([self.tableView isTableViewController]) {
            [self setFrame:CGRectMake(self.frame.origin.x,
                                      self.tableView.contentOffset.y,
                                      self.frame.size.width,
                                      self.frame.size.height)];
            if (self.isRefreshing) {
                CGFloat offsetY = MIN(-_controlViewHeight, self.tableView.contentOffset.y);
                [self setFrame:CGRectMake(self.frame.origin.x,
                                          offsetY,
                                          self.frame.size.width,
                                          self.frame.size.height)];
            }
        }
        
    }
}

- (void)fingerReleaseCheck:(NSNumber *)timeUse {
    if ([timeUse floatValue] > 3.0) {
        [self stop];
    }
    else {
        if (self.tableView.contentOffset.y > -_controlViewHeight &&
            self.tableView.contentOffset.y + _controlViewHeight < _controlViewHeight/2) {
            [self start];
        }
        else if (self.tableView.contentOffset.y >= 0) {
            [self stop];
        }
        else {
            timeUse = @([timeUse floatValue] + 0.10);
            [self performSelector:@selector(fingerReleaseCheck:) withObject:timeUse afterDelay:0.10];
        }
    }
}

- (void)start {
    if (self.refreshCallback != nil) {
        if (self.refreshDelay > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.refreshDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.refreshCallback(self.tableView, self.tableView.parentViewController);
            });
        }
        else {
            self.refreshCallback(self.tableView, self.tableView.parentViewController);
        }
    }
}

- (void)done {
    if (!self.tableView.isValid) {
        return;
    }
    [self.tableView reloadData];
    [self stop];
}

- (void)fail {
    [self stop];
}

- (void)stop {
    _isRefreshing = NO;
    
    if (self.stopBlock != nil) {
        self.stopBlock(self.refreshView);
    }
    else if (!_isCustomize) {
        [self.activityView setTimeOffset:0.0];
        [self.activityView endRefreshing];
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, self.tableView.contentInset.bottom, 0)];
    }];
}

- (void)refreshAndScrollToTop {
    if (!self.isRefreshing) {
        _isRefreshing = YES;
        
        if (self.startBlock != nil) {
            self.startBlock(self.refreshView);
        }
        else if (!_isCustomize) {
            [self.activityView setTimeOffset:1.0];
            [self.activityView beginRefreshing];
        }
        [self start];
        [UIView animateWithDuration:0.15 animations:^{
            [self.tableView setContentInset:UIEdgeInsetsMake(_controlViewHeight,
                                                             0,
                                                             self.tableView.contentInset.bottom,
                                                             0)];
            [self.tableView setContentOffset:CGPointMake(0, -_controlViewHeight) animated:YES];
        }];
    }
}

@end
