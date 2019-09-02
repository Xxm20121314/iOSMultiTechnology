//
//  BaseRequest.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^Progress) (float progress);
typedef void (^BaseRequestComplete)(id responseObject,NSError *error);

@interface BaseRequest : NSObject
/** GET请求 */
+(NSURLSessionDataTask*)GET:(NSString *)URLString parameters:(NSDictionary *)parameters complete:(BaseRequestComplete)complete;
/** POST请求 */
+(NSURLSessionDataTask*)POST:(NSString *)URLString parameters:(NSDictionary *)parameters complete:(BaseRequestComplete)complete; 
/** 下载请求 */
+(NSURLSessionDownloadTask*)Download:(NSString *)URLString parameters:(NSDictionary *)parameters savePath:(NSString*)savePath progress:(Progress)progress complete:(BaseRequestComplete)complete;
/** 上传文件 文件路径*/
+ (NSURLSessionDataTask*)UploadFile:(NSString*)URLString parameters:(NSDictionary *)parameters destPath:(NSString*)destPath progress:(Progress)progress complete:(BaseRequestComplete)complete;
/** 上传图片请求 文件二进制*/
+ (NSURLSessionDataTask*)UploadImage:(NSString*)URLString parameters:(NSDictionary *)parameters imageData:(NSData*)imageData progress:(Progress)progress complete:(BaseRequestComplete)complete;
@end

