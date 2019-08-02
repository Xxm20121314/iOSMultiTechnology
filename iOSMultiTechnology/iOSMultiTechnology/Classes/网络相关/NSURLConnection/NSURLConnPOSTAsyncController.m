//
//  NSURLConnPOSTAsyncController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/1.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLConnPOSTAsyncController.h"

@interface NSURLConnPOSTAsyncController ()

@end

@implementation NSURLConnPOSTAsyncController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTipStr:@"点击屏幕"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self postAsync];
}
-(void)postAsync
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
    
    /**
     5. 发送异步请求
     第一个参数:请求对象
     第二个参数:队列 决定代码块 completionHandler的调用线程
     第三个参数:completionHandler 当请求完成(成功|失败)的时候回调
     response:响应头
     ata:响应体
     connectionError:错误信息
     */
    
    /**
     创建队列 决定是否开始子线程
     主线程：[NSOperationQueue mainQueue]
     子线程： [[NSOperationQueue alloc] init]
     */
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSLog(@"POST异步请求: %@",address);
    kWeakSelf
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        NSLog(@"statusCode:%zd",res.statusCode);
        NSLog(@"currentThread：%@",[NSThread currentThread]);
        
        //4.解析数据
        NSString * obj = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        if (![[NSThread currentThread] isMainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf alert:obj];
            });
        }else{
            [weakSelf alert:obj];
        }
    }];
    NSLog(@"不阻塞");
}
- (void)alert:(NSString*)msg
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:self.navigationItem.title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}


@end
