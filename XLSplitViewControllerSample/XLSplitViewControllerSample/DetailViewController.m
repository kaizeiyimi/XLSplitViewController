//
//  DetailViewController.m
//  XLSplitViewControllerSample
//
//  Created by kaizei on 13-9-26.
//  Copyright (c) 2013 kaizei. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) XLSplitPopover *xlPopover;

@end

@implementation DetailViewController

- (void)setContentWithItem:(id)item
{
    self.contentLabel.text = [item description];
    [self.xlPopover dismissPopoverAnimated:YES];
}

#pragma mark - XLSplitViewControllerDelegate
- (void)splitViewController:(XLSplitViewController *)splitViewController willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem popover:(XLSplitPopover *)popover
{
    barButtonItem.title = @"master";
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.xlPopover = popover;
}

- (void)splitViewController:(XLSplitViewController *)splitViewController willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

@end
