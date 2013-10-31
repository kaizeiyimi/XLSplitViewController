//
//  XLSplitViewController.m
//
//  Created by kaizei on 13-9-25.
//
//  The MIT License (MIT)

//  Copyright (c) 2013 kaizei

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "XLSplitViewController.h"

#pragma mark - XLSplitPopover category
@interface XLSplitPopover ()

@property (nonatomic, weak) XLSplitViewController *xlSplitViewController;

@end

#pragma mark - XLSplitView delegate
@protocol XLSplitViewDelegate <NSObject>

- (BOOL)shouldAutoHideMasterInOrientation:(UIInterfaceOrientation)orientation;
- (void)willHideMaster;
- (void)willShowMaster;

@end

#pragma mark - XLSplitView interface
@interface XLSplitView : UIView

@property (nonatomic, weak) id<XLSplitViewDelegate> delegate;

@property (nonatomic, strong, readonly) UIView *masterView;
@property (nonatomic, strong, readonly) UIView *detailView;

@property (nonatomic, assign) CGFloat splitLineWidth;
@property (nonatomic, assign) CGFloat masterWidth;
@property (nonatomic, assign, readonly) BOOL isMasterVisible;

- (void)setMasterView:(UIView *)masterView detailView:(UIView *)detailView;
- (void)toggleMasterVisible;
- (void)hideMasterAnimated:(BOOL)animated;
- (void)setSplitLineColor:(UIColor *)color;

@end

#pragma mark - XLSplitView implementation
@interface XLSplitView ()

@property (nonatomic, strong) UIView *masterView;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIView *splitLineView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, weak) UIView *realMasterView;

@property (nonatomic, assign) BOOL isInPopoverState;
@property (nonatomic, assign) BOOL isPoping;
@property (nonatomic, assign) BOOL isMasterVisible;

@end

@implementation XLSplitView

CGFloat const kDefaultMasterWidth = 320.0;
CGFloat const kDefaultSplitLineWidth = 1.0;
float const kDefaultAnimationDuration = 0.25;

@synthesize splitLineWidth = _splitLineWidth;
@synthesize masterWidth = _masterWidth;

- (void)setMasterView:(UIView *)masterView detailView:(UIView *)detailView
{
    if (self.isInPopoverState) {
        [self hideMasterAnimated:NO];
    }
    [_masterView removeFromSuperview];
    [_detailView removeFromSuperview];

    _masterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.masterViewWidth, self.bounds.size.height)];
    _masterView.backgroundColor = [UIColor clearColor];
    _masterView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;

    masterView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    self.realMasterView = masterView;
    [self.masterView addSubview:masterView];
    [_masterView addSubview:self.splitLineView];
    [self layoutMasterView];

    _detailView = detailView;
    _detailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self addSubview:_masterView];
    [self addSubview:_detailView];

    [self setNeedsLayout];
}

- (void)layoutMasterView
{
    self.masterView.frame = CGRectMake(0, 0, self.masterViewWidth, self.bounds.size.height);
    self.realMasterView.frame = CGRectMake(0, 0, self.masterWidth, self.bounds.size.height);
    self.splitLineView.frame = CGRectMake(self.masterWidth, 0, self.splitLineWidth, self.bounds.size.height);
}

- (UIView *)splitLineView
{
    if (!_splitLineView) {
        _splitLineView = [[UIView alloc]initWithFrame:CGRectMake(self.masterWidth, 0, self.splitLineWidth, self.bounds.size.height)];
        _splitLineView.backgroundColor = [UIColor blackColor];
        _splitLineView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    }
    return _splitLineView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideMaster)];
        [_maskView addGestureRecognizer:tapGesture];
        [self insertSubview:_maskView atIndex:0];
    }
    return _maskView;
}

- (void)setMasterWidth:(CGFloat)masterWidth
{
    masterWidth = masterWidth > 0 ? masterWidth : kDefaultMasterWidth;
    if (_masterWidth != masterWidth) {
        _masterWidth = masterWidth;
        [self layoutMasterView];
        [self setNeedsLayout];
    }
}

