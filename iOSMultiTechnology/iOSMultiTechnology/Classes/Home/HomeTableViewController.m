//
//  HomeTableViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "HomeTableViewController.h"

#import "NetWorkTableController.h"

@implementation HomeTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    XXMBridgeModel *item1= [[XXMBridgeModel alloc] init];
    item1.title = @"网络相关";
    item1.bridgeClass = [NetWorkTableController class];
    [self.lists addObjectsFromArray:@[item1]];
    [self.tableView reloadData];
}
@end
