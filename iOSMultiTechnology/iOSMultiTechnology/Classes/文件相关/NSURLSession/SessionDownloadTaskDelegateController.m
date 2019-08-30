//
//  SessionDownloadTaskDelegateController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/28.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "SessionDownloadTaskDelegateController.h"
#define KFileName @"NSURLSession_海贼王_02.mp4"
#import <MediaPlayer/MediaPlayer.h>

@interface SessionDownloadTaskDelegateController ()<NSURLSessionDownloadDelegate>
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

/** 沙盒路径 */
@property (nonatomic, strong) NSString *fullPath;
@end

@implementation SessionDownloadTaskDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
- (void)download
{
    //1.创建url
    NSURL *url = [NSURL URLWithString:@"https://vd3.bdstatic.com/mda-jdppj9r4xxg48i02/sc/mda-jdppj9r4xxg48i02.mp4?auth_key=1564583903-0-0-da90758991ae6f190b03e4de60e148fc&bcevod_channel=searchbox_feed&pd=bjh&abtest=alln"];
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
    //4. 创建下载任务
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
    //5.执行下载任务
    [downloadTask resume];
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
#pragma mark - NSURLSessionDownloadDelegate
/**
 *  写数据
 *
 *  @param session                   会话对象
 *  @param downloadTask              下载任务
 *  @param bytesWritten              本次写入的数据大小
 *  @param totalBytesWritten         下载的数据总大小
 *  @param totalBytesExpectedToWrite  文件的总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // 文件的下载进度
    NSLog(@"%f",1.0 * totalBytesWritten/totalBytesExpectedToWrite);
    self.progressView.progress = 1.0 * totalBytesWritten/totalBytesExpectedToWrite;
}
/**
 *  当恢复下载的时候调用该方法
 *
 *  @param fileOffset         从什么地方下载
 *  @param expectedTotalBytes 文件的总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"fileOffset:%@",@(fileOffset));
}
/**
 *  当下载完成的时候调用
 *
 *  @param location     文件的临时存储路径
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"%@",location);
    //1.将临时文件移动到保存路径
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:self.fullPath] error:nil];
}
/**
 *  请求结束
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"下载完成：%s",__func__);
    NSLog(@"path:%@",self.fullPath);
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
    [downloadBtn1 setTitle:@"下载" forState:UIControlStateNormal];
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
