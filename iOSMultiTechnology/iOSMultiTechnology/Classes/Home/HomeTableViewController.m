//
//  HomeTableViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "HomeTableViewController.h"

#import "NetWorkTableController.h"
@interface HomeTableViewController ()
@property (nonatomic,strong) NSMutableArray *lists;
@end

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
#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXMBridgeCell *cell = [XXMBridgeCell cellWithTableView:tableView];
    cell.item = self.lists[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXMBridgeModel *item = self.lists[indexPath.row];
    if (item.block) {
        item.block();
        return;
    }
    if(item.bridgeClass){
        UIViewController *vc = [[item.bridgeClass alloc] init];
        if ([vc isKindOfClass:[UIViewController class]]) {
            vc.navigationItem.title = item.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - getting
- (NSMutableArray *)lists
{
    if (!_lists) {
        _lists = [NSMutableArray new];
    }
    return _lists;
}

@end
