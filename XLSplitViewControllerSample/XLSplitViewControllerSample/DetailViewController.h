//
//  DetailViewController.h
//  XLSplitViewControllerSample
//
//  Created by kaizei on 13-9-26.
//  Copyright (c) 2013 kaizei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLSplitViewController.h"

@interface DetailViewController : UIViewController <XLSplitViewControllerDelegate>

@property (nonatomic, weak) XLSplitViewController *xlSplitViewController;

- (void)setContentWithItem:(id)item;

@end
