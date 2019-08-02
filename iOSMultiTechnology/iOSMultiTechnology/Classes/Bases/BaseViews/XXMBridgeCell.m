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
@property (nonatomic, strong) UILabel *subLabel;
/** 右箭头*/
@property (nonatomic, strong) UIImageView *arrowImageV;
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
        [self.contentView addSubview:self.arrowImageV];
        [self.contentView addSubview:self.subLabel];

        CGFloat padding = 15;
        CGFloat cellHeight = [XXMBridgeCell defaultHeight];
        self.titleLabel.left = padding;
        self.titleLabel.top = 0;
        self.titleLabel.height = cellHeight;
        self.titleLabel.width = (ScreenWidth - padding * 2) * 0.5;
        
        self.arrowImageV.left = ScreenWidth - self.arrowImageV.width - padding;
        self.arrowImageV.centerY = self.titleLabel.centerY;
        
        self.subLabel.left = self.titleLabel.right +  5;
        self.subLabel.width = self.arrowImageV.left - self.subLabel.left -5;
        self.subLabel.height = cellHeight;
        
    }
    return self;
}
- (void)setItem:(XXMBridgeModel *)item
{
    _item = item;
    self.titleLabel.text = item.title;
    self.subLabel.text = item.subTitle;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)subLabel
{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
        _subLabel.textColor = [UIColor grayColor];
        _subLabel.font = [UIFont systemFontOfSize:13];
        _subLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subLabel;
}
- (UIImageView *)arrowImageV
{
    if (!_arrowImageV) {
        _arrowImageV = [[UIImageView alloc] init];
        _arrowImageV.image = [UIImage imageNamed:@"BridgeArrowRight"];
        _arrowImageV.size = (CGSize){6,11.5};
    }
    return _arrowImageV;
}

@end
