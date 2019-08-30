//
//  SessionFileOperationController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/28.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "SessionFileOperationController.h"

#import "SessionUploadViewController.h"
#import "SessionDownloadTaskController.h"
#import "SessionBreakpointDownloadController.h"
#import "SessionDownloadFileHandleController.h"
#import "SessionDownloadTaskDelegateController.h"
#import "SessionDownloadOutputStreamController.h"
#import "SessionBreakpointDownloadWithExitController.h"
@interface SessionFileOperationController ()

@end

@implementation SessionFileOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    XXMBridgeModel *item0 = [[XXMBridgeModel alloc] init];
    item0.title = @"文件下载";
    item0.subTitle = @"Block(DownloadTask)";
    item0.bridgeClass = [SessionDownloadTaskController class];

    XXMBridgeModel *item1 = [[XXMBridgeModel alloc] init];
    item1.title = @"文件下载";
    item1.subTitle = @"Delegate(DownloadTask) ";
    item1.bridgeClass = [SessionDownloadTaskDelegateController class];
    
    XXMBridgeModel *item2 = [[XXMBridgeModel alloc] init];
    item2.title = @"文件下载";
    item2.subTitle = @"文件句柄 (DataTask)";
    item2.bridgeClass = [SessionDownloadFileHandleController class];
    
    XXMBridgeModel *item3 = [[XXMBridgeModel alloc] init];
    item3.title = @"文件下载";
    item3.subTitle = @"输出流(DataTask)";
    item3.bridgeClass = [SessionDownloadOutputStreamController class];
    
    XXMBridgeModel *item4 = [[XXMBridgeModel alloc] init];
    item4.title = @"文件下载";
    item4.subTitle = @"断点下载(DownloadTask) ";
    item4.bridgeClass = [SessionBreakpointDownloadController class];
    
    XXMBridgeModel *item5 = [[XXMBridgeModel alloc] init];
    item5.title = @"文件下载";
    item5.subTitle = @"断点续传(支持离线、NSFileHandle) ";
    item5.bridgeClass = [SessionBreakpointDownloadWithExitController class];
    
    XXMBridgeModel *item6 = [[XXMBridgeModel alloc] init];
    item6.title = @"文件上传";
    item6.bridgeClass = [SessionUploadViewController class];
    
    [self.lists addObjectsFromArray:@[item0,item1,item2,item3,item4,item5,item6]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
