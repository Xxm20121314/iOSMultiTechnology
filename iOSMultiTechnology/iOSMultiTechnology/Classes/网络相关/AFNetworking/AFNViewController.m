//
//  AFNViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "AFNViewController.h"

#import "AFNGetAndPostController.h"
#import "AFNSerializerXMLController.h"
#import "AFNSerializerDataController.h"
#import "AFNSerializerHtmlViewController.h"
@implementation AFNViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    XXMBridgeModel *item0 = [[XXMBridgeModel alloc] init];
    item0.title = @"简单的GET和POST请求";
    item0.subTitle = @"JSON解析";
    item0.bridgeClass = [AFNGetAndPostController class];
    
    XXMBridgeModel *item1 = [[XXMBridgeModel alloc] init];
    item1.title = @"AFN序列化";
    item1.subTitle = @"XML解析";
    item1.bridgeClass = [AFNSerializerXMLController class];
    
    XXMBridgeModel *item2 = [[XXMBridgeModel alloc] init];
    item2.title = @"AFN序列化";
    item2.subTitle = @"图片等二进制数据";
    item2.bridgeClass = [AFNSerializerDataController class];
    
    XXMBridgeModel *item3 = [[XXMBridgeModel alloc] init];
    item3.title = @"AFN序列化";
    item3.subTitle = @"网页源码";
    item3.bridgeClass = [AFNSerializerHtmlViewController class];
    
    [self.lists addObjectsFromArray:@[item0,item1,item2,item3]];
    [self.tableView reloadData];
}
@end
