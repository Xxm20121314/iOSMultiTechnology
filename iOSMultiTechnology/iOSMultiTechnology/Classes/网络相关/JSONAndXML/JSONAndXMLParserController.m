//
//  JSONAndXMLParserController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/29.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "JSONAndXMLParserController.h"
#import "NSURLConnectionManager.h"

#import "OCToJSONViewController.h"
#import "XMLParserViewController.h"
#import "JSONParserViewController.h"
#import "OCToModelViewController.h"
@interface JSONAndXMLParserController ()

@end

@implementation JSONAndXMLParserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XXMBridgeModel *item0= [[XXMBridgeModel alloc] init];
    item0.title = @"JSON和XML[简书]";
    item0.block = ^{
        BaseWebViewController *web = [[BaseWebViewController alloc] init];
        web.urlString = @"https://www.jianshu.com/p/2b0d84b812e6";
        [self.navigationController pushViewController:web animated:YES];
    };
    
    XXMBridgeModel *item1 = [[XXMBridgeModel alloc] init];
    item1.title = @"JSON解析(JSON数据 -> OC对象)";
    item1.bridgeClass = [JSONParserViewController class];

    XXMBridgeModel *item2= [[XXMBridgeModel alloc] init];
    item2.title = @"JSON解析(OC对象->JSON数据)";
    item2.bridgeClass = [OCToJSONViewController class];

    XXMBridgeModel *item3 = [[XXMBridgeModel alloc] init];
    item3.title = @"字典转模型(YYModel)";
    item3.destParams = @{@"dest_key":@"YYModel"};
    item3.bridgeClass = [OCToModelViewController class];

    XXMBridgeModel *item4 = [[XXMBridgeModel alloc] init];
    item4.title = @"字典转模型(MJExtension)";
    item4.destParams = @{@"dest_key":@"MJExtension"};
    item4.bridgeClass = [OCToModelViewController class];
    
    XXMBridgeModel *item5 = [[XXMBridgeModel alloc] init];
    item5.title = @"XML解析(NSXMLParser)";
    item5.bridgeClass = [XMLParserViewController class];
    
    [self.lists addObjectsFromArray:@[item0,item1,item2,item3,item4,item5]];
    [self.tableView reloadData];
}

#pragma mark - 字典转模型

@end
