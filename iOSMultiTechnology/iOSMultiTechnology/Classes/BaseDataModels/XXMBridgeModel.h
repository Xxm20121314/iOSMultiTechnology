//
//  XXMBridgeModel.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BridgeBlock)(void);
@interface XXMBridgeModel : NSObject

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 桥接 类
 */
@property (nonatomic, assign) Class bridgeClass;

/**
 桥接 目标参数
 */
@property (nonatomic, strong) NSDictionary *destParams;
/**
  如果block 有值 忽略linkClass‘
 */
@property (nonatomic, copy) BridgeBlock block;
@end

