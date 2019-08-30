//
//  SessionBreakpointDownloadController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/28.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "SessionBreakpointDownloadController.h"
#define KFileName @"NSURLSession_海贼王_03.mp4"
#import <MediaPlayer/MediaPlayer.h>
@interface SessionBreakpointDownloadController ()<NSURLSessionDownloadDelegate>
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

/** 恢复的数据*/
@property (nonatomic, strong) NSData *resumData;

/** NSURLSessionDownloadTask*/
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

/** NSURLSessionDownloadTask*/
@property (nonatomic, strong) NSURLSession *session;

/** 文件保存路径*/
@property (nonatomic, copy) NSString *fullPath;

@end

@implementation SessionBreakpointDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
-(void)start
{
    //1.创建url
    NSURL *url = [NSURL URLWithString:@"https://vd3.bdstatic.com/mda-jdppj9r4xxg48i02/sc/mda-jdppj9r4xxg48i02.mp4?auth_key=1564583903-0-0-da90758991ae6f190b03e4de60e148fc&bcevod_channel=searchbox_feed&pd=bjh&abtest=alln"];
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
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
    //4. 创建下载任务
    self.downloadTask = [self.session downloadTaskWithRequest:request];
    //5.执行下载任务
    [self.downloadTask resume];
}
//暂停是可以恢复
- (void)suspend
{
    [self.downloadTask suspend];
}
//cancel:取消是不能恢复
//cancelByProducingResumeData:是可以恢复
- (void)cancel
{
    //NSURLSessionDownloadTask 支持取消恢复 NSURLSessionDataTask不支持
    //如果任务，取消了那么以后就不能恢复了
    //[self.downloadTask cancel];
    
    //如果采取这种方式来取消任务，那么该方法会通过resumeData保存当前文件的下载信息
     //只要有了这份信息，以后就可以通过这些信息来恢复下载
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumData = resumeData;
    }];
}
- (void)goOn
{
    //继续下载
    //首先通过之前保存的resumeData信息，创建一个下载任务
    if (self.resumData) {
        self.downloadTask = [self.session downloadTaskWithResumeData:self.resumData];
    }
    [self.downloadTask resume];
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
#pragma mark - NSURLSessionTaskDelegate
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
    NSLog(@"恢复下载：%s",__func__);
    NSLog(@"fileOffset:%@",@(fileOffset));
    NSLog(@"expectedTotalBytes:%@",@(expectedTotalBytes));

}
/**
 *  当下载完成的时候调用
 *
 *  @param location     文件的临时存储路径
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"%@",location);
    //1.保存路径
    //2.将临时文件移动到保存路径
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:self.fullPath] error:nil];
    NSLog(@"path:%@",self.fullPath);
}
/**
 *  请求结束
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"下载完成：%@",error);

}
#pragma mark - getters
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
-(void)dealloc{
    [self.downloadTask cancel];
}

@end
