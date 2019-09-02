//
//  FileOperationController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/31.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "ConnectionFileOperationController.h"

#import "ConnectionDownloadlMultithreadController.h"
#import "ConnectionUpLoadController.h"
#import "ConnectionDownloadlFileController.h"
#import "ConnectionDownloadResumeController.h"
#import "ConnectionDownloadFileHandleController.h"
#import "ConnectionDownloadOutputStreamController.h"
@interface ConnectionFileOperationController ()

@end

@implementation ConnectionFileOperationController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    XXMBridgeModel *item0 = [[XXMBridgeModel alloc] init];
    item0.title = @"小文件下载";
    item0.bridgeClass = [ConnectionDownloadlFileController class];
    
    XXMBridgeModel *item1 = [[XXMBridgeModel alloc] init];
    item1.title = @"大文件下载";
    item1.subTitle = @"(文件句柄)NSFileHandle";
    item1.bridgeClass = [ConnectionDownloadFileHandleController class];
    
    XXMBridgeModel *item2 = [[XXMBridgeModel alloc] init];
    item2.title = @"大文件下载";
    item2.subTitle = @"断点下载";
    item2.bridgeClass = [ConnectionDownloadResumeController class];
    
    XXMBridgeModel *item3 = [[XXMBridgeModel alloc] init];
    item3.title = @"大文件下载";
    item3.subTitle = @"(输出流)NSOutputStream";
    item3.bridgeClass = [ConnectionDownloadOutputStreamController class];
    
    XXMBridgeModel *item4 = [[XXMBridgeModel alloc] init];
    item4.title = @"文件上传";
    item4.bridgeClass = [ConnectionUpLoadController class];
    
    XXMBridgeModel *item5 = [[XXMBridgeModel alloc] init];
    item5.title = @"文件下载";
    item5.subTitle = @"多线程（单任务）";
    item5.bridgeClass = [ConnectionDownloadlMultithreadController class];
    
    [self.lists addObjectsFromArray:@[item0,item1,item2,item3,item4,item5]];
    [self.tableView reloadData];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
