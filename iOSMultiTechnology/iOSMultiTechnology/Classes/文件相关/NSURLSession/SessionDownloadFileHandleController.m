//
//  SessionDownloadFileHandleController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/29.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "SessionDownloadFileHandleController.h"
#define KFileName @"NSURLSession_海贼王_04_01.mp4"
#import <MediaPlayer/MediaPlayer.h>
@interface SessionDownloadFileHandleController ()<NSURLSessionDataDelegate>
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

/** 文件句柄 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

/** 文件总大小 */
@property (nonatomic, assign) NSInteger totalSize;

/** 当前下载大小 */
@property (nonatomic, assign) NSInteger currentSize;

/** 保存路径*/
@property (nonatomic,   copy) NSString *fullPath;

@end

@implementation SessionDownloadFileHandleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
- (void)download
{
    //1.确认URL
    NSURL *url = [NSURL URLWithString:@"https://vd1.bdstatic.com/mda-hi0iw3hrar1d7hep/sc/mda-hi0iw3hrar1d7hep.mp4?auth_key=1567065511-0-0-b61e97133038dd04abeb57f12abbe347&bcevod_channel=searchbox_feed&pd=bjh&abtest=all"];
    //2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //3.创建会话对象,设置代理
    /*
     第一个参数:session对象的全局配置设置，一般使用默认配置就可以
     第二个参数:谁成为session对象的代理
     第三个参数:代理方法在哪个队列中执行（在哪个线程中调用）,如果是主队列那么在主线程中执行，如果是非主队列，那么在子线程中执行
     */
    NSURLSessionConfiguration *configuration  = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
    //4.创建task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    //5.执行Task
    [dataTask resume];
}
- (void)playBtnClick
{
    // 1.创建播放url
    NSURL *url = [[NSURL alloc] initFileURLWithPath:self.fullPath];
    //2.创建播放控制器
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    //3.弹出控制器
    [self presentViewController:vc animated:YES completion:nil];
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
    //文件总大小
    self.totalSize = response.expectedContentLength;
    //创建空的文件
    [[NSFileManager defaultManager] createFileAtPath:self.fullPath contents:nil attributes:nil];
    //创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
    [self.fileHandle seekToEndOfFile];
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
    //写入数据
    [self.fileHandle writeData:data];
    //计算下载进度
    self.currentSize += data.length;
    NSLog(@"%f",1.0 * self.currentSize / self.totalSize);
    self.progressView.progress = 1.0 * self.currentSize / self.totalSize;
}
/**
 *  请求结束或者是失败的时候调用
 *
 *  @param session           会话对象
 *  @param task          请求任务
 *  @param error             错误信息
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"下载完成：%@",self.fullPath);
    //关闭文件句柄
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
}
#pragma mark - getters
- (NSString *)fullPath
{
    if (!_fullPath) {
        _fullPath = [kCachesDownloadPath stringByAppendingPathComponent:KFileName];
    }
    return _fullPath;
}

#pragma mark - initViews
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"下载(DataTask)" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setTitle:@"播放海贼王" forState:UIControlStateNormal];
    [playBtn sizeToFit];
    [playBtn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn1.top = 10;
    downloadBtn1.centerX = self.view.centerX;
    
    playBtn.top = 60;
    playBtn.centerX = self.view.centerX;
    
    [self.view addSubview:downloadBtn1];
    [self.view addSubview:playBtn];
    
    UIProgressView *progressV = [[UIProgressView alloc] init];
    progressV.top = 110;
    progressV.width = 200;
    progressV.centerX = self.view.centerX;
    self.progressView = progressV;
    [self.view addSubview:self.progressView];
    
}
@end
