//
//  MasterViewController.m
//  XLSplitViewControllerSample
//
//  Created by kaizei on 13-9-26.
//  Copyright (c) 2013 kaizei. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *string = cell.textLabel.text;
    UINavigationController *detailNavigationController = (UINavigationController *)[self.xlSplitViewController detailViewController];
    DetailViewController *detailViewController = (DetailViewController *)detailNavigationController.topViewController;
    [detailViewController setContentWithItem:string];
}

@end
