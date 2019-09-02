//
//  ConnectionUpLoadController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/2.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "ConnectionUpLoadController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ConnectionUpLoadController ()<NSURLConnectionDataDelegate>
/** reveiveData*/
@property (nonatomic, strong) NSMutableData *reveiveData;

/** 进度条*/
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation ConnectionUpLoadController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    // Do any additional setup after loading the view.
}
- (void)upLoad
{
    // 确定请求路径
    NSURL *url = [NSURL URLWithString:kAPIURL_upload_image];
    // 创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 5.0;
    // 设置请求方法
    request.HTTPMethod = @"POST";
    /** 设置请求头信息 **/
    // 设置 Content-Type
    NSString *boundary = XXMCreateMultipartFormBoundary();
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    UIImage *image = [UIImage imageNamed:@"avatar.jpg"];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *strLength = [NSString stringWithFormat:@"%ld", (long)imageData.length];
//     设置 Content-Length
    [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
    
    /** 设置请求体 **/
    NSMutableData *fileData = [NSMutableData data];
    /***文件的参数***/
    [fileData appendData:[[NSString stringWithFormat:@"--%@",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
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
    [fileData appendData:[[NSString stringWithFormat:@"--%@--",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    request.HTTPBody = fileData;
    // 发送请求
    NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
    [connect setDelegateQueue:[NSOperationQueue mainQueue]];
    [connect start];
    self.reveiveData = [NSMutableData new];
}
#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection  didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSLog(@"%f",1.0 *totalBytesWritten / totalBytesExpectedToWrite);
    self.progressView.progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;

}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data
{
    //接受服务端返回的数据
    [self.reveiveData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"上传成功");
    id obj = [NSJSONSerialization JSONObjectWithData:self.reveiveData options:kNilOptions error:nil];
    NSLog(@"%@",obj);
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
}
//分隔符（不强制要求这样格式、(这里的demo仿照web请求例子 ----WebKitFormBoundaryELACoLe9jG4DpV21)，
static NSString * XXMCreateMultipartFormBoundary() {
    return [NSString stringWithFormat:@"----WebKitFormBoundary%08X%08X", arc4random(), arc4random()];
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
    imageV.top = 100;
    imageV.width = 200;
    imageV.height = 200;
    imageV.centerX = self.view.centerX;
    [self.view addSubview:imageV];
    
}
#pragma mark - 步骤解析
- (void)steps
{
    /** 文件上传步骤
     （1）确定请求路径
     （2）根据URL创建一个可变的请求对象
     （3）设置请求对象，修改请求方式为POST
     （4）设置请求头，告诉服务器我们将要上传文件（Content-Type）
     （5）设置请求体（在请求体中按照既定的格式拼接要上传的文件参数和非文件参数等数据）
        001 拼接文件参数
        002 拼接非文件参数
        003 添加结尾标记
     （6）使用NSURLConnection sendAsync发送异步请求上传文件
     （7）解析服务器返回的数据
     */

    /**  设置请求头
        Content-Type:multipart/form-data; boundary=----WebKitFormBoundaryjv0UfA04ED44AhWx
     */
    
    /** 请求体 数据格式
     分隔符：------WebKitFormBoundaryjv0UfA04ED44AhWx
     
     //01.文件参数拼接格式
     
     --分隔符
     Content-Disposition:参数
     Content-Type:参数
     空行
     文件参数
     
     //02.非文件拼接参数
     --分隔符
     Content-Disposition:参数
     空行
     非文件的二进制数据
     
     //03.结尾标识
     --分隔符--
     */
}

@end
