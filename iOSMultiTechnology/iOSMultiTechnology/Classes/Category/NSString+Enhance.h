//
//  NSString+Enhance.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Enhance)
+ (NSString *)paramsStringWithParams:(NSDictionary *)paramsp;
+ (NSString *)toString:(NSObject *)object;
#pragma mark 
+ (NSString*)GETCNString:(NSString *)string;
/**b转成 M*/
+ (NSString*)formatByteCount:(long long)size;
@end

