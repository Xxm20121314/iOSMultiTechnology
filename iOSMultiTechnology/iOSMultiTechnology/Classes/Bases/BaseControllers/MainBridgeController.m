//
//  MainBridgeController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/29.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "MainBridgeController.h"
@interface MainBridgeController ()

@end

@implementation MainBridgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

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
        if (item.destParams){
            if ([vc isKindOfClass:[BaseViewController class]]) {
                [(BaseViewController*)vc setDestParams:item.destParams];
            }
        }
        if ([vc isKindOfClass:[UIViewController class]]) {
            vc.navigationItem.title = [NSString stringWithFormat:@"%@%@",item.title,[NSString toString:item.subTitle]];
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
