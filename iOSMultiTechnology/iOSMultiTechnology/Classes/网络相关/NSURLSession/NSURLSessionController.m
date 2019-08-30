//
//  NSURLSessionController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/26.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLSessionController.h"
#import "NSURLSessionGetController.h"
#import "NSURLSessionPostController.h"
#import "NSURLSessionDelegateController.h"
@interface NSURLSessionController ()

@end

@implementation NSURLSessionController

- (void)viewDidLoad {
    [super viewDidLoad];
    kWeakSelf
    XXMBridgeModel *item0 = [[XXMBridgeModel alloc] init];
    item0.title = @"NSURLSession简书";
    item0.block = ^{
        BaseWebViewController *web = [[BaseWebViewController alloc] init];
        web.urlString = @"https://www.jianshu.com/p/1bdc9f0e4f36";
        [weakSelf.navigationController pushViewController:web animated:YES];
    };
    
    XXMBridgeModel *item1 = [[XXMBridgeModel alloc] init];
    item1.title = @"GET请求";
    item1.bridgeClass = [NSURLSessionGetController class];
    
    XXMBridgeModel *item2 = [[XXMBridgeModel alloc] init];
    item2.title = @"POST请求";
    item2.bridgeClass = [NSURLSessionPostController class];
    
    XXMBridgeModel *item3 = [[XXMBridgeModel alloc] init];
    item3.title = @"Delegate请求";
    item3.subTitle = @"GET例子";
    item3.bridgeClass = [NSURLSessionDelegateController class];
    
    XXMBridgeModel *item4= [[XXMBridgeModel alloc] init];
    item4.title = @"NSURLConfiguration知识点";
    item4.block = ^{
        BaseWebViewController *web = [[BaseWebViewController alloc] init];
        web.sourceName = @"NSURLConfigurationBook.txt";
        [weakSelf.navigationController pushViewController:web animated:YES];
    };
    
    [self.lists addObjectsFromArray:@[item0,item1,item2,item3,item4]];
    [self.tableView reloadData];
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
