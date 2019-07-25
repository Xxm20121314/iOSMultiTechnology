//
//  NSURLConnectionController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLConnectionController.h"
#import "NSURLConnectionManager.h"

@interface NSURLConnectionController ()
@property (nonatomic,strong) NSMutableArray *lists;
@end

@implementation NSURLConnectionController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    NSString *address = @"http://apis.juhe.cn/cook/category";
    NSDictionary *params = @{@"parentid":@(101), //分类ID,默认全部
                             @"dtype":@"json",  //返回数据的格式,xml或json，默认json
                             @"key":@"bc2ee87d058a09f523e817ad1eb300e5"};
    XXMBridgeModel *item1= [[XXMBridgeModel alloc] init];
    item1.title = @"GET同步";
    item1.block = ^{
        
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage GET:NSURLConnectionTypeGetSync url:address params:params complete:^(id jsonObject, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            NSLog(@"GET同步请求成功:%@",jsonObject);
        }];
    };
    
    XXMBridgeModel *item2= [[XXMBridgeModel alloc] init];
    item2.title = @"GET异步";
    item2.block = ^{
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage GET:NSURLConnectionTypeGetAsync url:address params:params complete:^(id jsonObject, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            NSLog(@"GET异步请求成功:%@",jsonObject);
        }];
    };
    
    XXMBridgeModel *item3= [[XXMBridgeModel alloc] init];
    item3.title = @"GETDelegate";
    item3.block = ^{
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage GET:NSURLConnectionTypeGetDelegate url:address params:params complete:^(id jsonObject, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            NSLog(@"GETDelegate请求成功:%@",jsonObject);
        }];
    };
    
    XXMBridgeModel *item4= [[XXMBridgeModel alloc] init];
    item4.title = @"POST同步";
    item4.block = ^{
        
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage POST:NSURLConnectionTypePostSync url:address params:params complete:^(id jsonObject, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            NSLog(@"POST同步请求成功:%@",jsonObject);
        }];
    };
    
    XXMBridgeModel *item5 = [[XXMBridgeModel alloc] init];
    item5.title = @"POST异步";
    item5.block = ^{
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage POST:NSURLConnectionTypePostAsync url:address params:params complete:^(id jsonObject, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            NSLog(@"POST异步请求成功:%@",jsonObject);
        }];
    };
    
    XXMBridgeModel *item6= [[XXMBridgeModel alloc] init];
    item6.title = @"POSTDelegate";
    item6.block = ^{
        NSURLConnectionManager *manage = [[NSURLConnectionManager alloc] init];
        [manage POST:NSURLConnectionTypePostDelegate url:address params:params complete:^(id jsonObject, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            NSLog(@"POSTelegate请求成功:%@",jsonObject);
        }];
    };
    
    [self.lists addObjectsFromArray:@[item1,item2,item3,item4,item5,item6]];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXMBridgeCell *cell = [XXMBridgeCell cellWithTableView:tableView];
    cell.item = self.lists[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXMBridgeModel *item = self.lists[indexPath.row];
    if (item.block) {
        item.block();
        return;
    }
    if(item.bridgeClass)
    {
        UIViewController *vc = [[item.bridgeClass alloc] init];
        if ([vc isKindOfClass:[UIViewController class]]) {
            vc.navigationItem.title = item.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - getting
- (NSMutableArray *)lists
{
    if (!_lists) {
        _lists = [NSMutableArray new];
    }
    return _lists;
}

@end
