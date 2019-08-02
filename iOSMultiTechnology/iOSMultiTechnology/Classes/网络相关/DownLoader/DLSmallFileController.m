//
//  DLSmallFileController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/31.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "DLSmallFileController.h"
#import <MediaPlayer/MediaPlayer.h>

#define KSmallFileName @"海贼王_01.mp4"
@interface DLSmallFileController ()<NSURLConnectionDataDelegate>
/** 文件data */
@property (nonatomic, strong) NSMutableData *fileData;

/** 文件大小*/
@property (nonatomic, assign) NSInteger totalSize;

/** pic */
@property (nonatomic, strong) UIImageView *imageView;

/**  文件名称*/
@property (nonatomic,   copy) NSString *fileName;

/** 进度条*/
@property (nonatomic, strong) UIProgressView *progressView;


@end

@implementation DLSmallFileController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
/**
 //使用NSDta直接加载网络上的url资源（不考虑线程）
 耗时操作 [NSData dataWithContentsOfURL:url]
 如果资源过大 会导致内存飙升
 */
- (void)download1
{
    //1.确定资源路径
    NSURL *url = [NSURL URLWithString:@"https://p2.piqsels.com/preview/58/593/231/volcano-lava-steam-cloud.jpg"];
    NSLog(@"开始 dataWithContentsOfURL");
    //2.根据URL加载对应的资源
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSLog(@"结束 dataWithContentsOfURL");
    //3.转换并显示数据
    UIImage *image = [UIImage imageWithData:data];
    self.imageView.image = image;
}
/**
  存在问题
 1.无法监听进度
 2.如果资源过大 会导致内存飙升
 */
- (void)download2
{
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"https://p0.piqsels.com/preview/546/22/380/nature-hd-wallpaper-rocks.jpg"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.创队队列
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    //4.使用NSURLConnection发送一个异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //5.拿到并处理数据
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image;
    }];
}
/**
 存在问题
 1.如果资源过大 会导致内存飙升
 */
- (void)download3
{
    //1.创建url
    NSURL *url = [NSURL URLWithString:@"https://vd3.bdstatic.com/mda-jegt3vnqup701mav/mda-jegt3vnqup701mav.mp4?auth_key=1564584969-0-0-2a8e0e243293c076362362b684bc7571&bcevod_channel=searchbox_feed&pd=unknown"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.发送请求
    NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
    [connect start];
}
- (void)playBtnClick
{
    // 1.获取文件地址
    NSString *fullPath = [kCachesDownloadPath stringByAppendingPathComponent:KSmallFileName];
    // 2.创建播放url
    NSURL *url = [[NSURL alloc] initFileURLWithPath:fullPath];
    if (!url) {
        NSLog(@"找不到文件");
        return;
    }
    //3.创建播放控制器
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    //4.弹出控制器
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - NSURLConnectionDataDelegate
//当接收到服务器响应的时候调用，该方法只会调用一次
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s",__func__);
    //获得当前要下载文件的总大小
    self.totalSize = response.expectedContentLength;
    //拿到服务器端推荐的文件名称 (可用于文件名)
    self.fileName = response.suggestedFilename;
}
//当接收到服务器返回的数据时会调用
//该方法可能会被调用多次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 拼接 数据
    [self.fileData appendData:data];
    CGFloat f = 1.0 * self.fileData.length / self.totalSize;
    self.progressView.progress = f;
    //下载进度
    NSLog(@"下载进度 %f",1.0 * self.fileData.length / self.totalSize);
}
//当请求失败的时候调用该方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
}
//当网络请求结束之后调用
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s",__func__);
    //4.写数据到沙盒中
    NSString *fullPath =[kCachesDownloadPath stringByAppendingPathComponent:KSmallFileName];
    [self.fileData writeToFile:fullPath atomically:YES];
    NSLog(@"下载完成地址：\n%@",fullPath);
}
#pragma mark initViews
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"NSData" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(download1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downloadBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn2 setTitle:@"NSURLConnection-sendAsync" forState:UIControlStateNormal];
    [downloadBtn2 sizeToFit];
    [downloadBtn2 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn2 addTarget:self action:@selector(download2) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downloadBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn3 setTitle:@"NSURLConnection-delegate" forState:UIControlStateNormal];
    [downloadBtn3 sizeToFit];
    [downloadBtn3 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn3 addTarget:self action:@selector(download3) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn sizeToFit];
    [playBtn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn1.top = 10;
    downloadBtn1.centerX = self.view.centerX;

    downloadBtn2.top = 60;
    downloadBtn2.centerX = self.view.centerX;

    downloadBtn3.top = 110;
    downloadBtn3.centerX = self.view.centerX;
    
    playBtn.top = 160;
    playBtn.centerX = self.view.centerX;

    [self.view addSubview:downloadBtn1];
    [self.view addSubview:downloadBtn2];
    [self.view addSubview:downloadBtn3];
    [self.view addSubview:playBtn];
    
    UIProgressView *progressV = [[UIProgressView alloc] init];
    progressV.top = 210;
    progressV.width = 200;
    progressV.centerX = self.view.centerX;
    self.progressView = progressV;
    [self.view addSubview:self.progressView];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.left = 50;
    imageV.top = 260;
    imageV.width = ScreenWidth - 100;
    imageV.height = 300;
    
    self.imageView = imageV;
    [self.view addSubview:self.imageView];
    
}
#pragma mark - Getters
- (NSMutableData *)fileData
{
    if (!_fileData) {
        _fileData = [NSMutableData data];
    }
    return _fileData;
}

@end
