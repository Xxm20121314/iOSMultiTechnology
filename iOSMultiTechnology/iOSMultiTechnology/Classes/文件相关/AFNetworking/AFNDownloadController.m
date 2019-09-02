//
//  AFNDownloadController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "AFNDownloadController.h"
#define KFileName @"AFNetworking_海贼王_01.mp4"
#import <MediaPlayer/MediaPlayer.h>
@interface AFNDownloadController ()
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

/** 文件保存路径*/
@property (nonatomic, copy) NSString *fullPath;
@end

@implementation AFNDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
- (void)download
{
    // 1.创建url
    NSURL *url = [NSURL URLWithString:@"https://vd3.bdstatic.com/mda-jegt3vnqup701mav/mda-jegt3vnqup701mav.mp4?auth_key=1564584969-0-0-2a8e0e243293c076362362b684bc7571&bcevod_channel=searchbox_feed&pd=unknown"];
    // 2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //4.创建下载任务
    kWeakSelf
    //创建一个空的文件
//    [[NSFileManager defaultManager] createFileAtPath:self.fullPath contents:nil attributes:nil];
    
        NSURLSessionDownloadTask *downloadTask = [ manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        //更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return  [NSURL fileURLWithPath:self.fullPath];;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"下载完成:%@",self.fullPath);
        NSLog(@"filePath:%@",filePath);
    }];
    // 5.执行Task
    [downloadTask resume];
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
#pragma mark - getters
- (NSString *)fullPath
{
    if (!_fullPath) {
        _fullPath = [kCachesDownloadPath stringByAppendingPathComponent:KFileName];
    }
    return _fullPath;
}
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"下载" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn1.top = 20;
    downloadBtn1.centerX = self.view.centerX;
    
    [self.view addSubview:downloadBtn1];
    
    UIProgressView *progressV = [[UIProgressView alloc] init];
    progressV.top = 70;
    progressV.width = 200;
    progressV.centerX = self.view.centerX;
    self.progressView = progressV;
    [self.view addSubview:self.progressView];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn sizeToFit];
    [playBtn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    
    playBtn.top = 80;
    playBtn.centerX = self.view.centerX;
    [self.view addSubview:playBtn];
}

@end
