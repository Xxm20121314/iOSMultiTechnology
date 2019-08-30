//
//  NSURLSessionPostController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/27.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLSessionPostController.h"

@interface NSURLSessionPostController ()

@end

@implementation NSURLSessionPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)post
{
    NSString *address = kAPIURL_weChat_choice_list;
    NSDictionary *params = @{@"pno":@(1), //当前页数，默认1
                             @"ps" :@(2),//每页返回条数，最大50，默认20
                             @"dtype":@"json",  //返回数据的格式,xml或json，默认json
                             @"key":@"d51792ae54cb6fa161747ed7a08b781a"};
    
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:address];
    
    //2.创建可变请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    //2.1 设置请求方法POST
    request.HTTPMethod = @"POST";

    //2.2. 设置请求体 HTTPBody
    request.HTTPBody = [[NSString paramsStringWithParams:params] dataUsingEncoding:NSUTF8StringEncoding];
    //3.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"currentThread：%@",[NSThread currentThread]);
        if (error) {
            NSLog(@"error:%@",error);
            return ;
        }
        // 4.解析数据
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        kWeakSelf
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:weakSelf.navigationItem.title message:dataStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:action];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        });
    }];
    //4.执行Task
    //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
    [dataTask resume];
}
#pragma mark initViews
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"Post" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];

    downloadBtn1.top = 50;
    downloadBtn1.centerX = self.view.centerX;
    
    [self.view addSubview:downloadBtn1];
}


@end
