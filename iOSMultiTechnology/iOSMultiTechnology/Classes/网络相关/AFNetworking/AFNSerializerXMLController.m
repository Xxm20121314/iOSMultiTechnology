//
//  AFNSerializerXMLController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "AFNSerializerXMLController.h"

@interface AFNSerializerXMLController ()<NSXMLParserDelegate>

@end

@implementation AFNSerializerXMLController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
- (void)get
{
    NSString *address = kAPIURL_goodbook_catalog_list;
    NSDictionary *params = @{
                             @"dtype":@"xml",
                             @"key":@"b594cca8465efb688a8e773ab28bc008"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**注意:
    AFHTTPSessionManager默认是JSON解析
     如果返回的是xml数据,那么应该修改AFN的解析方案AFXMLParserResponseSerializer
     */
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [manager GET:address parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        //1 XML解析器
        NSXMLParser *parser = (NSXMLParser*)responseObject;
        //2 设置代理
        parser.delegate = self;
        //3 开始解析
        [parser parse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
#pragma mark NSXMLParserDelegate
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    NSLog(@"%@--%@",elementName,attributeDict);
}
#pragma mark initViews
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"请求" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(get) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn1.top = 50;
    downloadBtn1.centerX = self.view.centerX;
    
    [self.view addSubview:downloadBtn1];
}


@end
