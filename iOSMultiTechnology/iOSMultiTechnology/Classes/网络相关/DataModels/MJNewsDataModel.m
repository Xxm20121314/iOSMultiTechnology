//
//  MJNewsDataModel.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "MJNewsDataModel.h"
@implementation MJNewsDataModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"newsLists" : @"data"};
}
/**Model 包含其他 Model
 返回容器类中的所需要存放的数据类型
 */
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"newsLists" : [MJNewsSubDataModel class]};
}
@end

@implementation MJNewsSubDataModel

@end

