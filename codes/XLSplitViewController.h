//
//  XLSplitViewController.h
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


#import <UIKit/UIKit.h>

#pragma mark - XLSplitPopover interface
@interface XLSplitPopover : NSObject

- (void)dismissPopoverAnimated:(BOOL)animated;

@end

#pragma mark - XLSplitViewControllerDelegate
@class XLSplitViewController;

/// the methods are written in Apple's way. but only a few are declared.
@protocol XLSplitViewControllerDelegate <NSObject>

@optional
/**
    this method diffrence with apple's only at the last param.
    the param in apple's way is a 'UIPopoverController' object, and at most time, developers only call the 'dismissPopoverAnimated:' method.
    here I change the param to my custom Class 'XLSplitPopover', which only has one method 'dismissPopoverAnimated:'. You can call this method to make masterView hidden.
    @see UISplitViewControllerDelegate
 */
- (void)splitViewController:(XLSplitViewController *)splitViewController willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem popover:(XLSplitPopover *)popover;

/// works as the apple's way. @see UISplitViewControllerDelegate
- (void)splitViewController:(XLSplitViewController *)splitViewController willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem;

/**
    works as the apple's way.
    the default behavior shows master when landscape and hide master when Portrait.
    @see UISplitViewControllerDelegate.
 */
- (BOOL)splitViewController:(XLSplitViewController *)splitViewController shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation;

@end

@interface XLSplitViewController : UIViewController

@property (nonatomic, weak) id<XLSplitViewControllerDelegate> delegate;

/**
    this array should exactly have two viewControllers. the first will be the 'master' and the second will be the 'detail'.
    set the viewControllers will layout the two controllers' views. an assert is written to assure there are exactly two diffrent viewControllers.
 */
@property (nonatomic, copy) NSArray *viewControllers;

/// the split line's width between the 'master' and 'detail'. the default value is 1.0. Values less than 1.0 are interpreted as 1.0.
@property (nonatomic, assign) CGFloat splitLineWidth;

/**
    the master's width.
    NOTICE that the 'splitLineWidth' is not calculated in the master's width.
    the default value is 320.0. Values less than 0.0 are interpreted as 320.0.
 */
@property (nonatomic, assign) CGFloat masterWidth;

/// the color of the split line.
@property (nonatomic, strong) UIColor *splitLineColor;

/// helper method. @return the first viewController of the splitViewController.
- (UIViewController *)masterViewController;

/// helper method. @return the second viewController of the splitViewController.
- (UIViewController *)detailViewController;

@end
