//
//  FileOperationController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/31.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "FileOperationController.h"

#import "UpLoadController.h"
#import "DLSmallFileController.h"
#import "DLMultithreadController.h"
#import "DLBigFIieResumeController.h"
#import "DLBigFIieNSFileHandleController.h"
#import "DLBigFIieNSOutputStreamController.h"
@interface FileOperationController ()

@end

@implementation FileOperationController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    XXMBridgeModel *item0 = [[XXMBridgeModel alloc] init];
    item0.title = @"小文件下载";
    item0.bridgeClass = [DLSmallFileController class];
    
    XXMBridgeModel *item1 = [[XXMBridgeModel alloc] init];
    item1.title = @"大文件下载";
    item1.subTitle = @"(文件句柄)NSFileHandle";
    item1.bridgeClass = [DLBigFIieNSFileHandleController class];
    
    XXMBridgeModel *item2 = [[XXMBridgeModel alloc] init];
    item2.title = @"大文件下载";
    item2.subTitle = @"断点下载";
    item2.bridgeClass = [DLBigFIieResumeController class];
    
    XXMBridgeModel *item3 = [[XXMBridgeModel alloc] init];
    item3.title = @"大文件下载";
    item3.subTitle = @"(输出流)NSOutputStream";
    item3.bridgeClass = [DLBigFIieNSOutputStreamController class];
    
    XXMBridgeModel *item4 = [[XXMBridgeModel alloc] init];
    item4.title = @"文件上传";
    item4.bridgeClass = [UpLoadController class];
    
    XXMBridgeModel *item5 = [[XXMBridgeModel alloc] init];
    item5.title = @"文件下载";
    item5.subTitle = @"多线程（单任务）";
    item5.bridgeClass = [DLMultithreadController class];
    
    [self.lists addObjectsFromArray:@[item0,item1,item2,item3,item4,item5]];
    [self.tableView reloadData];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
