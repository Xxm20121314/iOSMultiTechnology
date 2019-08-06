//
//  NetWorkTableController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NetWorkTableController.h"

#import "FileOperationController.h"
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
    XXMBridgeModel *item1= [[XXMBridgeModel alloc] init];
    item1.title = @"iOS解决字典和数组中输出乱码的问题";
    item1.subTitle = @"查看Foundation+Log类文件";
    item1.block = ^{
        BaseWebViewController *web = [[BaseWebViewController alloc] init];
        web.urlString = @"https://www.jianshu.com/p/0f1602e4f0da";
        [weakSelf.navigationController pushViewController:web animated:YES];
    };
    
    XXMBridgeModel *item2= [[XXMBridgeModel alloc] init];
    item2.title = @"NSURLConnection相关";
    item2.bridgeClass = [NSURLConnectionController class];
    
    XXMBridgeModel *item3= [[XXMBridgeModel alloc] init];
    item3.title = @"JSON&XML解析";
    item3.bridgeClass = [JSONAndXMLParserController class];
    
    XXMBridgeModel *item4= [[XXMBridgeModel alloc] init];
    item4.title = @"文件下载与上传";
    item4.bridgeClass = [FileOperationController class];
    
    
    [self.lists addObjectsFromArray:@[item0,item1,item2,item3,item4]];
    [self.tableView reloadData];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
