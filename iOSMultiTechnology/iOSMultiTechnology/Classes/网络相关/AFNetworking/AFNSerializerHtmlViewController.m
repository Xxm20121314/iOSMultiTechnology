//
//  AFNSerializerHtmlViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "AFNSerializerHtmlViewController.h"

@interface AFNSerializerHtmlViewController ()

@end

@implementation AFNSerializerHtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
-(void)html
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //告诉AFN能够接受text/html类型的数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //注意:改解析方案为: AFHTTPResponseSerializer
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //2.发送GET请求
    [manager GET:@"http://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task,id  _Nullable responseObject) {
        NSLog(@"%@-%@",[responseObject class],[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        //UIImage *image = [UIImage imageWithData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

#pragma mark initViews
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"请求" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(html) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn1.top = 50;
    downloadBtn1.centerX = self.view.centerX;
    
    [self.view addSubview:downloadBtn1];
}


@end
