//
//  JSONAndXMLParserController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/29.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "JSONAndXMLParserController.h"

#import "OCToJSONViewController.h"
#import "XMLParserViewController.h"
#import "OCToModelViewController.h"
#import "JSONParserViewController.h"
#import "XMLGDataParserViewController.h"
@interface JSONAndXMLParserController ()

@end

@implementation JSONAndXMLParserController

- (void)viewDidLoad {
    [super viewDidLoad];
    XXMBridgeModel *item0= [[XXMBridgeModel alloc] init];
    item0.title = @"JSON和XML[简书]";
    kWeakSelf
    item0.block = ^{
        BaseWebViewController *web = [[BaseWebViewController alloc] init];
        web.urlString = @"https://www.jianshu.com/p/2b0d84b812e6";
        [weakSelf.navigationController pushViewController:web animated:YES];
    };
    
    XXMBridgeModel *item1 = [[XXMBridgeModel alloc] init];
    item1.title = @"JSON解析";
    item1.subTitle = @"JSON数据 -> OC对象";
    item1.bridgeClass = [JSONParserViewController class];

    XXMBridgeModel *item2= [[XXMBridgeModel alloc] init];
    item2.title = @"JSON解析";
    item2.subTitle = @"OC对象->JSON数据";
    item2.bridgeClass = [OCToJSONViewController class];

    XXMBridgeModel *item3 = [[XXMBridgeModel alloc] init];
    item3.title = @"字典转模型";
    item2.subTitle = @"YYModel";
    item3.destParams = @{@"dest_key":@"YYModel"};
    item3.bridgeClass = [OCToModelViewController class];

    XXMBridgeModel *item4 = [[XXMBridgeModel alloc] init];
    item4.title = @"字典转模型";
    item4.subTitle = @"MJExtension";
    item4.destParams = @{@"dest_key":@"MJExtension"};
    item4.bridgeClass = [OCToModelViewController class];
    
    XXMBridgeModel *item5 = [[XXMBridgeModel alloc] init];
    item5.title = @"XML解析";
    item5.subTitle = @"NSXMLParser";
    item5.bridgeClass = [XMLParserViewController class];
    
    XXMBridgeModel *item6 = [[XXMBridgeModel alloc] init];
    item6.title = @"XML解析";
    item6.subTitle = @"GDataParser";
    item6.bridgeClass = [XMLGDataParserViewController class];
    
    [self.lists addObjectsFromArray:@[item0,item1,item2,item3,item4,item5,item6]];
    [self.tableView reloadData];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
