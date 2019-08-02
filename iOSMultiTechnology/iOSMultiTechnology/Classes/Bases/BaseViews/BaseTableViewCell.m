//
//  BaseTableViewCell.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "BaseTableViewCell.h"
@implementation BaseTableViewCell

+ (NSString *)className
{
    return NSStringFromClass([self class]);
}

+ (CGFloat)defaultHeight
{
    return 44;
}
@end
