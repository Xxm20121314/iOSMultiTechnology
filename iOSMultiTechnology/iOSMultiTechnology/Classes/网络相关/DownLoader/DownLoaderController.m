//
//  DownLoaderController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/31.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "DownLoaderController.h"
#import "DLSmallFileController.h"
#import "DLBigFIieResumeController.h"
#import "DLBigFIieNSFileHandleController.h"
#import "DLBigFIieNSOutputStreamController.h"
@interface DownLoaderController ()

@end

@implementation DownLoaderController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self creatDir:kCachesDownloadPath]){
        [self setUp];
    }
}
#pragma 创建文件夹
- (BOOL)creatDir:(NSString *)path{
    if (path.length==0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = YES;
    BOOL isExist = [fileManager fileExistsAtPath:path];
    if (isExist==NO) {
        NSError *error;
        if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            isSuccess = NO;
            NSLog(@"creat Directory Failed:%@",[error localizedDescription]);
        }
    }
    return isSuccess;
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
    
    [self.lists addObjectsFromArray:@[item0,item1,item2,item3]];
    [self.tableView reloadData];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
