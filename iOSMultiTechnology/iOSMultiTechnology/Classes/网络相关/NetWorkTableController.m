//
//  NetWorkTableController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NetWorkTableController.h"

#import "JSONAndXMLParserController.h"
#import "NSURLConnectionController.h"
@implementation NetWorkTableController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    
    XXMBridgeModel *item1= [[XXMBridgeModel alloc] init];
    item1.title = @"HTTP简书";
    item1.block = ^{
        BaseWebViewController *web = [[BaseWebViewController alloc] init];
        web.urlString = @"https://www.jianshu.com/p/4f2a08a7aa9e";
        [self.navigationController pushViewController:web animated:YES];
    };
    XXMBridgeModel *item2= [[XXMBridgeModel alloc] init];
    item2.title = @"NSURLConnection相关";
    item2.bridgeClass = [NSURLConnectionController class];
    
    XXMBridgeModel *item3= [[XXMBridgeModel alloc] init];
    item3.title = @"JSON&XML解析";
    item3.bridgeClass = [JSONAndXMLParserController class];
    
    [self.lists addObjectsFromArray:@[item1,item2,item3]];
    [self.tableView reloadData];
}

@end
