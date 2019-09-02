//
//  AFNUploadViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "AFNUploadViewController.h"

@interface AFNUploadViewController ()
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

/** boundary*/
@property (nonatomic,   copy) NSString *boundary;
@end

@implementation AFNUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    self.boundary = XXMCreateMultipartFormBoundary();
}
- (void)upload1
{
    //1.创建url
    NSURL *url = [NSURL URLWithString:kAPIURL_upload_image];
    //2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //3.设置请求方式POST
    request.HTTPMethod = @"POST";
    //4.设置请求体
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",self.boundary] forHTTPHeaderField:@"Content-Type"];
    //5.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //6.创建请求任务
    kWeakSelf
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:[self getBodyData] progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        //更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressView.progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        });
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error){
            NSLog(@"error:%@",error);
        }
        NSLog(@"上传完成---%@",responseObject);
    }];
    //7.执行任务
    [uploadTask  resume];
}
- (void)upload2
{
    NSString *name = @"file";
    NSString *filename = @"file.png";
    NSString *mimeType = @"image/jpeg";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    kWeakSelf
    [manager POST:kAPIURL_upload_image parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //使用formData来拼接数据
        /*
         第一个参数:二进制数据 要上传的文件参数
         第二个参数:服务器规定的
         第三个参数:该文件上传到服务器以什么名称保存
         */
        UIImage *image = [UIImage imageNamed:@"avatar.jpg"];
        NSData *imageData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:imageData name:name fileName:filename mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        //更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressView.progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        });
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功---%@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败---%@",error);
    }];
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
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"上传（传统方式）" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(upload1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downloadBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn2 setTitle:@"上传（推荐方式）" forState:UIControlStateNormal];
    [downloadBtn2 sizeToFit];
    [downloadBtn2 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn2 addTarget:self action:@selector(upload2) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn1.top = 10;
    downloadBtn1.centerX = self.view.centerX;
    
    downloadBtn2.top = 60;
    downloadBtn2.centerX = self.view.centerX;

    [self.view addSubview:downloadBtn1];
    [self.view addSubview:downloadBtn2];
    
    UIProgressView *progressV = [[UIProgressView alloc] init];
    progressV.top = 100;
    progressV.width = 200;
    progressV.centerX = self.view.centerX;
    self.progressView = progressV;
    [self.view addSubview:self.progressView];
}


@end
