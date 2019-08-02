//
//  NSURLConnGetDelegateController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/1.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLConnGetDelegateController.h"

@interface NSURLConnGetDelegateController ()<NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableData *resultData;
@end

@implementation NSURLConnGetDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTipStr:@"点击屏幕"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self getDelegate];
}
- (void)getDelegate
{
    NSString *address = kAPIURL_weChat_choice_list;
    NSDictionary *params = @{@"pno":@(1), //当前页数，默认1
                             @"ps" :@(5),//每页返回条数，最大50，默认20
                             @"dtype":@"json",  //返回数据的格式,xml或json，默认json
                             @"key":@"d51792ae54cb6fa161747ed7a08b781a"};
    
    NSString *finallyString = [NSString stringWithFormat:@"%@?%@",address,[NSString paramsStringWithParams:params]];
    
    // 1.确定请求路径
    NSURL *url = [NSURL URLWithString:finallyString];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /**
       3.设置代理,发送请求 (默认在主线程中调用的)
        1）使用类方法初始化
        NSURLConnection * connect = [NSURLConnection connectionWithRequest:request delegate:self];
        2) 使用对象方法初始化
        NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        3) 使用该方法设置代理,时候发送请求需要检查startImmediately的值
        (startImmediately == YES 会立刻发送 | startImmediately == NO 则需要调用start方法)
        NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
    */
    NSLog(@"GET Delegate请求: %@",finallyString);
    NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
    [connect start];
     /**
      4. 设置代理方法在哪个线程中调用，非主队列开主线程
        [[NSOperationQueue alloc] init] 开子线程
      */
    [connect setDelegateQueue:[[NSOperationQueue alloc] init]];
    // 5.取消请求 （取消操作）
    //    [connect cancel];
}
#pragma mark - NSURLConnectionDataDelegate
//1.当接收到服务器响应的时候调用
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"statusCode:%zd",res.statusCode);
}
//2.接收到服务器返回数据的时候调用,调用多次
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSLog(@"%s",__func__);
    //拼接数据
    [self.resultData appendData:data];
}
//3.当请求失败的时候调用
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
}
//4.请求结束的时候调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"currentThread: %@",[NSThread currentThread]);

    NSString* obj = [[NSString alloc]initWithData:self.resultData encoding:NSUTF8StringEncoding];
    
    kWeakSelf
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf alert:obj];
        });
    }else{
        [weakSelf alert:obj];
    }
}
- (void)alert:(NSString*)msg
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:self.navigationItem.title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - Getters
-(NSMutableData *)resultData
{
    if (_resultData == nil) {
        _resultData = [NSMutableData data];
    }
    return _resultData;
}

@end
