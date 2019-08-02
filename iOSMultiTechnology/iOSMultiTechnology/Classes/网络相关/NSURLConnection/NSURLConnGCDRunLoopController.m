//
//  NSURLConnGCDRunLoopController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/1.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLConnGCDRunLoopController.h"

@interface NSURLConnGCDRunLoopController ()<NSURLConnectionDataDelegate>

@end

@implementation NSURLConnGCDRunLoopController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTipStr:@"点击屏幕"];
}
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self delegate2];
}
- (void)delegate1
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSString *address = kAPIURL_weChat_choice_list;
        NSDictionary *params = @{@"pno":@(1), //当前页数，默认1
                                 @"ps" :@(5),//每页返回条数，最大50，默认20
                                 @"dtype":@"json",  //返回数据的格式,xml或json，默认json
                                 @"key":@"d51792ae54cb6fa161747ed7a08b781a"};
        
        NSString *finallyString = [NSString stringWithFormat:@"%@?%@",address,[NSString paramsStringWithParams:params]];
        NSURL *url = [NSURL URLWithString:finallyString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        /*
         设置代理
         代理方法：默认是在主线程中调用的
         该方法内部其实会将connect对象作为一个source添加到当前的runloop中，指定运行模式为默认
         */
        NSURLConnection * connect = [NSURLConnection connectionWithRequest:request delegate:self];
         // 设置代理方法在哪个线程中调用
        [connect setDelegateQueue:[[NSOperationQueue alloc] init]];
        // 子线程默认是 没有开启runloop，需要手动开启子线程runloop对象，才会调用代理方法
        [[NSRunLoop currentRunLoop] run];
        /**
          如果runloop的运行模式不正确的话，代理方法也是不会调用的
         */
//        [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode beforeDate:[NSDate distantFuture]];

        NSLog(@"currentThread:%@",[NSThread currentThread]);
    });
}
- (void)delegate2
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSString *address = kAPIURL_weChat_choice_list;
        NSDictionary *params = @{@"pno":@(1), //当前页数，默认1
                                 @"ps" :@(5),//每页返回条数，最大50，默认20
                                 @"dtype":@"json",  //返回数据的格式,xml或json，默认json
                                 @"key":@"d51792ae54cb6fa161747ed7a08b781a"};
        
        NSString *finallyString = [NSString stringWithFormat:@"%@?%@",address,[NSString paramsStringWithParams:params]];
        NSURL *url = [NSURL URLWithString:finallyString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        /*
         设置代理
         代理方法：默认是在主线程中调用的
         */
        NSURLConnection * connect = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        // 设置代理方法在哪个线程中调用
        [connect setDelegateQueue:[[NSOperationQueue alloc] init]];
        /**
         开始发送请求
         如果connect对象没有添加到runloop中，那么该方法内部会自动的添加到runnloop
         注意：如果当前的runloope没有开启，那么该方法内部会自动获得当期线程对应的runloop对象并且开启
         */
        [connect start];
        
        NSLog(@"currentThread:%@",[NSThread currentThread]);
    });
}
#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse：%@",[NSThread currentThread]);
}

@end
