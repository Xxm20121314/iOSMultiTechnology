//
//  UpLoadController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/2.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "UpLoadController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface UpLoadController ()

/** 分隔符*/
@property (nonatomic,   copy) NSString *delimiter;
@end

@implementation UpLoadController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"XXMCreateMultipartFormBoundary:%@",XXMCreateMultipartFormBoundary());
    // Do any additional setup after loading the view.
}
- (void)upLoad
{
    // 确定请求路径
    NSURL *url = [NSURL URLWithString:kAPIURL_upload_image];
    // 创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方法
    request.HTTPMethod = @"POST";
    // 设置请求头信息
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",XXMCreateMultipartFormBoundary()] forHTTPHeaderField:@"Content-Type"];
    
    /** 步骤
     --分隔符
     Content-Disposition: form-data; name="file"; filename="imageName.png"
     Content-Type: image/png(MIMEType:大类型/小类型)
     空行
     文件参数
     */
    
    NSMutableData *fileData = [NSMutableData data];
    /***文件参数***/
    //初始化
    [fileData appendData:[[NSString stringWithFormat:@"--%@",XXMCreateMultipartFormBoundary()] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:XXMMultipartFormCRLF()];

    /**
     name:file 服务器规定的参数
     filename:image.jpg 文件保存到服务器上面的名称
     Content-Type:文件的类型
     */
    NSString *name = @"file";
    NSString *filename = @"avatar.jpg";
    [fileData appendData:XXMMultipartFormDisposition(name, filename)];
    [fileData appendData:XXMMultipartFormCRLF()];

    NSString *mimeType = @"image/jpeg";
    [fileData appendData:XXMMultipartFormContentType(mimeType)];
    [fileData appendData:XXMMultipartFormCRLF()];
    [fileData appendData:XXMMultipartFormCRLF()];
    
    UIImage *image = [UIImage imageNamed:@"avatar.jpg"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [fileData appendData:imageData];
    [fileData appendData:XXMMultipartFormCRLF()];
    /***非文件参数***/

    

}
//分隔符
static NSString * XXMCreateMultipartFormBoundary() {
    return [NSString stringWithFormat:@"----WebKitFormBoundary%08X%08X", arc4random(), arc4random()];
}
//空行换行
static NSData * XXMMultipartFormCRLF() {
    return [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding];
}
//Content-Disposition
static NSData * XXMMultipartFormDisposition(NSString * name,NSString *filename ) {
    return  [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"",name,filename]  dataUsingEncoding:NSUTF8StringEncoding];
}
//Content-Type
static NSData * XXMMultipartFormContentType(NSString * mimeType ) {
    return  [[NSString stringWithFormat:@"Content-Type: %@",mimeType]  dataUsingEncoding:NSUTF8StringEncoding];
}
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
