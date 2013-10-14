//
//  CustomSplitViewController.m
//  XLSplitViewControllerSample
//
//  Created by kaizei on 13-9-26.
//  Copyright (c) 2013 kaizei. All rights reserved.
//

#import "CustomSplitViewController.h"

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface CustomSplitViewController ()

@end

@implementation CustomSplitViewController

/*
    if you use storyboard, you could use like this way. just initialize the master and detail viewControllers.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // first initialize the two viewControllers.
    UINavigationController *masterNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterNavigationController"];
    UINavigationController *detailNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNavigationController"];

    /*  second, set the splitViewController to each viewController.
     note that this step is not necessary. this is the convenient way to make the master and detail know each other.
     apple makes a readOnly property 'splitViewController' for UIViewController to find the container splitViewController,
     but I cannot use this property. So, I have to do things this way.
     */
    MasterViewController *masterViewController = (MasterViewController *)masterNavController.topViewController;
    masterViewController.xlSplitViewController = self;

    DetailViewController *detailViewController = (DetailViewController *)detailNavController.topViewController;
    detailViewController.xlSplitViewController = self;

    // step three, set the delegate
    self.delegate = detailViewController;

    //customize
    self.masterWidth = 260;

    //setup the two viewControllers
    self.viewControllers = @[masterNavController, detailNavController];
}

@end
