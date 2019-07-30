//
//  JSONAndXMLParserController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/29.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "JSONAndXMLParserController.h"
#import "NSURLConnectionManager.h"

@interface JSONAndXMLParserController ()<NSXMLParserDelegate>

@end

@implementation JSONAndXMLParserController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *address = @"http://apis.juhe.cn/cook/category";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{@"parentid":@(10001), //分类ID,默认全部
                                       @"dtype":@"json",  //返回数据的格式,xml或json，默认json
                                       @"key":@"bc2ee87d058a09f523e817ad1eb300e5"}];
    kWeakSelf
    XXMBridgeModel *item1 = [[XXMBridgeModel alloc] init];
    item1.title = @"JSON解析(JSON数据 -> OC对象)";
    item1.block = ^{
        
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage GET:address params:params data:^(NSData *resultData, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
                return ;
            }
            //JSON数据 -> OC对象
            [weakSelf JSONToOC:resultData];
        }];
    };
    XXMBridgeModel *item2= [[XXMBridgeModel alloc] init];
    item2.title = @"JSON解析(OC对象->JSON数据)";
    item2.block = ^{
        //JSON数据 -> OC对象
        [weakSelf OCToJSON];
    };
    
    XXMBridgeModel *item3 = [[XXMBridgeModel alloc] init];
    item3.title = @"XML异步";
    item3.block = ^{
        [params setObject:@"xml" forKey:@"dtype"];
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage GET:address params:params data:^(NSData *resultData, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
                return ;
            }
            // XML数据->OC
            [weakSelf xmlParser:resultData];
        }];
    };
    XXMBridgeModel *item4 = [[XXMBridgeModel alloc] init];
    item4.title = @"字典转模型(YYModel)";
    item4.block = ^{
            // XML数据->OC
//            [weakSelf xmlParser:resultData];
    };
    XXMBridgeModel *item5 = [[XXMBridgeModel alloc] init];
    item5.title = @"字典转模型('MJExtension')";
    item5.block = ^{
        // XML数据->OC
        //            [weakSelf xmlParser:resultData];
    };
    [self.lists addObjectsFromArray:@[item1,item2,item3,item4,]];
    [self.tableView reloadData];
}
#pragma mark - JSON数据 -> OC对象
- (void)JSONToOC:(NSData*)data
{
    //JSON数据 -> OC对象
    /*
     第一个参数：要解析的JSON数据，是NSData类型也就是二进制数据
     第二个参数: 解析JSON的可选配置参数
     NSJSONReadingMutableContainers 解析出来的NSDictionary和NSArray是可变的
     NSJSONReadingMutableLeaves 解析出来的对象中的NSString是可变的, 不推荐使用。（解析不出来。）
     NSJSONReadingAllowFragments 被解析的JSON数据的top-level 如果既不是NSDictionary也不是NSArray， 需使用该值.
     默认值0orkNilOptions
     */
   id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"JSONParser: obj:\n%@",obj);
}
#pragma mark - OC对象->JSON对象
- (void)OCToJSON
{
    id obj = @{@"result":@[@{@"name":@"菜式菜品",
                                         @"parentId":@(10001),
                                         @"list":@[@{@"id":@(1),
                                                     @"name":@"家常菜",
                                                     @"parentId":@(10001)},
                                                   @{@"id":@(2),
                                                     @"name":@"快手菜",
                                                     @"parentId":@(10001)},
                                                   @{@"id":@(3),
                                                     @"name":@"创意菜",
                                                     @"parentId":@(10001)},
                                                   @{@"id":@(4),
                                                     @"name":@"素菜",
                                                     @"parentId":@(10001)},
                                                   ]
                                         }],
                           @"resultcode":@(200),
                           @"reason":@"Success",
                           @"error_code":@(0)
                           };
    //方法判断当前OC对象能否转换为JSON数据
    /**
     具体限制：
     obj是NSArray 或 NSDictionay 以及他们派生出来的子类
     obj 包含的所有对象是NSString,NSNumber,NSArray,NSDictionary 或NSNull
     字典中所有的key必须是NSString类型的
     NSNumber的对象不能是NaN或无穷大
     */
//     obj = @"abc123"; topL-level 是NSString 不支持
    if (![NSJSONSerialization isValidJSONObject:obj]) {
        NSLog(@"当前对象OC对象不支持转为SON数据");
        return;
    }
    NSError *error = nil;
    /**
     NSJSONWritingPrettyPrinted 漂亮的排版。对转换之后的JSON对象进行排版
     NSJSONWritingSortedKeys ios 11.0 之后使用,会对生成的数据，按照key的字母大小进行排序。数据一行显示.
     默认值 0or kNilOptions 数据一行显示
     */
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"error:%@",error);
        return;
    }
    NSString *path = [kDocumentPath stringByAppendingPathComponent:@"123.json"];
    [data writeToFile:path atomically:YES];
    NSLog(@"查看Document中Jjson数据:\n%@",path);
}
#pragma mark - 字典转模型

- (void)xmlParser:(NSData*)data
{
    //使用NSXMLParser解析XML步骤和代理方法

}
#pragma mark - NSXMLParserDelegate
//当扫描到文档的开始时调用（开始解析）
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}
//当扫描到文档的结束时调用（解析完毕）
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}
//当扫描到元素的开始时调用（attributeDict存放着元素的属性）
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    
}
// 当扫描到元素的结束时调用
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}
@end
