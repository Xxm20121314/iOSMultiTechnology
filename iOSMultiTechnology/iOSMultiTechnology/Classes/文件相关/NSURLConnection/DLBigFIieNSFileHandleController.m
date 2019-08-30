//
//  DLBigFIieNSFileHandleController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/31.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "DLBigFIieNSFileHandleController.h"
#import <MediaPlayer/MediaPlayer.h>
#define KBigFileName @"NSURLConnection_海贼王_02.mp4"
@interface DLBigFIieNSFileHandleController ()<NSURLConnectionDataDelegate>

/** 文件总大小 */
@property (nonatomic, assign) NSInteger totalSize;

/** 当前大小 */
@property (nonatomic, assign) NSInteger currentSize;

/** 文件句柄 */
@property (nonatomic,   copy) NSFileHandle *fileHandle;

/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

/** 沙盒路径 */
@property (nonatomic, strong) NSString *fullPath;
@end

@implementation DLBigFIieNSFileHandleController
- (void)viewDidLoad {
    [super viewDidLoad];
     /**文件句柄 处理数据
      使用文件句柄不会导致内存暴增
      */
    [self initViews];
}
- (void)playBtnClick
{
    // 1.获取文件地址
    NSString *fullPath = [kCachesDownloadPath stringByAppendingPathComponent:KBigFileName];
    // 2.创建播放url
    NSURL *url = [[NSURL alloc] initFileURLWithPath:fullPath];
    //3.创建播放控制器
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    //4.弹出控制器
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)download
{
    //1.创建url
    NSURL *url = [NSURL URLWithString:@"https://vd3.bdstatic.com/mda-jdppj9r4xxg48i02/sc/mda-jdppj9r4xxg48i02.mp4?auth_key=1564583903-0-0-da90758991ae6f190b03e4de60e148fc&bcevod_channel=searchbox_feed&pd=bjh&abtest=alln"];
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.发送请求
    NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
    [connect start];
}
#pragma mark - NSURLConnectionDataDelegate
//当接收到服务器响应的时候调用，该方法只会调用一次
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s",__func__);
    //1.得到文件的总大小
    self.totalSize = response.expectedContentLength;
    
    //2.保存沙盒路径
    self.fullPath = [kCachesDownloadPath stringByAppendingPathComponent:KBigFileName];
    
    //3.创建一个空的文件
    [[NSFileManager defaultManager] createFileAtPath:self.fullPath contents:nil attributes:nil];
    
    //4.创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];

}
//当接收到服务器返回的数据时会调用
//该方法可能会被调用多次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //1.移动文件句柄到数据的末尾
    [self.fileHandle seekToEndOfFile];
    
    //2.写入数据
    [self.fileHandle writeData:data];
    
    //3.获得进度
    self.currentSize += data.length;
    
    //4.显示进度=已经下载/文件的总大小
    NSLog(@"%f",1.0 *  self.currentSize / self.totalSize);
    self.progressView.progress = 1.0 *  self.currentSize / self.totalSize;
}
//当请求失败的时候调用该方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
}
//当网络请求结束之后调用
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //关闭文件句柄
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    NSLog(@"下载完成地址：\n%@",self.fullPath);
}
#pragma mark initViews
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