- (CGFloat)masterWidth
{
    return  _masterWidth > 0 ? _masterWidth : kDefaultMasterWidth;
}

- (void)setSplitLineWidth:(CGFloat)splitLineWidth
{
    splitLineWidth = splitLineWidth > kDefaultSplitLineWidth ? splitLineWidth : kDefaultSplitLineWidth;
    if (_splitLineWidth != splitLineWidth) {
        _splitLineWidth = splitLineWidth;
        [self layoutMasterView];
        [self setNeedsLayout];
    }
}

- (CGFloat)splitLineWidth
{
    return _splitLineWidth > kDefaultSplitLineWidth ? _splitLineWidth : kDefaultSplitLineWidth;
}

- (CGFloat)masterViewWidth
{
    return self.masterWidth + self.splitLineWidth;
}

- (void)setSplitLineColor:(UIColor *)color
{
    self.splitLineView.backgroundColor = color;
}

- (void)layoutSubviews
{
    if (self.isPoping) {
        return;
    }
    self.isInPopoverState = NO;
    self.maskView.hidden = YES;
    NSAssert(self.delegate, @"must set the XLSplitView's delegate.");
    if ([self.delegate shouldAutoHideMasterInOrientation:[UIApplication sharedApplication].statusBarOrientation]) {
        [self.delegate willHideMaster];
        self.masterView.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
        self.masterView.clipsToBounds = YES;
        self.detailView.frame = self.bounds;
        self.isMasterVisible = NO;
    } else {
        [self.delegate willShowMaster];
        self.masterView.frame = CGRectMake(0, 0, self.masterViewWidth, self.bounds.size.height);
        self.masterView.clipsToBounds = NO;
        CGRect frame = self.bounds;
        frame.origin.x = self.masterViewWidth;
        frame.size.width = self.bounds.size.width - self.masterViewWidth;
        self.detailView.frame = frame;
        self.isMasterVisible = YES;
    }
}

- (void)showMaster
{
    [self showMasterAnimated:YES];
}

- (void)showMasterAnimated:(BOOL)animated
{
    if (self.isInPopoverState) {
        return;
    }
    self.isPoping = YES;
    self.maskView.hidden = NO;
    [self bringSubviewToFront:self.maskView];
    [self bringSubviewToFront:self.masterView];
    self.isInPopoverState = YES;
    self.isMasterVisible = YES;
    if (animated) {
        self.masterView.clipsToBounds = YES;
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            self.masterView.frame = CGRectMake(0, 0, self.masterViewWidth, self.bounds.size.height);
        } completion:^(BOOL finished) {
            self.masterView.clipsToBounds = NO;
            self.isPoping = NO;
        }];
    } else {
        self.masterView.frame = CGRectMake(0, 0, self.masterViewWidth, self.bounds.size.height);
        self.isPoping = NO;
    }
}

- (void)hideMaster
{
    [self hideMasterAnimated:YES];
}

- (void)hideMasterAnimated:(BOOL)animated
{
    if (!self.isInPopoverState) {
        return;
    }
    self.isPoping = YES;
    self.maskView.hidden = YES;
    self.isInPopoverState = NO;
    self.isMasterVisible = NO;
    if (animated) {
        self.masterView.clipsToBounds = YES;
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            self.masterView.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
        } completion:^(BOOL finished) {
            self.isPoping = NO;
        }];
    } else {
        self.masterView.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
        self.isPoping = NO;
    }
}

- (void)toggleMasterVisible
{
    if (self.isInPopoverState) {
        [self hideMaster];
    } else {
        [self showMaster];
    }
}

@end

#pragma mark - XLSplitViewController
typedef NS_ENUM(NSInteger, MasterAutoShowingState) {
    MasterAutoShowingStateUnknown,
    MasterAutoShowingStateHide,
    MasterAutoShowingStateShow,
};

@interface XLSplitViewController () <XLSplitViewDelegate>

