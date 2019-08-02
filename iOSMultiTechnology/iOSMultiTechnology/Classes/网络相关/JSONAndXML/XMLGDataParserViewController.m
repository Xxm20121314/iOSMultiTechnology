//
//  XMLGDataParserViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/1.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "XMLGDataParserViewController.h"
#import "GDataXMLNode.h"

#import "MJNewsDataModel.h"

@interface XMLGDataParserViewController ()

@end

@implementation XMLGDataParserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTipStr:@"点击屏幕"];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self GDDataParser];
}
- (void)GDDataParser
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
    kWeakSelf
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            return ;
        }
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        NSLog(@"statusCode:%zd",res.statusCode);
        NSLog(@"currentThread：%@",[NSThread currentThread]);
        // 解析数据
        // 加载XML文档
        GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithData:data options:kNilOptions error:nil];
        //拿到根元素,得到根元素内部所有名称为video的子孙元素,
        NSLog(@"rootElement：%@",doc.rootElement);
        GDataXMLElement *resultElement = [[doc.rootElement elementsForName:@"result"] firstObject];
        GDataXMLElement *newsElement = [[resultElement elementsForName:@"data"] firstObject];
        NSArray *itemLists = [newsElement elementsForName:@"item"];


        //遍历操作
        NSMutableArray *dataArray = [NSMutableArray new];
        for (GDataXMLElement *ele in itemLists) {

            MJNewsSubDataModel *model = [[MJNewsSubDataModel alloc] init];
            model.author_name = [[[ele elementsForName:@"author_name"] firstObject] stringValue];
            model.uniquekey = [[ele elementsForName:@"uniquekey"].firstObject stringValue];
            model.title = [[ele elementsForName:@"title"].firstObject stringValue];
            model.date = [[ele elementsForName:@"date"].firstObject stringValue];
            model.category = [[ele elementsForName:@"category"].firstObject stringValue];
            model.url = [[ele elementsForName:@"url"].firstObject stringValue];
            model.thumbnail_pic_s = [[ele elementsForName:@"thumbnail_pic_s"].firstObject stringValue];
            model.thumbnail_pic_s02 = [[ele elementsForName:@"thumbnail_pic_s02"].firstObject stringValue];
            model.thumbnail_pic_s03 = [[ele elementsForName:@"thumbnail_pic_s03"].firstObject stringValue];
            [dataArray addObject:model];
        }
        NSLog(@"dataArray：%@",dataArray);
        [weakSelf showTipStr:dataArray.description];
    }];
    NSLog(@"不阻塞");
}

@end
