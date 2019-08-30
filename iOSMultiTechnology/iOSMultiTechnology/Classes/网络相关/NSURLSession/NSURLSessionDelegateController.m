//
//  NSURLSessionDelegateController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/28.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLSessionDelegateController.h"

@interface NSURLSessionDelegateController ()<NSURLSessionDataDelegate>
/** 可变data*/
@property (nonatomic, strong) NSMutableData *fileData;
@end

@implementation NSURLSessionDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
- (void)get
{
    //1.确定URL
    NSURL *url = [NSURL URLWithString:[self getAddressUrl]];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.创建会话对象,设置代理
    /*
     第一个参数:session对象的全局配置设置，一般使用默认配置就可以
     第二个参数:谁成为session对象的代理
     第三个参数:代理方法在哪个队列中执行（在哪个线程中调用）,如果是主队列那么在主线程中执行，如果是非主队列，那么在子线程中执行
     */
    NSURLSessionConfiguration *configuration  = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
    
    //4.创建Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    //5.执行Task
    [dataTask resume];
}
#pragma mark - NSURLSessionDataDelegate
/**
 *  1.接收到服务器的响应 它默认会取消该请求
 *
 *  @param session           发送请求的session对象
 *  @param dataTask          根据NSURLSession创建的task任务
 *  @param response          服务器响应信息（响应头）
 *  @param completionHandler 通过该block回调，告诉服务器端是否接收返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //默认情况下，当接收到服务器响应之后，服务器认为客户端不需要接收数据，所以后面的代理方法不会调用
    //如果需要继续接收服务器返回的数据，那么需要调用block,并传入对应的策略
    /*
     NSURLSessionResponseCancel = 0,  取消 默认 //Cancel the load, this is the same as -[task cancel]
    NSURLSessionResponseAllow = 1,     允许 接收 //Allow the load to continue
    NSURLSessionResponseBecomeDownload = 2,  变成下载任务 // Turn this request into a download
    NSURLSessionResponseBecomeStream// 变成流 API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0)) = 3,   Turn this task into a stream task
     */
    completionHandler(NSURLSessionResponseAllow);
}
/**
 *  接收到服务器返回的数据 调用多次
 *
 *  @param session           会话对象
 *  @param dataTask          请求任务
 *  @param data              本次下载的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    //追加数据
    [self.fileData appendData:data];
}
/**
 *  请求结束或者是失败的时候调用
 *
 *  @param session           会话对象
 *  @param task          请求任务
 *  @param error             错误信息
 */
- (void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    NSLog(@"currentThread：%@",[NSThread currentThread]);
    if (error) {
        NSLog(@"error:%@",error);
        return ;
    }
    // 4.解析数据
    NSString *dataStr = [[NSString alloc] initWithData:self.fileData encoding:NSUTF8StringEncoding];
    kWeakSelf
//    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:weakSelf.navigationItem.title message:dataStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:action];
        [weakSelf presentViewController:alertVC animated:YES completion:nil];
//    });
}
#pragma mark initViews
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"Delegate" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(get) forControlEvents:UIControlEventTouchUpInside];
    
    
    downloadBtn1.top = 50;
    downloadBtn1.centerX = self.view.centerX;
 
    [self.view addSubview:downloadBtn1];
}
#pragma mark - getter
- (NSMutableData *)fileData
{
    if (!_fileData) {
        _fileData = [NSMutableData new];
    }
    return _fileData;
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

@end
