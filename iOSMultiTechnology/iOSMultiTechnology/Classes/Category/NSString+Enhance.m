//
//  NSString+Enhance.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSString+Enhance.h"
#import <MobileCoreServices/MobileCoreServices.h>
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
#pragma mark - 中文转码处理
+ (NSString*)GETCNString:(NSString *)string
{
    return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark - b 转成 M 
+ (NSString*)formatByteCount:(long long)size
{
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}
/**
 注意：需要依赖于框架MobileCoreServices
 */
+ (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,  (__bridge CFStringRef _Nonnull)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        //application/octet-stream 任意的二进制数据类型
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}
@end
