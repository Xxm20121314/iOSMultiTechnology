//
//  FileTableViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/26.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "FileTableViewController.h"

#import "ZIpViewController.h"
#import "MIMETypeViewController.h"
#import "FileOperationController.h"
#import "SessionFileOperationController.h"
@interface FileTableViewController ()
@property (nonatomic, strong) UISwitch *s;
@end

@implementation FileTableViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    XXMBridgeModel *item0 = [[XXMBridgeModel alloc] init];
    item0.title = @"文件下载与上传";
    item0.subTitle = @"NSURLConnection";
    item0.bridgeClass = [FileOperationController class];
    
    XXMBridgeModel *item1 = [[XXMBridgeModel alloc] init];
    item1.title = @"文件下载与上传";
    item1.subTitle = @"NSURLSession";
    item1.bridgeClass = [SessionFileOperationController class];
    
    XXMBridgeModel *item2= [[XXMBridgeModel alloc] init];
    item2.title = @"文件压缩与解压缩";
    item2.subTitle = @"第三方（SSZipArchive）";
    item2.bridgeClass = [ZIpViewController class];
    
    XXMBridgeModel *item3 = [[XXMBridgeModel alloc] init];
    item3.title = @"文件MIMEType类型";
    item3.bridgeClass = [MIMETypeViewController class];
    
    [self.lists addObjectsFromArray:@[item0,item1,item2,item3]];
    //创建文件夹
    if ([[FileManager sharedManager] creatDirectoryAtPath:kCachesDownloadPath]){
        [self.tableView reloadData];
    }
    self.tableView.tableHeaderView = [self tableHeaderView];
}
- (UIView*)tableHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,ScreenWidth,50}];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"自动清理文件";
    [label sizeToFit];
    
    label.left = 15;
    label.height = 50;
    [view addSubview:label];
    
    self.s = [[UISwitch alloc] initWithFrame:(CGRect){label.right + 5,10,40,30}];
    [self.s addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:self.s];
    
    BOOL autoClean = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoCleanFile"];
    self.s.on = autoClean;
    return view;
}
- (void)switchChange:(UISwitch*)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"autoCleanFile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)dealloc
{
    if (self.s.isOn) {
        [[FileManager sharedManager] removeAtPath:kCachesDownloadPath];
    }
}
@end
