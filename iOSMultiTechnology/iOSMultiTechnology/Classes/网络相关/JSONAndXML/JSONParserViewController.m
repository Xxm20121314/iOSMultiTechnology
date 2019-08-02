//
//  JSONParserViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "JSONParserViewController.h"
#import "NSURLConnectionManager.h"
@interface JSONParserViewController ()

@end

@implementation JSONParserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *address = @"http://v.juhe.cn/toutiao/index";
    /**
     type top(头条，默认),shehui(社会),guonei(国内),guoji(国际),yule(娱乐),tiyu(体育)junshi(军事),keji(科技),caijing(财经),shishang(时尚)
     */
    NSDictionary *params = @{@"type":@"top",
                             @"dtype":@"json",  //json
                             @"key":@"6f32779a067f86e9818845e403ce1f25"};
kWeakSelf
    NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
    [manage GET:address params:params dataBlock:^(NSData *resultData, NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            return ;
        }
        //JSON数据 -> OC对象
        [weakSelf JSONToOC:resultData];
    }];
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
    [self showTipStr:@"查看日志打印"];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}


@end
