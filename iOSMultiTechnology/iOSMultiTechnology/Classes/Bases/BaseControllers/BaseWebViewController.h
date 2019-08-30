//
//  BaseWebViewController.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "BaseViewController.h"
@interface BaseWebViewController : BaseViewController

/**
 路径名称
 */
@property (nonatomic,  copy) NSString *urlString;

/** 资源名称*/
@property (nonatomic,   copy) NSString *sourceName;
@end

