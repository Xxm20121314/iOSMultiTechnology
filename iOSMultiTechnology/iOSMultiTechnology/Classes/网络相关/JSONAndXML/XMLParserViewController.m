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
    [self showTipStr:@"点击屏幕"];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self NSXMLParser];
}
- (void)NSXMLParser
{
    NSString *address = kAPIURL_news_toutiao_list;
    NSDictionary *params = @{@"type":@"top",
                             @"dtype":@"xml",
                             @"key":@"6f32779a067f86e9818845e403ce1f25"};
    
    NSString *finallyString = [NSString stringWithFormat:@"%@?%@",address,[NSString paramsStringWithParams:params]];
    
    NSURL *url = [NSURL URLWithString:finallyString];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSLog(@"请求: %@",finallyString);
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            return ;
        }
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        NSString *obj = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"obj:%@",obj);

        NSLog(@"statusCode:%zd",res.statusCode);
        NSLog(@"currentThread：%@",[NSThread currentThread]);
        //1 创建XML解析器:SAX
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
        //2 设置代理
        parser.delegate = self;
        //3 开始解析,阻塞
        [parser parse];
    }];
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
    //只是这样做对于item元素
    NSLog(@"elementName:%@==attributeDict:%zd",elementName,attributeDict.allKeys.count);
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
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
