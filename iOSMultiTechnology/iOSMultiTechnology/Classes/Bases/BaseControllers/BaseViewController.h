//
//  BaseViewController.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
/**
 桥接 目标参数
 */
@property (nonatomic, strong) NSDictionary *destParams;

//显示log数据
- (void)showTipStr:(NSString*)string;
@end

NS_ASSUME_NONNULL_END
