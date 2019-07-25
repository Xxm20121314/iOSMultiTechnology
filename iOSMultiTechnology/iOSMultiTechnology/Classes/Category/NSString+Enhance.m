//
//  NSString+Enhance.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSString+Enhance.h"

@implementation NSString (Enhance)
+ (NSString *)paramsStringWithParams:(NSDictionary *)params
{
    NSMutableString *paramsString = [NSMutableString string];
    if (params.allKeys.count > 0){
        for (NSString *key in params.allKeys){
            NSString *value = [params objectForKey:key];
            [paramsString appendFormat:@"&%@=%@", key, value];
        }
        [paramsString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return paramsString;
}
+ (NSString*)toString:(NSObject *)object {
    return [NSString stringWithFormat:@"%@", object == nil || object == [NSNull null] ? @"" : object];
}
@end
