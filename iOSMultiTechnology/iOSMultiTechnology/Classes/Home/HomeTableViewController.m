//
//  HomeTableViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "HomeTableViewController.h"

#import "NetWorkTableController.h"
#import "FileTableViewController.h"
@implementation HomeTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    XXMBridgeModel *item1= [[XXMBridgeModel alloc] init];
    item1.title = @"网络相关";
    item1.subTitle = @"NSURLConnection、NSURLSession";
    item1.bridgeClass = [NetWorkTableController class];
    
    XXMBridgeModel *item2= [[XXMBridgeModel alloc] init];
    item2.title = @"文件相关";
    item2.subTitle = @"下载、上传、压缩、解压缩";
    item2.bridgeClass = [FileTableViewController class];
    
    [self.lists addObjectsFromArray:@[item1,item2]];
    [self.tableView reloadData];
}
@end
