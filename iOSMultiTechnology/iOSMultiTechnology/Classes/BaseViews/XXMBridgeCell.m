//
//  XXMBridgeCell.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "XXMBridgeCell.h"
@interface XXMBridgeCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation XXMBridgeCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    XXMBridgeCell *cell = [tableView dequeueReusableCellWithIdentifier:[self className]];
    if(cell == nil){
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self className]];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = (CGRect){15,0,self.frame.size.width -  30, self.frame.size.height};
    self.titleLabel.frame =frame;
}
- (void)setItem:(XXMBridgeModel *)item
{
    _item = item;
    self.titleLabel.text = item.title;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

@end
