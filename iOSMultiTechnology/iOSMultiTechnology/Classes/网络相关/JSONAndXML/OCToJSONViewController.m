//
//  OCToJSONViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "OCToJSONViewController.h"

@interface OCToJSONViewController ()

@end

@implementation OCToJSONViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // eg:
    [self OCToJSON];
}

#pragma mark - OC对象->JSON对象
- (void)OCToJSON
{
    id obj = @{@"result":@[@{@"name":@"菜式菜品",
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
                                       ]
                             }],
               @"resultcode":@(200),
               @"reason":@"Success",
               @"error_code":@(0)
               };

    //方法判断当前OC对象能否转换为JSON数据
    /**
     具体限制：
     obj是NSArray 或 NSDictionay 以及他们派生出来的子类
     obj 包含的所有对象是NSString,NSNumber,NSArray,NSDictionary 或NSNull
     字典中所有的key必须是NSString类型的
     NSNumber的对象不能是NaN或无穷大
     */
    
    //     obj = @"abc123"; topL-level 是NSString 不支持
    if (![NSJSONSerialization isValidJSONObject:obj]) {
        NSLog(@"当前对象OC对象不支持转为SON数据");
        return;
    }
    NSError *error = nil;
    /**
     NSJSONWritingPrettyPrinted 漂亮的排版。对转换之后的JSON对象进行排版
     NSJSONWritingSortedKeys ios 11.0 之后使用,会对生成的数据，按照key的字母大小进行排序。数据一行显示.
     默认值 0or kNilOptions 数据一行显示
     */
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"error:%@",error);
        return;
    }
    NSString *path = [kCachesPath stringByAppendingPathComponent:@"123.json"];
    [data writeToFile:path atomically:YES];
    NSLog(@"查看Document中Jjson数据:\n%@",path);
    [self showTipStr:[NSString stringWithFormat:@"请查看文件路径中具体json文件:\n%@",path]];

}- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
