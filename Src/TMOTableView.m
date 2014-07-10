//
//  TMOTableView.m
//  TeemoV2
//
//  Created by 崔明辉 on 14-6-18.
//  Copyright (c) 2014年 com.duowan.zpc. All rights reserved.
//

#import "TMOTableView.h"
#import "XHActivityIndicatorView.h"





@interface TMOTableView ()

@end

@implementation TMOTableView

- (void)dealloc {
    if (self.myRefreshControl != nil) {
        [self removeObserver:self.myRefreshControl forKeyPath:@"contentOffset"];
    }
    if (self.myLoadMoreControl != nil) {
        [self removeObserver:self.myLoadMoreControl forKeyPath:@"contentOffset"];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)firstLoadWithBlock:(TMOTableviewCallback)argBlock
           withLoadingView:(UIView *)argLoadingView
              withFailView:(UIView *)argFailView {
    _myFirstLoadControl = [[TMOFirstLoadControl alloc] initWithTableView:self];
    self.myFirstLoadControl.callback = argBlock;
    self.myFirstLoadControl.loadingView = argLoadingView;
    self.myFirstLoadControl.failView = argFailView;
    [self.myFirstLoadControl setup];
    [self.myFirstLoadControl start];
}

- (void)firstLoadWithBlock:(TMOTableviewCallback)argBlock
               withYOffset:(CGFloat)argYOffset {
    _myFirstLoadControl = [[TMOFirstLoadControl alloc] initWithTableView:self];
    self.myFirstLoadControl.callback = argBlock;
    self.myFirstLoadControl.yOffset = argYOffset;
    [self.myFirstLoadControl setup];
    [self.myFirstLoadControl start];
}

- (void)setup {
}

- (BOOL)isValid {
    if ([self isTableViewController]) {
        return YES;
    }
    return self.superview != nil;
}

- (BOOL)isTableViewController {
    return [[self nextResponder] isKindOfClass:[UITableViewController class]];
}

- (void)reloadData {
    if (!self.isValid) {
        return;
    }
    
    if (self.myLoadMoreControl != nil) {
        self.myLoadMoreControl.alpha = 0;
    }
    [super reloadData];
    if (self.myLoadMoreControl != nil) {
        [self.myLoadMoreControl setFrame:CGRectMake(0, self.contentSize.height, self.frame.size.width, 44)];
        self.myLoadMoreControl.alpha = 1;
    }
}

- (void)refreshDone {
    if (!self.isValid) {
        return;
    }
    [self reloadData];
    [self.myRefreshControl performSelector:@selector(stop) withObject:nil afterDelay:0.5];
}

- (void)loadMoreDone {
    if (!self.isValid) {
        return;
    }
    if (self.myLoadMoreControl != nil && self.myLoadMoreControl.isInvalid == YES) {
        [self.myLoadMoreControl stop];
        return;
    }
    [self reloadData];
    [self.myLoadMoreControl stop];
}

- (void)refreshWithCallback:(TMOTableviewCallback)argCallback withDelay:(NSTimeInterval)argDelay {
    _myRefreshControl = [[TMORefreshControl alloc] initWithTableView:self];
    [self.myRefreshControl setDelay:argDelay];
    [self.myRefreshControl setCallback:argCallback];
    if ([self isTableViewController]) {
        [self addSubview:self.myRefreshControl];
    }
    else {
        [self.superview addSubview:self.myRefreshControl];
        [self.superview bringSubviewToFront:self];
        [self setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)refreshAndScrollToTop {
    if (self.myRefreshControl != nil) {
        [self.myRefreshControl refreshAndScrollToTop];
    }
}

- (void)loadMoreWithCallback:(TMOTableviewCallback)argCallback withDelay:(NSTimeInterval)argDelay {
    _myLoadMoreControl = [[TMOLoadMoreControl alloc] initWithTableView:self];
    [self.myLoadMoreControl setDelay:argDelay];
    [self.myLoadMoreControl setCallback:argCallback];
    [self addSubview:self.myLoadMoreControl];
}

- (UIViewController *)tableViewParentViewController {
    if ([self isTableViewController]) {
        return (UIViewController *)[self nextResponder];
    }
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end




