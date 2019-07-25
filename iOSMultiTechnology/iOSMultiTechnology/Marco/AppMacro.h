//
//  AppMacro.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define kWeakSelf __weak typeof(self) weakSelf = self;
#pragma mark - Release禁止输出日志
#ifdef __OPTIMIZE__
#define NSLog(...)
#endif
#endif /* AppMacro_h */
