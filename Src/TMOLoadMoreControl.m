//
//  TMOLoadMoreControl.m
//  TMOTableViewDemo
//
//  Created by 崔 明辉 on 14-7-10.
//  Copyright (c) 2014年 多玩游戏. All rights reserved.
//

#import "TMOLoadMoreControl.h"
#import "TMOTableView.h"

@interface TMOLoadMoreControl (){
    CGFloat _controlViewHeight;
    BOOL _isInvalid;
    BOOL _isFail;
    BOOL _isCustomize;
}

@property (nonatomic, weak) TMOTableView *tableView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UIView *retryView;

@end

@interface TMOSVGArrowDownView : UIView

@end

@implementation TMOLoadMoreControl

- (void)dealloc {
    
}

- (id)initWithTableView:(TMOTableView *)argTabelView {
    self = [super initWithFrame:CGRectMake(0, 0, argTabelView.frame.size.width, 44)];
    if (self) {
        self.tableView = argTabelView;
        [self defaultSetup];
        [self invalid:NO hide:NO];
        [self.tableView addObserver:self
                         forKeyPath:@"contentOffset"
                            options:NSKeyValueObservingOptionNew
                            context:nil];
    }
    return self;
}

- (void)setLoadMoreView:(UIView *)loadMoreView {
    if (loadMoreView != nil) {
        _loadMoreView = loadMoreView;
        [self.retryView removeFromSuperview];
        [self.activityView removeFromSuperview];
        [self addSubview:self.loadMoreView];
        _controlViewHeight = self.loadMoreView.frame.size.height;
        self.frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.frame.size.width, _controlViewHeight);
        [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top, 0, _controlViewHeight, 0)];
        _isCustomize = YES;
    }
    else {
        _loadMoreView = nil;
        [self.loadMoreView removeFromSuperview];
        [self defaultSetup];
        _isCustomize = NO;
    }
}

- (void)defaultSetup {
    _controlViewHeight = 44.0;
    self.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.retryView];
    [self addSubview:self.activityView];
    [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top, 0, _controlViewHeight, 0)];
}

- (UIView *)retryView {
    if (_retryView == nil) {
        _retryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        TMOSVGArrowDownView *arrowDown = [[TMOSVGArrowDownView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width/2-22.0, 0, 44, 44)];
        arrowDown.backgroundColor = [UIColor whiteColor];
        [_retryView addSubview:arrowDown];
        [_retryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retry)]];
        arrowDown.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _retryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _retryView;
}

- (UIActivityIndicatorView *)activityView {
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityView setFrame:CGRectMake(self.tableView.frame.size.width/2-22.0, 0, 44, 44)];
        [_activityView startAnimating];
        [_activityView setAlpha:0.0];
        _activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return _activityView;
}

- (void)invalid:(BOOL)isInvalid hide:(BOOL)isHide {
    if (isInvalid) {
        _isInvalid = YES;
        if (isHide) {
            [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top, 0, 0, 0)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setAlpha:0.0];
            });
        }
        else {
            [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top, 0, _controlViewHeight, 0)];
        }
        [self stop];
    }
    else {
        _isInvalid = NO;
        [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top, 0, _controlViewHeight, 0)];
        [self setAlpha:1.0];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (!_isLoading && !_isInvalid && !_isFail &&
            (self.tableView.contentSize.height - self.tableView.contentOffset.y) < self.tableView.frame.size.height + 20.0) {
            //执行block
            _isLoading = YES;
            [self start];
        }
        else if (!_isLoading && !_isInvalid && _isFail &&
                 (self.tableView.contentSize.height - self.tableView.contentOffset.y) < self.tableView.frame.size.height - 100) {
            //大力拉，重试
            _isFail = NO;
            _isLoading = YES;
            [self start];
        }
    }
}

- (void)start {
    
    if (self.startBlock != nil) {
        self.startBlock(self.loadMoreView);
    }
    else if (!_isCustomize) {
        [self.retryView setAlpha:0.0];
        [self.activityView setAlpha:1.0];
    }
    
    if (self.loadMoreCallback != nil) {
        if (self.loadMoreDelay > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.loadMoreDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.loadMoreCallback(self.tableView, self.tableView.parentViewController);
            });
        }
        else {
            self.loadMoreCallback(self.tableView, self.tableView.parentViewController);
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
    _isFail = YES;
    _isLoading = NO;
    [self setAlpha:1.0];
    
    if (self.failBlock != nil) {
        self.failBlock(self.loadMoreView);
    }
    else if (!_isCustomize) {
        [self.retryView setAlpha:1.0];
        [self.activityView setAlpha:0.0];
    }
}

- (void)stop {
    [self setAlpha:0.0];
    if (self.stopBlock != nil) {
        self.stopBlock(self.loadMoreView);
    }
    else if (!_isCustomize) {
        [self.activityView setAlpha:0.0];
        [self.retryView setAlpha:1.0];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setAlpha:1.0];
        _isLoading = NO;
    });
}

- (void)retry {
    _isFail = NO;
    [self setAlpha:1.0];
    [self start];
}

@end


@implementation TMOSVGArrowDownView

- (void)drawRect:(CGRect)rect {
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.513 green: 0.508 blue: 0.509 alpha: 1];
    
    //// Group 137
    {
        //// Oval 75 Drawing
        UIBezierPath* oval75Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(12.33, 11.33, 21.67, 21.67)];
        [color2 setStroke];
        oval75Path.lineWidth = 1.96;
        [oval75Path stroke];
        
        
        //// Group 138
        {
            //// Bezier 373 Drawing
            UIBezierPath* bezier373Path = UIBezierPath.bezierPath;
            [bezier373Path moveToPoint: CGPointMake(22.98, 27.49)];
            [bezier373Path addLineToPoint: CGPointMake(17, 21.37)];
            [bezier373Path addLineToPoint: CGPointMake(22.98, 27.49)];
            [bezier373Path closePath];
            [color2 setStroke];
            bezier373Path.lineWidth = 1.96;
            [bezier373Path stroke];
            
            
            //// Bezier 374 Drawing
            UIBezierPath* bezier374Path = UIBezierPath.bezierPath;
            [bezier374Path moveToPoint: CGPointMake(22.48, 28)];
            [bezier374Path addLineToPoint: CGPointMake(28.83, 21.5)];
            [color2 setStroke];
            bezier374Path.lineWidth = 1.96;
            [bezier374Path stroke];
            
            
            //// Bezier 375 Drawing
            UIBezierPath* bezier375Path = UIBezierPath.bezierPath;
            [bezier375Path moveToPoint: CGPointMake(22.98, 26.47)];
            [bezier375Path addLineToPoint: CGPointMake(22.98, 15)];
            [color2 setStroke];
            bezier375Path.lineWidth = 2;
            [bezier375Path stroke];
        }
    }
    
}

@end