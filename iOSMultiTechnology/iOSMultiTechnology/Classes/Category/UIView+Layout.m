//
//  UIView+Layout.m
//  iOSProject
//
//  Created by 许小明 on 2019/7/8.
//  Copyright © 2019 许小明. All rights reserved.
//
/*
 作用：宽高取绝对值 ，自动调整位置
 CGRect CGRectStandardize(CGRect rect);
 //CGRectMake(1, 1, 1, 1)返回(1, 1, 1, 1)
 //CGRectMake(1, 1, 1, -1)返回(1, 0, 1, 1)
 //CGRectMake(1, 1, -1, 1)返回(0, 1, 1, 1)
 //CGRectMake(1, 1, -1, -1)返回(0, 0, 1, 1)
 */

#import "UIView+Layout.h"

@implementation UIView (Layout)
#pragma mark - top
- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
- (CGFloat)top
{
    return self.frame.origin.y;
}
#pragma mark - left
- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
- (CGFloat)left
{
    return self.frame.origin.x;
}
#pragma mark - bottom
- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
#pragma mark - right
- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}
#pragma mark - size
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}
#pragma mark - width
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
 - (CGFloat)width
{
    return self.frame.size.width;
}
#pragma mark - height
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
#pragma mark - origin
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin
{
    return self.frame.origin;
}
#pragma mark - centerX
- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}
- (CGFloat)centerX
{
    return self.center.x;
}

#pragma mark - centerY
- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}
- (CGFloat)centerY
{
    return self.center.y;
}
@end
