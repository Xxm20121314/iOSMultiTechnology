//
//  NSURLConnectionController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLConnectionController.h"
#import "NSURLConnectionManager.h"

#import "NSURLConnGetSyncController.h"
#import "NSURLConnGetAsyncController.h"
#import "NSURLConnPOSTSyncController.h"
#import "NSURLConnPOSTAsyncController.h"
#import "NSURLConnGCDRunLoopController.h"
#import "NSURLConnGetDelegateController.h"
#import "NSURLConnPOSTDelegateController.h"
@implementation NSURLConnectionController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    kWeakSelf
    XXMBridgeModel *item0 = [[XXMBridgeModel alloc] init];
    item0.title = @"NSURLConnection简书";
    item0.block = ^{
        BaseWebViewController *web = [[BaseWebViewController alloc] init];
        web.urlString = @"https://www.jianshu.com/p/1ddf42be4e65";
        [weakSelf.navigationController pushViewController:web animated:YES];
    };
    
    XXMBridgeModel *item1 = [[XXMBridgeModel alloc] init];
    item1.title = @"GET同步请求";
    item1.subTitle = @"阻塞线程";
    item1.bridgeClass = [NSURLConnGetSyncController class];
    
    XXMBridgeModel *item2 = [[XXMBridgeModel alloc] init];
    item2.title = @"GET异步请求";
    item2.subTitle = @"不阻塞线程";
    item2.bridgeClass = [NSURLConnGetAsyncController class];

    
    XXMBridgeModel *item3 = [[XXMBridgeModel alloc] init];
    item3.title = @"GETDelegate请求";
    item3.subTitle = @"默认主线程";
    item3.bridgeClass = [NSURLConnGetDelegateController class];
    
    XXMBridgeModel *item4 = [[XXMBridgeModel alloc] init];
    item4.title = @"POST同步请求";
    item4.subTitle = @"阻塞线程";
    item4.bridgeClass = [NSURLConnPOSTSyncController class];
    
    XXMBridgeModel *item5 = [[XXMBridgeModel alloc] init];
    item5.title = @"POST异步请求";
    item5.subTitle = @"不阻塞线程";
    item5.bridgeClass = [NSURLConnPOSTAsyncController class];
    
    XXMBridgeModel *item6 = [[XXMBridgeModel alloc] init];
    item6.title = @"POSTDelegate请求";
    item6.subTitle = @"默认主线程";
    item6.bridgeClass = [NSURLConnPOSTDelegateController class];

    XXMBridgeModel *item7 = [[XXMBridgeModel alloc] init];
    item7.title = @"多线程请求";
    item7.subTitle = @"GCD、RunLoop";
    item7.bridgeClass = [NSURLConnGCDRunLoopController class];

    [self.lists addObjectsFromArray:@[item0,item1,item2,item3,item4,item5,item6,item7]];
    [self.tableView reloadData];
}


@end
