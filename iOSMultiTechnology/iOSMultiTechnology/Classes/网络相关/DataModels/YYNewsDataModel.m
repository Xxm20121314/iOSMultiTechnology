//
//  YYNewsDataModel.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "YYNewsDataModel.h"

@implementation YYNewsDataModel
/**
 返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newsLists" : @"data"};
}
/**Model 包含其他 Model
 返回容器类中的所需要存放的数据类型
 */
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"newsLists" : [YYNewsSubDataModel class]};
}
@end

@implementation YYNewsSubDataModel

@end
