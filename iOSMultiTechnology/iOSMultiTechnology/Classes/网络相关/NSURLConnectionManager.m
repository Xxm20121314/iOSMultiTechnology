//
//  NSURLConnectionManager.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLConnectionManager.h"
@interface NSURLConnectionManager()<NSURLConnectionDataDelegate>
/** 注释 */
@property (nonatomic, strong) NSMutableData *resultData;
@property (nonatomic,   copy)NSString *GETURLstring;
@property (nonatomic,  copy) CompleteBlock complete;
@end
@implementation NSURLConnectionManager
#pragma mark - GET方法
- (void)GET:(NSURLConnectionGetType)type url:(NSString *)url params:(NSDictionary *)params complete:(void (^)(id, NSError *))complete
{
    /*
     请求:请求头(NSURLRequest默认包含)+请求体(GET没有)
     响应:响应头(真实类型--->NSHTTPURLResponse)+响应体(要解析的数据)
     协议+主机地址+接口名称+?+参数1&参数2&参数3
     */
    self.GETURLstring = [NSString stringWithFormat:@"%@?%@",url,[NSString paramsStringWithParams:params]];
    self.complete = complete;
    if (type & NSURLConnectionTypeGetSync) {
        // 方法1 同步
         [self GETSync];
        return;
    }
    if (type & NSURLConnectionTypeGetAsync) {
        // 方法2 异步
         [self GETAsync];
        return;
    }
    if (type & NSURLConnectionTypeGetDelegate) {
        // 方法3 代理
        [self GETDelegate];
        return;
    }
}
-(void)GETSync
{
    NSLog(@"GET同步请求地址: %@",self.GETURLstring);
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:self.GETURLstring];
    //2.创建请求对象
    //请求头不需要设置(默认的请求头)
    //请求方法--->默认为GET
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    //3.发送请求
    //真实类型:NSHTTPURLResponse
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    /*
     第一个参数:请求对象
     第二个参数:响应头信息
     第三个参数:错误信息
     返回值:响应体
     */
    //该方法是阻塞的,即如果该方法没有执行完则后面的代码将得不到执行
    // 如果一次返回的data很大，会占用很大的内存空间
    NSLog(@"同步开始阻塞");
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"同步结束阻塞");
    //4.解析 data--->字符串
    //NSUTF8StringEncoding
    id obj = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"statusCode:%zd",response.statusCode);
    if (self.complete) {
        self.complete(obj, error);
    }
}
-(void)GETAsync
{
    NSLog(@"GET异步请求地址: %@",self.GETURLstring);
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:self.GETURLstring];
    //2.创建请求对象
    //请求头不需要设置(默认的请求头)
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    //3.发送异步请求
    /*
     第一个参数:请求对象
     第二个参数:队列 决定代码块completionHandler的调用线程
     第三个参数:completionHandler 当请求完成(成功|失败)的时候回调
     response:响应头
     data:响应体
     connectionError:错误信息
     */
    NSLog(@"异步开始1");
    // 主队里
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"异步结束");
        //4.解析数据
        id obj = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        NSLog(@"statusCode:%zd",res.statusCode);
        NSLog(@"线程：%@",[NSThread currentThread]);
        kWeakSelf
        if (![[NSThread currentThread] isMainThread]) {
            NSLog(@"不是主线程");
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.complete(obj, connectionError);
            });
        }else{
            NSLog(@"是主线程");
            weakSelf.complete(obj, connectionError);
        }
     }];
}
- (void)GETDelegate
{
    NSLog(@"GET代理请求地址: %@",self.GETURLstring);
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:self.GETURLstring];
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.设置代理,发送请求
    //3.1
    //NSURLConnection * connect = [NSURLConnection connectionWithRequest:request delegate:self];
    //3.2
    //NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    //3.3 设置代理,时候发送请求需要检查startImmediately的值
    //(startImmediately == YES 会发送 | startImmediately == NO 则需要调用start方法)
    NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
    [connect start];
    //4.0 取消请求
//    [connect cancel];
}
#pragma mark - NSURLConnectionDataDelegate
//1.当接收到服务器响应的时候调用
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s",__func__);
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"statusCode:%zd",res.statusCode);

}
//2.接收到服务器返回数据的时候调用,调用多次
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%s",__func__);
    //拼接数据
    [self.resultData appendData:data];
}
//3.当请求失败的时候调用
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
    self.complete(nil, error);
}
//4.请求结束的时候调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s",__func__);
    id obj = [[NSString alloc]initWithData:self.resultData encoding:NSUTF8StringEncoding];
    self.complete(obj, nil);
}
#pragma mark - POST方法
- (void)POST
{
    
}
#pragma 
-(NSMutableData *)resultData
{
    if (_resultData == nil) {
        _resultData = [NSMutableData data];
    }
    return _resultData;
}

@end
