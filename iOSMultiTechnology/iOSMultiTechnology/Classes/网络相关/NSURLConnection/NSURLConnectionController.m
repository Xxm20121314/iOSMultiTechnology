//
//  NSURLConnectionController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLConnectionController.h"
#import "NSURLConnectionManager.h"

@implementation NSURLConnectionController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    NSString *address = @"http://apis.juhe.cn/cook/category";
    NSDictionary *params = @{@"parentid":@(0), //分类ID,默认全部
                             @"dtype":@"json",  //返回数据的格式,xml或json，默认json
                             @"key":@"bc2ee87d058a09f523e817ad1eb300e5"};
    XXMBridgeModel *item0= [[XXMBridgeModel alloc] init];
    item0.title = @"NSURLConnection简书";
    item0.block = ^{
        BaseWebViewController *web = [[BaseWebViewController alloc] init];
        web.urlString = @"https://www.jianshu.com/p/1ddf42be4e65";
        [self.navigationController pushViewController:web animated:YES];
    };
    
    XXMBridgeModel *item1= [[XXMBridgeModel alloc] init];
    item1.title = @"GET同步请求";
    item1.block = ^{
        
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage GET:NSURLConnectionTypRequestSync url:address params:params complete:^(id jsonObject, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            NSLog(@"GET同步请求成功:%@",jsonObject);
            [self alert: @"GET同步" msg:jsonObject];

        }];
    };
    
    XXMBridgeModel *item2= [[XXMBridgeModel alloc] init];
    item2.title = @"GET异步请求";
    item2.block = ^{
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage GET:NSURLConnectionTypeRequestAsync url:address params:params complete:^(id jsonObject, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            NSLog(@"GET异步请求成功:%@",jsonObject);
            [self alert: @"GET异步" msg:jsonObject];

        }];
    };
    
    XXMBridgeModel *item3= [[XXMBridgeModel alloc] init];
    item3.title = @"GETDelegate请求";
    item3.block = ^{
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage GET:NSURLConnectionTypeRequestDelegate url:address params:params complete:^(id jsonObject, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            NSLog(@"GETDelegate请求成功:%@",jsonObject);
            [self alert: @"GETDelegate" msg:jsonObject];

        }];
    };
    XXMBridgeModel *item4= [[XXMBridgeModel alloc] init];
    item4.title = @"POST同步请求";
    item4.block = ^{
        
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage POST:NSURLConnectionTypRequestSync url:address params:params complete:^(id jsonObject, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            NSLog(@"POST同步请求成功:%@",jsonObject);
            [self alert: @"POST异步" msg:jsonObject];
        }];
    };
    
    XXMBridgeModel *item5 = [[XXMBridgeModel alloc] init];
    item5.title = @"POST异步请求";
    item5.block = ^{
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage POST:NSURLConnectionTypeRequestAsync url:address params:params complete:^(id jsonObject, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            NSLog(@"POST异步请求成功:%@",jsonObject);
            [self alert: @"POST异步" msg:jsonObject];
        }];
    };
    
    XXMBridgeModel *item6= [[XXMBridgeModel alloc] init];
    item6.title = @"POSTDelegate请求";
    item6.block = ^{
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage POST:NSURLConnectionTypeRequestDelegate url:address params:params complete:^(id jsonObject, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            NSLog(@"POSTelegate请求成功:%@",jsonObject);
             [self alert: @"POSTelegate" msg:jsonObject];
        }];
    };
    
    [self.lists addObjectsFromArray:@[item0,item1,item2,item3,item4,item5,item6]];
    [self.tableView reloadData];
}
- (void)alert:(NSString*)title msg:(NSString*)msg
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}


@end
