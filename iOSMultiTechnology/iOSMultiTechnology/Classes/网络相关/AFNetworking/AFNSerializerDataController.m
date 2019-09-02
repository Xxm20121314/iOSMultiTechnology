//
//  AFNSerializerDataController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "AFNSerializerDataController.h"

@interface AFNSerializerDataController ()
/** imageV*/
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation AFNSerializerDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
- (void)get
{
    NSString *address = @"http://appimg.jiwu.com/file/2019/08/30/1567154987868039_s.png";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //注意:如果返回的数据既不是xml也不是json那么应该修改解析方案为: AFHTTPResponseSerializer
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:address parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@:",[responseObject class]);
        UIImage *image = [UIImage imageWithData:responseObject];
        self.imageView.image = image;
        
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
    [downloadBtn1 addTarget:self action:@selector(get) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn1.top = 50;
    downloadBtn1.centerX = self.view.centerX;
    
    [self.view addSubview:downloadBtn1];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.top = 100;
    imageV.width = 200;
    imageV.height = 200;
    imageV.centerX = self.view.centerX;
    self.imageView = imageV;
    [self.view addSubview:self.imageView];
}


@end
