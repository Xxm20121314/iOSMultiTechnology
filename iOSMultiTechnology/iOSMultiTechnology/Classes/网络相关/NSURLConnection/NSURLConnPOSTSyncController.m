//
//  NSURLConnPOSTSyncController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/1.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLConnPOSTSyncController.h"

@interface NSURLConnPOSTSyncController ()

@end

@implementation NSURLConnPOSTSyncController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTipStr:@"点击屏幕"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self postSync];
}
- (void)postSync
{
    NSString *address = kAPIURL_weChat_choice_list;
    NSDictionary *params = @{@"pno":@(1), //当前页数，默认1
                             @"ps" :@(5),//每页返回条数，最大50，默认20
                             @"dtype":@"json",  //返回数据的格式,xml或json，默认json
                             @"key":@"d51792ae54cb6fa161747ed7a08b781a"};
    
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:address];
    //2.创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //3.修改请求方法,POST必须大写
    request.HTTPMethod = @"POST";
    // 可以请求超时时间
    request.timeoutInterval = 10;
    /**
     可以设置请求头 User-Agent
     注意:key一定要一致(用于传递数据给后台)
     eg: ios 12.2
     */
    NSString *veriosn = [NSString stringWithFormat:@"iOS %@",@(IOS_VERSION)];
    [request setValue:veriosn forHTTPHeaderField:@"User-Agent"];
    
    //4.设置请求体信息,NSString->NSData
    NSData *bodyData = [[NSString paramsStringWithParams:params] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = bodyData;
    /*
     5.发送请求
     
     第一个参数:请求对象
     第二个参数:响应头信息 真实类型:NSHTTPURLResponse
     第三个参数:错误信息
     返回值:响应体
     
     注意：该方法是阻塞的,即如果该方法没有执行完则后面的代码将得不到执行
     如果一次返回的data很大，会占用很大的内存空间
     */
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSLog(@"POST 同步请求: %@",address);
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"statusCode:%zd",response.statusCode);
    
    //  4.解析 NSData->NSString  NSUTF8StringEncoding
    NSString* obj = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:self.navigationItem.title message:obj preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
