//
//  AFNGetAndPostController,m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "AFNGetAndPostController.h"

@interface AFNGetAndPostController ()

@end

@implementation AFNGetAndPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
- (void)get1
{
    NSString *address = kAPIURL_weChat_choice_list;
    NSDictionary *params = @{@"pno":@(1), //当前页数，默认1
                             @"ps" :@(5),//每页返回条数，最大50，默认20
                             @"dtype":@"json",  //返回数据的格式,xml或json，默认json
                             @"key":@"d51792ae54cb6fa161747ed7a08b781a"};
    //创建会话管理者
    //AFHTTPSessionManager内部是基于NSURLSession实现的
    kWeakSelf
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:address parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"currentThread：%@",[NSThread currentThread]);
        NSLog(@"responseObject:%@:",responseObject);
        // 3.解析数据
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:weakSelf.navigationItem.title message:[responseObject description] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:action];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
- (void)post
{

    NSString *address = kAPIURL_news_toutiao_list;
    NSDictionary *params = @{@"type":@"top",
                             @"dtype":@"json",
                             @"key":@"6f32779a067f86e9818845e403ce1f25"};
    //创建会话管理者
    //AFHTTPSessionManager内部是基于NSURLSession实现的
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    kWeakSelf
    [manager POST:address parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"currentThread：%@",[NSThread currentThread]);
        NSLog(@"responseObject:%@:",responseObject);
        NSArray *data = responseObject[@"result"][@"data"];
        if (data) {
            NSDictionary *dic = data.firstObject;
            // 3.解析数据
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:weakSelf.navigationItem.title message:[dic description] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:action];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
    
}
#pragma mark initViews
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"Get" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(get) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downloadBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn2 setTitle:@"POST" forState:UIControlStateNormal];
    [downloadBtn2 sizeToFit];
    [downloadBtn2 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn2 addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    
    
    downloadBtn1.top = 50;
    downloadBtn1.centerX = self.view.centerX;
    
    downloadBtn2.top = 100;
    downloadBtn2.centerX = self.view.centerX;
    
    
    [self.view addSubview:downloadBtn1];
    [self.view addSubview:downloadBtn2];
}

@end