@property (nonatomic, weak) XLSplitView *splitView;
@property (nonatomic, assign) MasterAutoShowingState masterAutoShowingState;
@property (nonatomic, strong) UIBarButtonItem *barButtonItem;
@property (nonatomic, strong) XLSplitPopover *xlSplitPopover;

@end

@implementation XLSplitViewController

- (void)loadView
{
    XLSplitView *splitView = [[XLSplitView alloc]init];
    splitView.delegate = self;
    self.view = splitView;
}

- (XLSplitView *)splitView
{
    return (XLSplitView *)self.view;
}

- (void)setSplitLineWidth:(CGFloat)splitLineWidth
{
    self.splitView.splitLineWidth = splitLineWidth;
}

- (CGFloat)splitLineWidth
{
    return self.splitView.splitLineWidth;
}

- (void)setMasterWidth:(CGFloat)masterWidth
{
    self.splitView.masterWidth = masterWidth;
}

- (CGFloat)masterWidth
{
    return self.splitView.masterWidth;
}

- (void)setSplitLineColor:(UIColor *)color
{
    self.splitView.backgroundColor = color;
}

- (UIColor *)splitLineColor
{
    return self.splitView.backgroundColor;
}

- (BOOL)isMasterVisible
{
    return self.splitView.isMasterVisible;
}

- (UIViewController *)masterViewController
{
    return self.viewControllers[0];
}

- (UIViewController *)detailViewController
{
    return self.viewControllers[1];
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    NSAssert(self.viewControllers.count == 2 && self.masterViewController != self.detailViewController, @"should exactly have two diffrent viewControllers.");
    [self addChildViewController:self.masterViewController];
    [self addChildViewController:self.detailViewController];
    [self.splitView setMasterView:self.masterViewController.view detailView:self.detailViewController.view];
}

- (void)triggerDelegateWillHideMaster
{
    if (self.masterAutoShowingState != MasterAutoShowingStateHide
        && [self.delegate respondsToSelector:@selector(splitViewController:willHideViewController:withBarButtonItem:popover:)]) {
        UIBarButtonItem *barButtomItem = [[UIBarButtonItem alloc]init];
        barButtomItem.target = self.splitView;
        barButtomItem.action = @selector(toggleMasterVisible);
        self.barButtonItem = barButtomItem;

        XLSplitPopover *popover = [[XLSplitPopover alloc]init];
        popover.xlSplitViewController = self;
        self.xlSplitPopover = popover;

        [self.delegate splitViewController:self
                    willHideViewController:self.masterViewController
                         withBarButtonItem:barButtomItem
                                   popover:popover];
        self.masterAutoShowingState = MasterAutoShowingStateHide;
    }
}

- (void)triggerDelegateWillShowMaster
{
    if (self.masterAutoShowingState != MasterAutoShowingStateShow
        && [self.delegate respondsToSelector:@selector(splitViewController:willShowViewController:invalidatingBarButtonItem:)]) {
        [self.delegate splitViewController:self
                    willShowViewController:self.masterViewController
                 invalidatingBarButtonItem:self.barButtonItem];
        self.barButtonItem = nil;
        self.xlSplitPopover = nil;
        self.masterAutoShowingState = MasterAutoShowingStateShow;
    }
}

- (void)hideMasterAnimated:(BOOL)animated
{
    [self.splitView hideMasterAnimated:animated];
}

- (BOOL)shouldAutoHideMasterInOrientation:(UIInterfaceOrientation)orientation
{
    if (![self.delegate respondsToSelector:@selector(splitViewController:shouldHideViewController:inOrientation:)]) {
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return [self.delegate splitViewController:self shouldHideViewController:self.masterViewController inOrientation:orientation];
    }
}

- (void)willHideMaster
{
    [self triggerDelegateWillHideMaster];
}

- (void)willShowMaster
{
    [self triggerDelegateWillShowMaster];
}

@end

#pragma mark - XLSplitPopover implementation
@implementation XLSplitPopover

- (void)dismissPopoverAnimated:(BOOL)animated
{
    [self.xlSplitViewController hideMasterAnimated:animated];
}

@end
