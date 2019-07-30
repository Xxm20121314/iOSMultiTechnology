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
@property (nonatomic,   copy) NSString *GETURLstring;
@property (nonatomic,   copy) NSString *POSTURLstring;
@property (nonatomic,   copy) NSDictionary *POSTParams;

@property (nonatomic,  copy) CompleteBlock complete;
@property (nonatomic,  copy) DataBlock dataBlock;

@end
@implementation NSURLConnectionManager
#pragma mark - GET方法
- (void)GET:(RNSURLConnectionRequestType)type url:(NSString *)url params:(NSDictionary *)params complete:(void (^)(id, NSError *))complete
{
    /*
     请求:请求头(NSURLRequest默认包含)+请求体(GET没有)
     响应:响应头(真实类型--->NSHTTPURLResponse)+响应体(要解析的数据)
     协议+主机地址+接口名称+?+参数1&参数2&参数3
     */
    self.GETURLstring = [NSString stringWithFormat:@"%@?%@",url,[NSString paramsStringWithParams:params]];
    self.complete = complete;
    if (type & NSURLConnectionTypRequestSync) {
        // 方法1 同步
         [self _getSync];
        return;
    }
    if (type & NSURLConnectionTypeRequestAsync) {
        // 方法2 异步
         [self _getAsync];
        return;
    }
    if (type & NSURLConnectionTypeRequestDelegate) {
        // 方法3 代理
        [self _getDelegate];
        return;
    }
}

#pragma mark -  GET 同步方式
-(void)_getSync
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
    NSLog(@"GET 同步开始阻塞");
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"GET 同步结束阻塞");
    //4.解析 data--->字符串
    //NSUTF8StringEncoding
    id obj = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"statusCode:%zd",response.statusCode);
    if (self.complete) {
        self.complete(obj, error);
    }
    
}

#pragma mark - GET 异步方式
-(void)_getAsync
{
    NSLog(@"GET异步请求地址: %@",self.GETURLstring);
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:self.GETURLstring];
    //2.创建请求对象
    //请求头不需要设置(默认的请求头)
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    // 主队列
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    //    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //3.发送异步请求
    /*
     第一个参数:请求对象
     第二个参数:队列 决定代码块completionHandler的调用线程
     第三个参数:completionHandler 当请求完成(成功|失败)的时候回调
     response:响应头
     data:响应体
     connectionError:错误信息
     */
    NSLog(@"GET 异步开始1");
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"GET 异步结束");
        //4.解析数据
        id obj = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        NSLog(@"statusCode:%zd",res.statusCode);
        NSLog(@"GET 线程：%@",[NSThread currentThread]);
        kWeakSelf
        if (![[NSThread currentThread] isMainThread]) {
            NSLog(@"GET 不是主线程");
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.complete(obj, connectionError);
            });
        }else{
            NSLog(@"GET是主线程");
            weakSelf.complete(obj, connectionError);
        }
     }];
    NSLog(@"GET 异步开始2");
}


#pragma mark -  GET 代理方式
- (void)_getDelegate
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
    if (self.complete) {
        self.complete(nil, error);
    }
}
//4.请求结束的时候调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s",__func__);
    id obj = [[NSString alloc]initWithData:self.resultData encoding:NSUTF8StringEncoding];
    if (self.complete) {
        self.complete(obj, nil);
    }
    if (self.dataBlock) {
        self.dataBlock(self.resultData, nil);
    }
}
#pragma mark - POST方法
- (void)POST:(RNSURLConnectionRequestType)type url:(NSString *)url params:(NSDictionary *)params complete:(CompleteBlock)complete
{
    /*
     请求:请求头(NSURLRequest默认包含)+请求体
     响应:响应头(真实类型--->NSHTTPURLResponse)+响应体(要解析的数据)
     协议+主机地址+接口名称
     */
    self.POSTURLstring = url;
    self.POSTParams = params;
    self.complete = complete;

    if (type & NSURLConnectionTypRequestSync) {
        // 方法1 同步
        [self _postSync];
        return;
    }
    if (type & NSURLConnectionTypeRequestAsync) {
        // 方法2 异步
        [self _postAsync];
        return;
    }
    if (type & NSURLConnectionTypeRequestDelegate) {
        // 方法3 代理
        [self _postDelegate];
        return;
    }
}
 
