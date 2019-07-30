//
//  Foundation+Log.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/29.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//  重写NSDictionary和NSArray的输出方法 (中文乱码)

#import <Foundation/Foundation.h>
@implementation NSDictionary (Log)
#ifdef DEBUG
//重写系统的方法控制输出 indent 缩进
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *mStr = [NSMutableString string];
    NSMutableString *tabStr = [NSMutableString stringWithString:@""];
    for (int i = 0; i < level; i++) {
        [tabStr appendString:@"\t"];
    }
    [mStr appendString:@"{\n"];
    
    NSArray *allKey = self.allKeys;
    for (int i = 0; i < allKey.count; i++) {
        id value = self[allKey[i]];
        NSString *lastSymbol = (allKey.count == i + 1) ? @"":@",";
        if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
            [mStr appendFormat:@"\t%@%@ = %@%@\n",tabStr,allKey[i],[value descriptionWithLocale:locale indent:level + 1],lastSymbol];
        } else {
            [mStr appendFormat:@"\t%@%@ = %@%@\n",tabStr,allKey[i],value,lastSymbol];
        }
    }
    [mStr appendFormat:@"%@}",tabStr];
    return mStr;
}
@end
@implementation NSArray (Log)
//重写系统的方法控制输出 indent 缩进
-(NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *mStr = [NSMutableString string];
    NSMutableString *tabStr = [NSMutableString stringWithString:@""];
    for (int i = 0; i < level; i++) {
        [tabStr appendString:@"\t"];
    }
    [mStr appendString:@"[\n"];
    for (int i = 0; i < self.count; i++) {
        NSString *lastSymbol = (self.count == i + 1) ? @"":@",";
        id value = self[i];
        if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
            [mStr appendFormat:@"\t%@%@%@\n",tabStr,[value descriptionWithLocale:locale indent:level + 1],lastSymbol];
        } else {
            [mStr appendFormat:@"\t%@%@%@\n",tabStr,value,lastSymbol];
        }
    }
    [mStr appendFormat:@"%@]",tabStr];
    return mStr;
}
#endif
@end

