//
//  NetWorkTableController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NetWorkTableController.h"

#import "AFNViewController.h"
#import "NSURLSessionController.h"
#import "NSURLConnectionController.h"
#import "JSONAndXMLParserController.h"
@implementation NetWorkTableController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    kWeakSelf
    XXMBridgeModel *item0= [[XXMBridgeModel alloc] init];
    item0.title = @"HTTP简书";
    item0.block = ^{
        BaseWebViewController *web = [[BaseWebViewController alloc] init];
        web.urlString = @"https://www.jianshu.com/p/4f2a08a7aa9e";
        [weakSelf.navigationController pushViewController:web animated:YES];
    };
    
    XXMBridgeModel *item1 = [[XXMBridgeModel alloc] init];
    item1.title = @"NSURLConnection相关";
    item1.bridgeClass = [NSURLConnectionController class];
    
    XXMBridgeModel *item2 = [[XXMBridgeModel alloc] init];
    item2.title = @"NSURLSession相关";
    item2.bridgeClass = [NSURLSessionController class];
    
    XXMBridgeModel *item3 = [[XXMBridgeModel alloc] init];
    item3.title = @"AFNetworking相关";
    item3.bridgeClass = [AFNViewController class];
    
    XXMBridgeModel *item4 = [[XXMBridgeModel alloc] init];
    item4.title = @"JSON&XML解析";
    item4.bridgeClass = [JSONAndXMLParserController class];
    
    XXMBridgeModel *item5= [[XXMBridgeModel alloc] init];
    item5.title = @"HTTP状态码";
    item5.block = ^{
        BaseWebViewController *web = [[BaseWebViewController alloc] init];
        web.sourceName = @"HTTP状态码.txt";
        [weakSelf.navigationController pushViewController:web animated:YES];
    };
    
    [self.lists addObjectsFromArray:@[item0,item1,item2,item3,item4,item5]];
    [self.tableView reloadData];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
