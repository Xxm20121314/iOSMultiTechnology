//
//  BaseTableViewCell.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseTableViewCell : UITableViewCell
/// 取类名
+ (NSString *)className;
/// 返回默认高度，子类重写
+ (CGFloat)defaultHeight;
@end

