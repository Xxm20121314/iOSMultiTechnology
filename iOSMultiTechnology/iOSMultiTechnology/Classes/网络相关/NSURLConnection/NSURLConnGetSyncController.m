//
//  NSURLConnGetSyncController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/1.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLConnGetSyncController.h"

@interface NSURLConnGetSyncController ()

@end

@implementation NSURLConnGetSyncController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTipStr:@"点击屏幕"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self getSync];
}
- (void)getSync
{
    NSString *address = kAPIURL_weChat_choice_list;
    NSDictionary *params = @{@"pno":@(1), //当前页数，默认1
                             @"ps" :@(5),//每页返回条数，最大50，默认20
                             @"dtype":@"json",  //返回数据的格式,xml或json，默认json
                             @"key":@"d51792ae54cb6fa161747ed7a08b781a"};
    
    NSString *finallyString = [NSString stringWithFormat:@"%@?%@",address,[NSString paramsStringWithParams:params]];
    
    //  1.确定请求路径
    NSURL *url = [NSURL URLWithString:finallyString];
    
    /*
        2.创建请求对象
        请求头不需要设置(默认的请求头)
        请求方法--->默认为GET
    */
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    /*
        3.发送请求

        第一个参数:请求对象
        第二个参数:响应头信息 真实类型:NSHTTPURLResponse
        第三个参数:错误信息
        返回值:响应体
     
        注意：该方法是阻塞的,即如果该方法没有执行完则后面的代码将得不到执行
            如果一次返回的data很大，会占用很大的内存空间
     */
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSLog(@"GET同步请求: %@",finallyString);

    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"statusCode:%zd",response.statusCode);
    //  4.解析 NSData->NSString  NSUTF8StringEncoding
    NSString *obj = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:self.navigationItem.title message:obj preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
