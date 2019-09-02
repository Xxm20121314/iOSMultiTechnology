//
//  AFNFileOperationController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "AFNFileOperationController.h"
#import "AFNDownloadController.h"
#import "AFNUploadViewController.h"
@interface AFNFileOperationController ()

@end

@implementation AFNFileOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    XXMBridgeModel *item0 = [[XXMBridgeModel alloc] init];
    item0.title = @"文件下载";
    item0.bridgeClass = [AFNDownloadController class];
    
    XXMBridgeModel *item1 = [[XXMBridgeModel alloc] init];
    item1.title = @"文件上传";
    item1.bridgeClass = [AFNUploadViewController class];
    
    [self.lists addObjectsFromArray:@[item0,item1]];
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
