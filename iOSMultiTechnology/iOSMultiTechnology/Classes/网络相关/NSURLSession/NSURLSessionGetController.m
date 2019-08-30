//
//  NSURLSessionGetController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/26.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLSessionGetController.h"

@interface NSURLSessionGetController ()

@end

@implementation NSURLSessionGetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)get1
{
    //1.确定URL
    NSURL *url = [NSURL URLWithString:[self getAddressUrl]];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];

    /**4.创建Task
     注意：该block是在子线程中调用的，如果拿到数据之后要做一些UI刷新操作，那么需要回到主线程刷新
     第一个参数：需要发送的请求对象
     block:当请求结束拿到服务器响应的数据时调用block
     block-NSData:该请求的响应体
     block-NSURLResponse:存放本次请求的响应信息，响应头，真实类型为NSHTTPURLResponse
     block-NSErroe:请求错误信息
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"currentThread：%@",[NSThread currentThread]);
        if (error) {
            NSLog(@"error:%@",error);
            return ;
        }
        // 6.解析数据
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        kWeakSelf
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:weakSelf.navigationItem.title message:dataStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:action];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        });
    }];
    //5.执行Task
    //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
    [dataTask resume];
}
- (void)get2
{
    //1.确定URL
    NSURL *url = [NSURL URLWithString:[self getAddressUrl]];
    
    //2.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    /**3.创建Task
     注意：该方法内部默认会把URL对象包装成一个NSURLRequest对象（默认是GET请求）
     方法参数说明
     第一个参数：发送请求的URL地址
     block:当请求结束拿到服务器响应的数据时调用block
     block-NSData:该请求的响应体
     block-NSURLResponse:存放本次请求的响应信息，响应头，真实类型为NSHTTPURLResponse
     block-NSError:请求错误信息
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"currentThread：%@",[NSThread currentThread]);
        if (error) {
            NSLog(@"error:%@",error);
            return ;
        }
        // 5.解析数据
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        kWeakSelf
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:weakSelf.navigationItem.title message:dataStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:action];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        });
    }];
    //4.执行Task
    //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
    [dataTask resume];
    
}
- (NSString *)getAddressUrl{
    NSString *address = kAPIURL_weChat_choice_list;
    NSDictionary *params = @{@"pno":@(1), //当前页数，默认1
                             @"ps" :@(2),//每页返回条数，最大50，默认20
                             @"dtype":@"json",  //返回数据的格式,xml或json，默认json
                             @"key":@"d51792ae54cb6fa161747ed7a08b781a"};
    
    NSString *finallyString = [NSString stringWithFormat:@"%@?%@",address,[NSString paramsStringWithParams:params]];
    NSLog(@"请求路径:%@",finallyString);
    return finallyString;
}
#pragma mark initViews
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"1.Get(dataTaskWithRequest)" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(get1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downloadBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn2 setTitle:@"2.Get(dataTaskWithURL)" forState:UIControlStateNormal];
    [downloadBtn2 sizeToFit];
    [downloadBtn2 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn2 addTarget:self action:@selector(get2) forControlEvents:UIControlEventTouchUpInside];
    
   
    downloadBtn1.top = 50;
    downloadBtn1.centerX = self.view.centerX;
    
    downloadBtn2.top = 100;
    downloadBtn2.centerX = self.view.centerX;
    
    
    [self.view addSubview:downloadBtn1];
    [self.view addSubview:downloadBtn2];
}

@end
