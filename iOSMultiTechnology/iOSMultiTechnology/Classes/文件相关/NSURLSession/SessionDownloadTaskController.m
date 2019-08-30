//
//  SessionDownloadTaskController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/28.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "SessionDownloadTaskController.h"
#define KFileName @"NSURLSession_海贼王_01.mp4"
@interface SessionDownloadTaskController ()

@end

@implementation SessionDownloadTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
//优点:不需要担心内存
//缺点:无法监听文件下载进度
- (void)download
{
    //1.创建url
    NSURL *url = [NSURL URLWithString:@"https://vd3.bdstatic.com/mda-jegt3vnqup701mav/mda-jegt3vnqup701mav.mp4?auth_key=1564584969-0-0-2a8e0e243293c076362362b684bc7571&bcevod_channel=searchbox_feed&pd=unknown"];
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //4.创建Task
    /*
     第一个参数:请求对象
     第二个参数:completionHandler 回调
     location:
     response:响应头信息
     error:错误信息
     */
    //该方法内部已经实现了边接受数据边写沙盒(tmp)的操作
    NSURLSessionDownloadTask *downloadTask =  [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error:%@",error);
            return ;
        }
        NSLog(@"%@==%@",location,[NSThread currentThread]);
        //6.保存路径
        NSString *path = [kCachesDownloadPath stringByAppendingPathComponent:KFileName];
        //7.将临时文件移动到保存路径
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:nil];
        NSLog(@"path：%@",path);
    }];
    //5.执行Task
    [downloadTask resume];
}

- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"DownloadTask(Block)" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn1.top = 50;
    downloadBtn1.centerX = self.view.centerX;
    
    [self.view addSubview:downloadBtn1];
}
@end
