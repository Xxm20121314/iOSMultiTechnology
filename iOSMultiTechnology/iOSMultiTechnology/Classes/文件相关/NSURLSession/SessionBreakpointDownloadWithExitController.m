//
//  SessionBreakpointDownloadWithExitController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/29.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "SessionBreakpointDownloadWithExitController.h"
#define KFileName @"NSURLSession_海贼王_05.mp4"
#import <MediaPlayer/MediaPlayer.h>

@interface SessionBreakpointDownloadWithExitController ()<NSURLSessionDataDelegate>

/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

/** 文件句柄 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

/** 文件总大小 */
@property (nonatomic, assign) NSInteger totalSize;

/** 当前下载大小 */
@property (nonatomic, assign) NSInteger currentSize;

/** 文件路径*/
@property (nonatomic,   copy) NSString *fullPath;

/** dataTask*/
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

/** session*/
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SessionBreakpointDownloadWithExitController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentSize = 0;
        self.totalSize = 0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1. 拿到当前文件的残留数据大小
    [self initViews];
    self.currentSize = [self getFileSize];
    if (self.currentSize) {
        self.totalSize =  [[NSUserDefaults standardUserDefaults] integerForKey:NSStringFromClass([self class])];
        self.progressView.progress = 1.0 * self.currentSize / self.totalSize;
    }
}
- (void)start
{
    [self.dataTask resume];
}
- (void)suspend
{
    [self.dataTask suspend];
}
- (void)cancel
{
    //注意:dataTask的取消是不可以恢复的
    [self.dataTask cancel];
    self.dataTask = nil;
}
- (void)goOn
{
    [self.dataTask resume];
}
- (void)play
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
    //expectedContentLength 本次请求的数据大小
    self.totalSize = response.expectedContentLength + self.currentSize;
    if (self.currentSize == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:self.totalSize forKey:NSStringFromClass([self class])];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //没有下载过 创建空文件
        [[NSFileManager defaultManager] createFileAtPath:self.fullPath contents:nil attributes:nil];
    }
    //创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
    //移动指针
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
    //写入数据到文件
    [self.fileHandle writeData:data];
    //计算文件下载进度
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
    NSLog(@"%@",self.fullPath);
    //关闭文件句柄
    [self.fileHandle closeFile];
    self.fileHandle = nil;
        [self.session finishTasksAndInvalidate];
    //NSURLSession对象的释放
    //在最后的时候应该把session释放，以免造成内存泄露
    //    NSURLSession设置过代理后，需要在最后（比如控制器销毁的时候）调用session的invalidateAndCancel或者resetWithCompletionHandler，才不会有内存泄露
    //    [self.session invalidateAndCancel];
}
#pragma mark - getters
- (NSURLSession *)session
{
    if (!_session) {
        //1.创建NSURLSession,并设置代理
        /*
         第一个参数：session对象的全局配置设置，一般使用默认配置就可以
         第二个参数：谁成为session对象的代理
         第三个参数：代理方法在哪个队列中执行（在哪个线程中调用）,如果是主队列那么在主线程中执行，如果是非主队列，那么在子线程中执行
         */
        NSURLSessionConfiguration *configuration  = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
    }
    return _session;
}
- (NSURLSessionDataTask *)dataTask
{
    if (!_dataTask) {
        //1.确定URL
        NSURL *url = [NSURL URLWithString:@"https://vd3.bdstatic.com/mda-jdppj9r4xxg48i02/sc/mda-jdppj9r4xxg48i02.mp4?auth_key=1564583903-0-0-da90758991ae6f190b03e4de60e148fc&bcevod_channel=searchbox_feed&pd=bjh&abtest=alln"];
        //2.创建可变请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //3.设置请求头信息,告诉服务器请求那一部分数据
        NSString *rangeStr = [NSString stringWithFormat:@"bytes=%zd-",self.currentSize];
        [request setValue:rangeStr forHTTPHeaderField:@"Range"];
        _dataTask = [self.session dataTaskWithRequest:request];
    }
    return _dataTask;
}
//获取已经下载的文件大小
-(NSInteger)getFileSize
{
    //获得指定文件路径对应文件的数据大小
    NSDictionary *fileInfoDict = [[FileManager sharedManager] fileAttriutesAtPath:self.fullPath];
    NSLog(@"fileInfoDict:%@",fileInfoDict);
    NSInteger currentSize = [fileInfoDict[@"NSFileSize"] integerValue];
    return currentSize;
}
- (NSString *)fullPath
{
    if (!_fullPath) {
        _fullPath = [kCachesDownloadPath stringByAppendingPathComponent:KFileName];
    }
    return _fullPath;
}
#pragma mark initViews
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"开始下载" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downloadBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn2 setTitle:@"暂停下载" forState:UIControlStateNormal];
    [downloadBtn2 sizeToFit];
    [downloadBtn2 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn2 addTarget:self action:@selector(suspend) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downloadBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn3 setTitle:@"取消下载" forState:UIControlStateNormal];
    [downloadBtn3 sizeToFit];
    [downloadBtn3 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn3 addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downloadBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn4 setTitle:@"恢复下载" forState:UIControlStateNormal];
    [downloadBtn4 sizeToFit];
    [downloadBtn4 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn4 addTarget:self action:@selector(goOn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn sizeToFit];
    [playBtn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn1.top = 10;
    downloadBtn1.centerX = self.view.centerX;
    
    downloadBtn2.top = 60;
    downloadBtn2.centerX = self.view.centerX;
    
    downloadBtn3.top = 110;
    downloadBtn3.centerX = self.view.centerX;
    
    downloadBtn4.top = 160;
    downloadBtn4.centerX = self.view.centerX;
    
    playBtn.top = 210;
    playBtn.centerX = self.view.centerX;
    
    [self.view addSubview:downloadBtn1];
    [self.view addSubview:downloadBtn2];
    [self.view addSubview:downloadBtn3];
    [self.view addSubview:downloadBtn4];
    [self.view addSubview:playBtn];
    
    UIProgressView *progressV = [[UIProgressView alloc] init];
    progressV.top = 260;
    progressV.width = 200;
    progressV.centerX = self.view.centerX;
    self.progressView = progressV;
    [self.view addSubview:self.progressView];
    
}

@end
