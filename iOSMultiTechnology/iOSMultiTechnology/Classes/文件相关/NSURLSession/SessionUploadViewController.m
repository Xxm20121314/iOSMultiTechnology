//
//  SessionUploadViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "SessionUploadViewController.h"

@interface SessionUploadViewController ()<NSURLSessionDataDelegate>
/** session*/
@property (nonatomic, strong) NSURLSession *session;

/** 进度条*/
@property (nonatomic, strong) UIProgressView *progressView;

/** boundary*/
@property (nonatomic,   copy) NSString *boundary;
@end

@implementation SessionUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    self.boundary = XXMCreateMultipartFormBoundary();
}

- (void)upLoad
{
    // 1.确定请求路径
    NSURL *url = [NSURL URLWithString:kAPIURL_upload_image];
    
    // 2.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 3.设置请求方式
    request.HTTPMethod = @"POST";

    // 4.设请求头信息
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",self.boundary] forHTTPHeaderField:@"Content-Type"];
    // 5.创建task
    NSURLSessionUploadTask *uploadTask = [self.session uploadTaskWithRequest:request fromData:[self getBodyData] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error:%@",error);
            return ;
        }
        NSLog(@"%@",[NSThread currentThread]);
        //7.解析服务器返回的数据
        NSLog(@"上传成功%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"上传成功" message:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"成功" style:UIAlertActionStyleCancel handler:nil];
//        [alertVC addAction:action];
//        [self presentViewController:alertVC animated:YES completion:nil];
    }];
    //6.执行task
    [uploadTask resume];
}
#pragma mark - NSURLSessionDataDelegate
/*
 *  @param bytesSent                本次发送的数据
 *  @param totalBytesSent           上传完成的数据大小
 *  @param totalBytesExpectedToSend 文件的总大小
 */
 - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"%f",1.0 *totalBytesSent / totalBytesExpectedToSend);
    self.progressView.progress = 1.0 * totalBytesSent / totalBytesExpectedToSend;
}
#pragma mark - getters
- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //设置请求超时时间
        configuration.timeoutIntervalForRequest = 10;
        //在蜂窝网络情况下是否继续请求（上传或下载）默认YES
        configuration.allowsCellularAccess = NO;
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
    }
    return _session;
}
- (NSData*)getBodyData
{
    /** 设置请求体 **/
    NSMutableData *fileData = [NSMutableData data];
    /***文件的参数***/
    [fileData appendData:[[NSString stringWithFormat:@"--%@",self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:XXMMultipartFormCRLF()];
    // Content-Disposition name和filename 根据服务器字段来定义
    NSString *name = @"file";
    NSString *filename = @"file.png";
    [fileData appendData:XXMMultipartFormFileDisposition(name, filename)];
    [fileData appendData:XXMMultipartFormCRLF()];
    
    // Content-Type (mimeType)
    NSString *mimeType = @"image/jpeg";
    [fileData appendData:XXMMultipartFormContentType(mimeType)];
    [fileData appendData:XXMMultipartFormCRLF()];
    [fileData appendData:XXMMultipartFormCRLF()];
    UIImage *image = [UIImage imageNamed:@"avatar.jpg"];
    NSData *imageData = UIImagePNGRepresentation(image);
    // data
    [fileData appendData:imageData];
    [fileData appendData:XXMMultipartFormCRLF()];
    
    //    /*** 非文件的参数 ***/
    //    [fileData appendData:[[NSString stringWithFormat:@"--%@",XXMCreateMultipartFormBoundary()] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [fileData appendData:XXMMultipartFormCRLF()];
    //    // Content-Disposition
    //    //  @"appKey" : @"783f82ebefca4957e14e1542dd077f55"
    //    [fileData appendData:XXMMultipartFormNonfFileDisposition(@"appKey")];
    //    [fileData appendData:XXMMultipartFormCRLF()];
    //    [fileData appendData:XXMMultipartFormCRLF()];
    //    [fileData appendData:[@"783f82ebefca4957e14e1542dd077f55" dataUsingEncoding:NSUTF8StringEncoding]];
    //    [fileData appendData:XXMMultipartFormCRLF()];
    
    //结尾
    [fileData appendData:[[NSString stringWithFormat:@"--%@--",self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return fileData;
}
//分隔符
static NSString * XXMCreateMultipartFormBoundary() {
    return [NSString stringWithFormat:@"----Boundary%08X%08X", arc4random(), arc4random()];
}
//空行换行
static NSData * XXMMultipartFormCRLF() {
    return [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding];
}
//Content-Disposition （File）
static NSData * XXMMultipartFormFileDisposition(NSString * name,NSString *filename ) {
    return  [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"",name,filename]  dataUsingEncoding:NSUTF8StringEncoding];
}
//Content-Disposition （nonFile、params）
static NSData * XXMMultipartFormNonfFileDisposition(NSString * name) {
    return  [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"",name]  dataUsingEncoding:NSUTF8StringEncoding];
}
//Content-Type
static NSData * XXMMultipartFormContentType(NSString * mimeType ) {
    return  [[NSString stringWithFormat:@"Content-Type: %@",mimeType]  dataUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark initViews
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"上传" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(upLoad) forControlEvents:UIControlEventTouchUpInside];
    
    
    downloadBtn1.top = 10;
    downloadBtn1.centerX = self.view.centerX;
    
    
    [self.view addSubview:downloadBtn1];
    
    UIProgressView *progressV = [[UIProgressView alloc] init];
    progressV.top = 70;
    progressV.width = 200;
    progressV.centerX = self.view.centerX;
    self.progressView = progressV;
    [self.view addSubview:self.progressView];
    

    UIImageView *imageV = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"avatar.jpg"];;
    imageV.image = image;
    imageV.left = 50;
    imageV.top = 100;
    imageV.size = image.size;
    //    imageV.centerX = self.
    [self.view addSubview:imageV];
    
    

}
@end
