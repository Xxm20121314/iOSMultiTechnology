//
//  DLBigFIieNSOutputStreamController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/2.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "DLBigFIieNSOutputStreamController.h"
#import <MediaPlayer/MediaPlayer.h>
#define KBigStreamFileName @"NSURLConnection_海贼王_04.mp4"
@interface DLBigFIieNSOutputStreamController ()<NSURLConnectionDataDelegate,NSStreamDelegate>
/** 文件总大小 */
@property (nonatomic, assign) NSInteger totalSize;

/** 当前大小 */
@property (nonatomic, assign) NSInteger currentSize;

/** 输出流 写*/
@property (nonatomic, strong) NSOutputStream *writeStream;

/** 输入流 读*/
@property (nonatomic, strong) NSInputStream *readStream;

/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

/** 沙盒路径 */
@property (nonatomic, strong) NSString *fullPath;

/** connection*/
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation DLBigFIieNSOutputStreamController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
-(void)start
{
    if (self.connection) {
        return;
    }
    //1.创建url
    NSURL *url = [NSURL URLWithString:@"https://vd3.bdstatic.com/mda-jfseb0yyp60t4qw3/sc/mda-jfseb0yyp60t4qw3.mp4?auth_key=1564677583-0-0-b6d7a6696f32d134e565f215c5fb117d&bcevod_channel=searchbox_feed&pd=unknown&abtest=all"];
    //2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    /**
     3.设置下载文件的某一部分
     只要设置HTTP请求头的Range属性, 就可以实现从指定位置开始下载
     表示头500个字节：Range: bytes=0-499
     表示第二个500字节：Range: bytes=500-999
     表示最后500个字节：Range: bytes=-500
     表示500字节以后的范围：Range: bytes=500-
     */
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.currentSize];
    [request setValue:range forHTTPHeaderField:@"Range"];
    NSLog(@"range:%@",range);
    //4.发送请求
    NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    self.connection = connect;
}
- (void)cancel
{
    if (!self.connection) {
        return;
    }
    [self.connection cancel];
    self.connection = nil;
}
- (void)resume
{
    [self start];
}


- (void)play
{
    // 1.获取文件地址
    NSString *fullPath = [kCachesDownloadPath stringByAppendingPathComponent:KBigStreamFileName];
    // 2.创建播放url
    NSURL *url = [[NSURL alloc] initFileURLWithPath:fullPath];
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
    //1.得到文件的总大小(本次请求的文件数据的总大小 != 文件的总大小)
    self.totalSize = response.expectedContentLength + self.currentSize;
    if (self.currentSize > 0) {
        return;
    }
    //2.写数据到沙盒中
    self.fullPath = [kCachesDownloadPath stringByAppendingPathComponent:KBigStreamFileName];
    
    /**
     3.创建输出流
     第一个参数:文件的路径
     第二个参数:YES 追加
     特点:如果该输出流指向的地址没有文件,那么会自动创建一个空的文件
     */
    self.writeStream = [[NSOutputStream alloc] initToFileAtPath:self.fullPath append:YES];
    self.writeStream.delegate = self;
    //4.打开输出流
    [self.writeStream open];
}
//当接收到服务器返回的数据时会调用
//该方法可能会被调用多次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //写入数据
    [self.writeStream write:data.bytes maxLength:data.length];
    //获取进度
    self.currentSize += data.length;
    //进度计算
    self.progressView.progress = 1.0 * self.currentSize / self.totalSize;
    NSLog(@"%f",1.0 *  self.currentSize/self.totalSize);
}
//当请求失败的时候调用该方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
}
//当网络请求结束之后调用
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //关闭输出流
    [self.writeStream close];
    self.writeStream = nil;
    NSLog(@"下载完成地址：\n%@",self.fullPath);
}
#pragma mark  NSStreamDelegate代理

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    switch (eventCode) {
            
        case NSStreamEventHasSpaceAvailable:{ // 写
            NSLog(@"NSStreamEventHasSpaceAvailable");
            break;
        }
        case NSStreamEventHasBytesAvailable:{ // 读
            NSLog(@"NSStreamEventHasBytesAvailable");
            uint8_t buf[1024];
            NSInteger blength = [self.readStream read:buf maxLength:sizeof(buf)];
            
            if (blength != 0) {
                NSData *data = [NSData dataWithBytes:(void *)buf length:blength];
                NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"文件内容如下：----->%@",msg);
            }else{
                [self.readStream close];
                return;
            }
            
            break;
        }
        case NSStreamEventErrorOccurred:{// 错误处理
            
            NSLog(@"错误处理");
            break;
            
        }
        case NSStreamEventEndEncountered: {
            [aStream close];
            break;
        }
        case NSStreamEventNone:{// 无事件处理
            
            NSLog(@"无事件处理");
            break;
        }
        case  NSStreamEventOpenCompleted:{// 打开完成
            
            NSLog(@"打开文件");
            break;
        }
        default:
            break;
    }
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
    [downloadBtn2 setTitle:@"取消下载" forState:UIControlStateNormal];
    [downloadBtn2 sizeToFit];
    [downloadBtn2 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn2 addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downloadBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn3 setTitle:@"继续下载" forState:UIControlStateNormal];
    [downloadBtn3 sizeToFit];
    [downloadBtn3 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn3 addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
    
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
    
}

@end
