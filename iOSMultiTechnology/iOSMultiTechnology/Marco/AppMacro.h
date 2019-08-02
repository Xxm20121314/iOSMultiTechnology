//
//  AppMacro.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h
#pragma mark - 系统和设备属性
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#pragma mark - 项目属性
#define kAPPIdentifier [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define kBuildVerson  [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kBUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#pragma mark - 全局唯一
#define kWindow ([UIApplication sharedApplication].keyWindow)
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#pragma mark - 文件位置
// 获取Document目录
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
// 获取Library目录
#define kLibraryPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
// 获取Caches目录
#define kCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
// 获取Preferences目录,通常情况下，Preferences有系统维护，所以我们很少去操作它。
#define kPreferPath [kLibraryPath stringByAppendingPathComponent:@"Preferences"]
// 获取tmp目录
#define kTmpPath = NSTemporaryDirectory()

#define kUserDefault  [NSUserDefaults standardUserDefaults]

#pragma mark - 工具宏
#define kWeakSelf __weak typeof(self) weakSelf = self;

#pragma mark - Release禁止输出日志
#ifdef __OPTIMIZE__
#define NSLog(...)
#endif
#endif /* AppMacro_h */
