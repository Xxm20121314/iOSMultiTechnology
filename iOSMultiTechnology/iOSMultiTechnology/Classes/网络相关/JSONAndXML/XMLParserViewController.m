//
//  XMLParserViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "XMLParserViewController.h"
#import "NSURLConnectionManager.h"

@interface XMLParserViewController ()<NSXMLParserDelegate>

@end

@implementation XMLParserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *address = @"http://apis.juhe.cn/cook/category";
    NSDictionary *params = @{@"parentid":@(10001), //分类ID,默认全部
                             @"dtype":@"xml",  //xml
                             @"key":@"bc2ee87d058a09f523e817ad1eb300e5"};
    kWeakSelf
    NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
    [manage GET:address params:params data:^(NSData *resultData, NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            return ;
        }
        //XML数据 -> OC对象
        [weakSelf xmlParser:resultData];
    }];
}
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
