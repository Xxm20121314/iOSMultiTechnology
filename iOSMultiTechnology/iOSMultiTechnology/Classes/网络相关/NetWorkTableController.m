//
//  NetWorkTableController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NetWorkTableController.h"

@interface NetWorkTableController ()
@property (nonatomic,strong) NSMutableArray *lists;
@end

@implementation NetWorkTableController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    XXMBridgeModel *item1= [[XXMBridgeModel alloc] init];
    item1.title = @"HTTP知识点";
    item1.block = ^{
        BaseWebViewController *web = [[BaseWebViewController alloc] init];
        web.urlString = @"https://www.jianshu.com/p/781ce5e64f7e";
        [self.navigationController pushViewController:web animated:YES];
    };
    [self.lists addObjectsFromArray:@[item1]];
    self.tableView.rowHeight = [XXMBridgeCell defaultHeight];
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
    if(item.linkClass)
    {
        UIViewController *vc = [[item.linkClass alloc] init];
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
