//
//  ZIpViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/31.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "ZIpViewController.h"

#import "SSZipArchive.h"

@interface ZIpViewController ()
/** 压缩包路径*/
@property (nonatomic,   copy) NSString *zipPath;
@end

@implementation ZIpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    if ([[FileManager sharedManager] creatDirectoryAtPath:kCachesZipPath]){
        [self initViews];
    }
}
#pragma mark 压缩某个路径的文件
- (void)zip1
{
    
    NSArray *paths = @[[[NSBundle mainBundle] pathForResource:@"foggy-nature.jpg" ofType:nil],
                       [[NSBundle mainBundle] pathForResource:@"forest-nature.jpg" ofType:nil]];
    
    /**
     第一个参数:压缩文件的存放位置
     第二个参数:要压缩哪些文件(路径)
     */
    NSString *path = [kCachesZipPath stringByAppendingPathComponent:@"nature.zip"];
//    BOOL success =  [SSZipArchive createZipFileAtPath:path withFilesAtPaths:paths];

    // 带密码压缩
    BOOL success =  [SSZipArchive createZipFileAtPath:path withFilesAtPaths:paths withPassword:@"123456"];
    if (success) {
        self.zipPath = path;
        NSLog(@"使用密码压缩成功:\n %@",path);
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"压缩（路径)" message:path preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"成功" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
#pragma mark - 压缩某个文件夹（目录）
- (void)zip2
{
    
    NSArray *paths = @[[[NSBundle mainBundle] pathForResource:@"love_dir.jpg" ofType:nil],
                       [[NSBundle mainBundle] pathForResource:@"temple-dir.jpg" ofType:nil]];
    
  
    //准备数据
    //1.0:要压缩的文件夹(目录)
    NSString *tempDirectoryPath =  [kCachesZipPath stringByAppendingPathComponent:@"tempDir"];
    [self creatDir:tempDirectoryPath];
    //2.0 玩文件文件夹里面添加数据
    NSString *destPath1 = [tempDirectoryPath stringByAppendingPathComponent:@"love_dir.jpg"];
    NSString *destPath2 = [tempDirectoryPath stringByAppendingPathComponent:@"temple-dir.jpg"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destPath1]) {
        [[NSFileManager defaultManager] copyItemAtPath:paths[0] toPath:destPath1 error:nil];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:destPath2]) {
        [[NSFileManager defaultManager] copyItemAtPath:paths[0] toPath:destPath2  error:nil];
    }
    NSLog(@"tmp文件目录:\n%@",tempDirectoryPath);
    /**
     第一个参数:压缩文件的存放位置
     第二个参数:要压缩哪些文件(路径)
     */
    NSString *path = [kCachesZipPath stringByAppendingPathComponent:@"testDir.zip"];
    
    // 压缩
//   BOOL success = [SSZipArchive createZipFileAtPath:path withContentsOfDirectory:tempDirectoryPath];
    
    // 带密码压缩
    BOOL success =  [SSZipArchive createZipFileAtPath:path withContentsOfDirectory:tempDirectoryPath withPassword:@"123456"];
    if (success) {
        NSLog(@"使用压缩文件夹成功:\n %@",path);
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"压缩（目录)" message:path preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"成功" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
#pragma mark - 解压
- (void)unzip
{
    if (self.zipPath == nil) {
        NSLog(@"请先压缩文件");
        return;
    }
    NSLog(@"解压文件：\n%@",self.zipPath);
    NSString *destPath = [kCachesZipPath stringByAppendingPathComponent:@"upZipTemp"];
    BOOL success =  [SSZipArchive unzipFileAtPath:self.zipPath toDestination:destPath overwrite:YES password:@"123456" error:nil];
    if (success) {
        NSLog(@"使用密码解压成功:\n %@",destPath);
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"解压" message:destPath preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"成功" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
#pragma mark initViews
- (void)initViews
{
    UIButton *downloadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn1 setTitle:@"1.压缩（路径）" forState:UIControlStateNormal];
    [downloadBtn1 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn1 sizeToFit];
    [downloadBtn1 addTarget:self action:@selector(zip1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downloadBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn2 setTitle:@"2.压缩(目录)" forState:UIControlStateNormal];
    [downloadBtn2 sizeToFit];
    [downloadBtn2 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn2 addTarget:self action:@selector(zip2) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downloadBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn3 setTitle:@"3.解压" forState:UIControlStateNormal];
    [downloadBtn3 sizeToFit];
    [downloadBtn3 setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [downloadBtn3 addTarget:self action:@selector(unzip) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn1.top = 10;
    downloadBtn1.centerX = self.view.centerX;
    
    downloadBtn2.top = 60;
    downloadBtn2.centerX = self.view.centerX;
    
    downloadBtn3.top = 110;
    downloadBtn3.centerX = self.view.centerX;
    
    [self.view addSubview:downloadBtn1];
    [self.view addSubview:downloadBtn2];
    [self.view addSubview:downloadBtn3];

    
}
#pragma 创建文件夹
- (BOOL)creatDir:(NSString *)path{
    if (path.length==0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = YES;
    BOOL isExist = [fileManager fileExistsAtPath:path];
    if (isExist==NO) {
        NSError *error;
        if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            isSuccess = NO;
            NSLog(@"creat Directory Failed:%@",[error localizedDescription]);
        }
    }
    return isSuccess;
}
@end
