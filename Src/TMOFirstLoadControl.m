//
//  TMOFirstLoadControl.m
//  TMOTableViewDemo
//
//  Created by 崔 明辉 on 14-7-10.
//  Copyright (c) 2014年 多玩游戏. All rights reserved.
//

#import "TMOFirstLoadControl.h"
#import "TMOTableView.h"

@interface TMOSVGInfomationView : UIView

@end

@interface TMOFirstLoadControl ()

@property (nonatomic, weak) TMOTableView *tableView;

@property (nonatomic, strong) UIView *tmpHeaderView;//Use for UITableViewControll, save tableView.headerView TEMPERARY

@end

@implementation TMOFirstLoadControl

- (instancetype)initWithTableView:(TMOTableView *)argTabelView {
    self = [super init];
    if (self) {
        self.yOffset = 44.0;
        self.tableView = argTabelView;
//        [self performSelector:@selector(setup) withObject:nil afterDelay:0.05];
//        [self performSelector:@selector(start) withObject:nil afterDelay:0.10];
    }
    return self;
}

- (void)setup {
    if (self.tableView.superview != nil) {
        [self.tableView.superview addSubview:self.loadingView];
        [self.tableView.superview addSubview:self.failView];
        [self.loadingView setAlpha:0.0];
        [self.failView setAlpha:0.0];
    }
    if ([self.tableView isTableViewController]) {
        self.tmpHeaderView = self.tableView.tableHeaderView;
    }
}

- (void)start {
    if ([self.tableView isTableViewController]) {
        self.tableView.tableHeaderView = self.loadingView;
        self.loadingView.alpha = 1.0;
        self.tableView.scrollEnabled = NO;
    }
    else {
        [self.tableView setAlpha:0.0];
        [self.loadingView setAlpha:1.0];
        [self.loadingView.superview bringSubviewToFront:self.loadingView];
    }
    TMOTableviewCallback callback = self.callback;
    if (callback != nil) {
        callback(self.tableView, self.tableView.parentViewController);
    }
}

- (void)done {
    if ([self.tableView isTableViewController]) {
        if (self.tmpHeaderView == self.tableView.tableHeaderView) {
            self.tableView.scrollEnabled = YES;
            if ([self.tableView isValid]) {
                [self.tableView reloadData];
            }
            return;
        }
        [UIView animateWithDuration:0.15 animations:^{
            self.tableView.tableHeaderView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.tableView.tableHeaderView = self.tmpHeaderView;
            self.tableView.scrollEnabled = YES;
            if ([self.tableView isValid]) {
                [self.tableView reloadData];
            }
        }];
    }
    else {
        [self.failView setAlpha:0.0];
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.tableView setAlpha:1.0];
            [self.loadingView setAlpha:0.0];
            if ([self.tableView isValid]) {
                [self.tableView reloadData];
            }
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)fail {
    if ([self.tableView isTableViewController]) {
        self.tableView.tableHeaderView = self.failView;
        self.failView.alpha = 1.0;
        self.tableView.scrollEnabled = NO;
    }
    else {
        [self.tableView setAlpha:0.0];
        [self.failView setAlpha:1.0];
        [self.failView.superview bringSubviewToFront:self.failView];
    }
    if (self.allowRetry) {
        if ([[self.failView gestureRecognizers] count] == 0) {
            [self.failView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(start)]];
        }
    }
    else {
        [self.failView setGestureRecognizers:@[]];
    }
}

- (UIView *)loadingView {
    if (_loadingView == nil) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        UIActivityIndicatorView *juhua = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [juhua setColor:[UIColor grayColor]];
        juhua.center = CGPointMake(self.tableView.frame.size.width/2, self.tableView.frame.size.height/2 - self.yOffset);
        juhua.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [juhua startAnimating];
        [backgroundView addSubview:juhua];
        _loadingView = backgroundView;
    }
    return _loadingView;
}

- (UIView *)failView {
    if (_failView == nil) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        TMOSVGInfomationView *iconView = [[TMOSVGInfomationView alloc] initWithFrame:CGRectMake(backgroundView.frame.size.width/2-48.0, backgroundView.frame.size.height/2-48.0-self.yOffset, 96.0, 116.0)];
        iconView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        iconView.backgroundColor = [UIColor whiteColor];
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 86, iconView.frame.size.width, 20)];
        errorLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [errorLabel setText:@"加载失败"];
        [errorLabel setTextColor:[UIColor grayColor]];
        [errorLabel setFont:[UIFont systemFontOfSize:16.0]];
        [errorLabel setBackgroundColor:[UIColor clearColor]];
        [errorLabel setTextAlignment:NSTextAlignmentCenter];
        [iconView addSubview:errorLabel];
        [backgroundView addSubview:iconView];
        _failView = backgroundView;
    }
    return _failView;
}

@end

#pragma mark -
#pragma mark - SVGViews

@implementation TMOSVGInfomationView

- (void)drawRect:(CGRect)rect {
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.513 green: 0.508 blue: 0.509 alpha: 1];
    
    //// Group 4
    {
        //// Oval 2 Drawing
        UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(17, 18, 61.88, 61.88)];
        [color2 setStroke];
        oval2Path.lineWidth = 2;
        [oval2Path stroke];
        
        
        //// Oval 3 Drawing
        UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(44.35, 30.04, 7.61, 7.61)];
        [color2 setFill];
        [oval3Path fill];
        
        
        //// Rectangle 3 Drawing
        UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(46, 43, 4, 25)];
        [color2 setFill];
        [rectangle3Path fill];
    }
}

@end