#pragma mark -  POST 同步方式
- (void)_postSync
{
    NSLog(@"POST 同步请求地址: %@",self.POSTURLstring);
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:self.POSTURLstring];
    //2.创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //3.修改请求方法,POST必须大写
    request.HTTPMethod = @"POST";
    //设置属性,请求超时
    request.timeoutInterval = 10;
    //设置请求头User-Agent
    //注意:key一定要一致(用于传递数据给后台)
    // ios 12.2
    NSString *veriosn = [NSString stringWithFormat:@"iOS %@",@(IOS_VERSION)];
    [request setValue:veriosn forHTTPHeaderField:@"User-Agent"];

    //4.设置请求体信息,字符串--->NSData
    NSData *bodyData = [[NSString paramsStringWithParams:self.POSTParams] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = bodyData;
    //5.发送请求
    //真实类型:NSHTTPURLResponse
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSLog(@"POST 同步开始阻塞");
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"POST 同步结束阻塞");
    //4.解析 data--->字符串
    //NSUTF8StringEncoding
    id obj = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"statusCode:%zd",response.statusCode);
    if (self.complete) {
        self.complete(obj, error);
    }
}

#pragma mark -  post 异步方式
- (void)_postAsync
{
    NSLog(@"POST 异步请求地址: %@",self.POSTURLstring);
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:self.POSTURLstring];
    //2.创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //3.修改请求方法,POST必须大写
    request.HTTPMethod = @"POST";
    //设置属性,请求超时
    request.timeoutInterval = 10;
    //设置请求头User-Agent
    //注意:key一定要一致(用于传递数据给后台)
    // ios 12.2
    NSString *veriosn = [NSString stringWithFormat:@"iOS %@",@(IOS_VERSION)];
    [request setValue:veriosn forHTTPHeaderField:@"User-Agent"];
    //4.设置请求体信息,字符串--->NSData
    NSData *bodyData = [[NSString paramsStringWithParams:self.POSTParams] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = bodyData;
    // 主队列
//    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSLog(@"POST 异步开始1");
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"POST 异步结束");
        //4.解析数据
        id obj = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        NSLog(@"statusCode:%zd",res.statusCode);
        NSLog(@"POST 线程：%@",[NSThread currentThread]);
        kWeakSelf
        if (![[NSThread currentThread] isMainThread]) {
            NSLog(@"POST 不是主线程");
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.complete(obj, connectionError);
            });
        }else{
            NSLog(@"POST是主线程");
            weakSelf.complete(obj, connectionError);
        }
    }];
    NSLog(@"POST 异步开始2");
}

#pragma mark - POST 代理方式
- (void)_postDelegate
{
    NSLog(@"POST 代理请求地址: %@",self.POSTURLstring);
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:self.POSTURLstring];
    //2.创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //3.修改请求方法,POST必须大写
    request.HTTPMethod = @"POST";
    //设置属性,请求超时
    request.timeoutInterval = 10;
    //设置请求头User-Agent
    //注意:key一定要一致(用于传递数据给后台)
    // ios 12.2
    NSString *veriosn = [NSString stringWithFormat:@"iOS %@",@(IOS_VERSION)];
    [request setValue:veriosn forHTTPHeaderField:@"User-Agent"];
    //4.设置请求体信息,字符串--->NSData
    NSData *bodyData = [[NSString paramsStringWithParams:self.POSTParams] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = bodyData;
    //5.设置代理,发送请求
    //5.1
    //NSURLConnection * connect = [NSURLConnection connectionWithRequest:request delegate:self];
    //5.2
    //NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    //5.3 设置代理,时候发送请求需要检查startImmediately的值
    //(startImmediately == YES 会发送 | startImmediately == NO 则需要调用start方法)
    NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
    [connect start];
    //4.0 取消请求
    //    [connect cancel];
}
#pragma mark - 返回NSData 数据
- (void)GET:(NSString *)url params:(NSDictionary *)params data:(DataBlock)data
{
    self.GETURLstring = [NSString stringWithFormat:@"%@?%@",url,[NSString paramsStringWithParams:params]];
    self.dataBlock = data;
    // 方法3 代理
    [self _getDelegate];
}
#pragma mark - Setters 
#pragma mark 中文转码处理
- (void)setGETURLstring:(NSString *)GETURLstring
{
    _GETURLstring = [GETURLstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
