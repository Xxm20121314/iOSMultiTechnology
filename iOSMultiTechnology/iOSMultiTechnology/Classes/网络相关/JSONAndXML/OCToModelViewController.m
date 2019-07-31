//
//  OCToModelViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "OCToModelViewController.h"

#import "NSURLConnectionManager.h"

#import "MJCookingDataModel.h"
#import "YYCookingDataModel.h"

#import "YYNewsDataModel.h"
#import "MJNewsDataModel.h"

@interface OCToModelViewController ()
/** <# 注释 #>*/
@property (nonatomic, assign) BOOL isYYModel;

@end

@implementation OCToModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.destParams) {
        if ([self.destParams[@"dest_key"] isEqualToString:@"YYModel"]) {
            self.isYYModel = YES;
        }else{
            self.isYYModel = NO;
        }
    }
    [self initViews];
}
- (void)initViews
{
    UIButton *localBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [localBtn setTitle:@"数据（本地）" forState:UIControlStateNormal];
    localBtn.backgroundColor = [UIColor blueColor];
    [localBtn sizeToFit];
    [localBtn addTarget:self action:@selector(LocalOCToJSON) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *serverlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [serverlBtn setTitle:@"数据（服务器）" forState:UIControlStateNormal];
    [serverlBtn sizeToFit];
    serverlBtn.backgroundColor = [UIColor blueColor];
    [serverlBtn addTarget:self action:@selector(ServerOCToJSON) forControlEvents:UIControlEventTouchUpInside];
    
    localBtn.top = 50;
    localBtn.left = 100;
    
    serverlBtn.top = 150;
    serverlBtn.left = 100;

    [self.view addSubview:localBtn];
    [self.view addSubview:serverlBtn];

}
#pragma mark - OC对象->JSON对象(本地)
- (void)LocalOCToJSON
{
    NSDictionary *dataObj = @{ @"resultcode":@(200),
                               @"reason":@"Success",
                               @"error_code":@(0),
                               @"result":@[@{@"name":@"菜式菜品",
                                             @"parentId":@(10001),
                                             @"list":@[@{@"id":@(1),
                                                         @"name":@"家常菜",
                                                         @"parentId":@(10001)},
                                                       @{@"id":@(2),
                                                         @"name":@"快手菜",
                                                         @"parentId":@(10001)},
                                                       @{@"id":@(3),
                                                         @"name":@"创意菜",
                                                         @"parentId":@(10001)},
                                                       @{@"id":@(4),
                                                         @"name":@"素菜",
                                                         @"parentId":@(10001)},
                                                       ]}]
                               };
    
    NSArray *list = dataObj[@"result"];
    NSMutableArray *dataArray = [NSMutableArray new];
    if (self.isYYModel) {
        NSLog(@"YYModel：开始解析");
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YYCookingDataModel *model = [[YYCookingDataModel alloc] init];
            [model yy_modelSetWithDictionary:obj];
            [dataArray addObject:model];
        }];
        NSLog(@"data:%@",dataArray);
        if (dataArray) {
            YYCookingDataModel *model = dataArray.firstObject;
            NSLog(@"YYModel：解析后\n parentId:%@\n name:%@ \n list:%@",@(model.parentId),model.name,model.list);
        }
    }else{
        NSLog(@"MJExtension：开始解析");
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MJCookingDataModel *model = [[MJCookingDataModel alloc] init];
            [model mj_setKeyValues:obj];
            [dataArray addObject:model];
        }];
        NSLog(@"data:%@",dataArray);
        if (dataArray) {
            MJCookingDataModel *model = dataArray.firstObject;
            NSLog(@"MJExtension：解析开始后\n parentId:%@\n name:%@ \n list:%@",@(model.parentId),model.name,model.list);
        }
    }
}

#pragma mark - OC对象->JSON对象(服务器)
- (void)ServerOCToJSON
{
    NSString *address = @"http://v.juhe.cn/toutiao/index";
    NSDictionary *params = @{@"type":@"top",
                             @"dtype":@"json",  //json
                             @"key":@"6f32779a067f86e9818845e403ce1f25"};
    
    kWeakSelf
    NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
    [manage GET:address params:params dataBlock:^(NSData *resultData, NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            return ;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:nil];
        //处理网络数据
        [weakSelf handData:dict];
    }];
}
- (void)handData:(NSDictionary*)dict
{
    NSDictionary *dataDic = dict[@"result"];
    if (self.isYYModel) {
        NSLog(@"YYModel：开始解析");
        YYNewsDataModel *model = [[YYNewsDataModel alloc] init];
        [model yy_modelSetWithDictionary:dataDic];
        NSLog(@"YYModel：解析后\n stat:%@\n data:%@",@(model.stat),model.newsLists);
    }else{
        NSLog(@"MJExtension：开始解析");
        MJNewsDataModel *model = [[MJNewsDataModel alloc] init];
        [model mj_setKeyValues:dataDic];
        NSLog(@"MJExtension：解析后\n stat:%@\n data:%@",@(model.stat),model.newsLists);
    }
}
@end
