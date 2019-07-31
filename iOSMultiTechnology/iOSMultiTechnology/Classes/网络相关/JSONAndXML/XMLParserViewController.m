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
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation XMLParserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *address = @"http://v.juhe.cn/postcode/query";

    NSDictionary *params = @{@"postcode":@"363102",
                             @"dtype":@"xml",  //xml
                             @"key":@"8c779318943a236498e999cef88e99c2"};
    kWeakSelf
    NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
    [manage GET:address params:params dataBlock:^(NSData *resultData, NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            return ;
        }
        id xmlData = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
        NSLog(@"xmlData:\n %@",xmlData);
        //XML数据 -> OC对象
        [weakSelf xmlParser:resultData];
    }];
}
- (void)xmlParser:(NSData*)data
{
    //使用NSXMLParser解析XML步骤和代理方法
    //1. 创建XML解析器:SAX
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    //2. 设置代理
    parser.delegate = self;
    //3 开始解析, 阻塞
    NSLog(@"阻塞开始");
    [parser parse];
    NSLog(@"阻塞结束");
}
#pragma mark - NSXMLParserDelegate
//当扫描到文档的开始时调用（开始解析）
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"%s",__func__);
}
//当扫描到文档的结束时调用（解析完毕）
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"%s",__func__);
}
//当扫描到元素的开始时调用（attributeDict存放着元素的属性）
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    NSLog(@"开始解析:%@==%@",elementName,attributeDict);
    [attributeDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@==%@",key,obj);
    }];

    // 过滤根元素
    if ([elementName isEqualToString:@"root"]) {
        return;
    }
    
}
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"parseError:%@parseError",parseError);
}
// 当扫描到元素的结束时调用
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"结束解析%@",elementName);
}
#pragma mark Getters
- (NSMutableArray *)list
{
    if (!_list) {
        _list = [NSMutableArray new];
    }
    return _list;
}
@end
