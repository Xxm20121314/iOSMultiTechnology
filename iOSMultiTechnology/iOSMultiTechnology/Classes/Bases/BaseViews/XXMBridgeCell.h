//
//  XXMBridgeCell.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "BaseTableViewCell.h"

#import "XXMBridgeModel.h"

@interface XXMBridgeCell : BaseTableViewCell
@property (nonatomic, strong) XXMBridgeModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
