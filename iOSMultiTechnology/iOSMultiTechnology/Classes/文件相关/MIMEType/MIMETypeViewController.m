//
//  MIMETypeViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/19.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "MIMETypeViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface MIMETypeViewController ()

@end

@implementation MIMETypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
- (void)mimeType1
{
    NSString *filePtah = [[NSBundle mainBundle] pathForResource:@"avatar.jpg" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePtah];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"MIME类型" message:response.MIMEType preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)mimeType2
{
    NSString *filePtah = [[NSBundle mainBundle] pathForResource:@"fried_rice.png" ofType:nil];
   NSString *mimeType = [self mimeTypeForFileAtPath:filePtah];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"MIME类型" message:mimeType preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}
/**
 注意：需要依赖于框架MobileCoreServices
 */
- (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,  (__bridge CFStringRef _Nonnull)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        //application/octet-stream 任意的二进制数据类型
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}
#pragma mark initViews
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"1.网络请求" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(mimeType1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downloadBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn2 setTitle:@"2.MobileCoreServices" forState:UIControlStateNormal];
    [downloadBtn2 sizeToFit];
    [downloadBtn2 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn2 addTarget:self action:@selector(mimeType2) forControlEvents:UIControlEventTouchUpInside];
    
 
    downloadBtn1.top = 10;
    downloadBtn1.centerX = self.view.centerX;
    
    downloadBtn2.top = 60;
    downloadBtn2.centerX = self.view.centerX;
    
    [self.view addSubview:downloadBtn1];
    [self.view addSubview:downloadBtn2];
}
@end
