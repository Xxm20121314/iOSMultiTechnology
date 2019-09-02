//
//  BaseRequest.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "BaseRequest.h"
#import "AFNetworkActivityIndicatorManager.h"
typedef  NS_OPTIONS(NSInteger, RequestType){
    RequestTypeGET   = 1 << 0,              //GET请求
    RequestTypePOST   = 1 << 1,             //POST请求
    RequestTypeDownload  = 1 << 2,          //下载请求
    RequestTypeUploadImage  = 1 << 3,       //上传图片请求
    RequestTypeUploadFile  =  1 << 4,       //上传文件请求
};
typedef  NS_OPTIONS(NSInteger, ErrorType){
    ErrorTypeNoNetwork = 1 << 0,     // 无网络
    ErrorTypeDataTypeError   = 1 << 1,    // 数据类型出错
    ErrorTypeFilePathNoFound   = 1 << 2,    // 文件路径出错
    ErrorTypeFilePathExtensionError   = 1 << 3,    // 文件路径拓展不一致
};
@implementation BaseRequest
/** GET请求 */
+(NSURLSessionDataTask*)GET:(NSString *)URLString parameters:(NSDictionary *)parameters complete:(BaseRequestComplete)complete
{
    return [self method:RequestTypeGET URL:URLString parameters:parameters target:nil name:nil fileName:nil progress:nil complete:complete];
}
/** POST请求 */
+(NSURLSessionDataTask*)POST:(NSString *)URLString parameters:(NSDictionary *)parameters complete:(BaseRequestComplete)complete
{
    return [self method:RequestTypePOST URL:URLString parameters:parameters target:nil name:nil fileName:nil progress:nil complete:complete];;
}
/** 下载请求 */
+(NSURLSessionDownloadTask*)Download:(NSString *)URLString parameters:(NSDictionary *)parameters savePath:(NSString*)savePath progress:(Progress)progress complete:(BaseRequestComplete)complete
{
    return [self method:RequestTypeDownload URL:URLString parameters:parameters target:savePath name:nil fileName:nil progress:progress complete:complete];
}
/** 上传图片请求 文件二进制*/
+ (NSURLSessionDataTask*)UploadImage:(NSString*)URLString parameters:(NSDictionary *)parameters imageData:(NSData*)imageData progress:(Progress)progress complete:(BaseRequestComplete)complete
{
    return [self method:RequestTypeUploadImage URL:URLString parameters:parameters target:imageData name:@"file" fileName:@"file.png" progress:progress complete:complete];
}
/** 上传文件 文件路径*/
+ (NSURLSessionDataTask*)UploadFile:(NSString*)URLString parameters:(NSDictionary *)parameters destPath:(NSString*)destPath progress:(Progress)progress complete:(BaseRequestComplete)complete
{
    return [self method:RequestTypeUploadFile URL:URLString parameters:parameters target:destPath name:@"" fileName:@"" progress:progress complete:complete];
}
/**base*/
+ (id)method:(RequestType)type URL:(NSString *)URLString parameters:(NSDictionary *)parameters target:(id)target name:(NSString*)name fileName:(NSString*)filename progress:(Progress)progress complete:(BaseRequestComplete)complete
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //默认是AFJSONRequestSerializer
//    manager.responseSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"application/json",@"text/plain",@"text/javascript",@"text/json",nil];

    //最终请求参数
    NSMutableDictionary *realParams = [NSMutableDictionary dictionaryWithDictionary:[self baseParams]];
    [realParams addEntriesFromDictionary:parameters];
    
    //打印请求地址
    [self printRequestURL:URLString parameters:parameters];
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        complete(nil,[self errorWithCode:ErrorTypeNoNetwork]);
        return nil;
    }
    // 开启网络指示器
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    //GET
    if (type == RequestTypeGET) {
        return [manager GET:URLString parameters:realParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            complete(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            complete(nil,error);
        }];
    }
    //POST
    if (type == RequestTypePOST) {
        return [manager POST:URLString parameters:realParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            complete(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            complete(nil,error);
        }];
    }
    //下载
    if (type == RequestTypeDownload) {
        //检查类型
        if (![target isKindOfClass:[NSString class]]) {
            complete(nil,[self errorWithCode:ErrorTypeDataTypeError]);
            return nil;
        }
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        NSError *error = nil;
        NSMutableURLRequest *request =[serializer requestWithMethod:@"GET" URLString:URLString parameters:realParams error:&error];
        if (error) {
            complete(nil,error);
            return nil;
        }
        NSURLSessionDownloadTask *downloadTask = [ manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            });
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return  [NSURL fileURLWithPath:target];;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            //路径拓展对比
            NSLog(@"filePath:%@",filePath.absoluteString);
            if (![[target pathExtension] isEqualToString:response.suggestedFilename.pathExtension]) {
                //路径拓展不一致删除下载文件
                [[FileManager sharedManager] removeAtURL:filePath];
                complete(nil,[self errorWithCode:ErrorTypeFilePathExtensionError]);
                return ;
            }
            if(error){
                complete(nil,error);
            }else{
                complete(target,nil);
            }
        }];
        // 5.执行Task
        [downloadTask resume];
        return downloadTask;
    }
    //上传图片
    if (type == RequestTypeUploadImage) {
        //检查类型
        if (![target isKindOfClass:[NSData class]]) {
            complete(nil,[self errorWithCode:ErrorTypeDataTypeError]);
            return nil;
        }

       return [manager POST:URLString parameters:realParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:target name:name fileName:filename mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            complete(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            complete(nil,error);
        }];
    }
    //上传文件
    if (type == RequestTypeUploadFile) {
        //检查类型
        if (![target isKindOfClass:[NSString class]]) {
            complete(nil,[self errorWithCode:ErrorTypeDataTypeError]);
            return nil;
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:target]) {
            complete(nil,[self errorWithCode:ErrorTypeFilePathNoFound]);
            return nil;
        }
        return [manager POST:URLString parameters:realParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:target] name:name fileName:filename mimeType:[NSString mimeTypeForFileAtPath:target] error:nil];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            complete(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            complete(nil,error);
        }];
    }
    return nil;

}
#pragma mark - 自定义错误类型
+ (NSError *)errorWithCode:(ErrorType)code{
    NSString * localizedDescription;
    switch (code) {
        case ErrorTypeNoNetwork:
            localizedDescription = @"似乎已断开与互联网的连接";
            break;
        case ErrorTypeDataTypeError:
            localizedDescription = @"数据类型错误";
            break;
        case ErrorTypeFilePathNoFound:
            localizedDescription = @"文件路径错误";
            break;
        case ErrorTypeFilePathExtensionError:
            localizedDescription = @"文件路径扩展不一致，请重新命名保存文件拓展名";
            break;
        default:
            localizedDescription = @"网络异常";
            break;
    }
    
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:localizedDescription forKey:NSLocalizedDescriptionKey];
    NSErrorDomain domain = @"An Error Has Occurred";
    NSError * aError = [NSError errorWithDomain:domain code:code userInfo:userInfo];
    return aError;
}
#pragma mark - 基础信息
+ (NSDictionary*)baseParams
{
//    NSDictionary *baseParams = @{@"deviceType" : @"iOS",
//                                 @"v" : kBuildVerson};
    NSDictionary *baseParams = @{};
    return baseParams;
}
#pragma mark 打印请求地址
+ (void)printRequestURL:(NSString*)address parameters:(NSDictionary*)parameters
{
    NSMutableDictionary *realParams = [NSMutableDictionary dictionaryWithDictionary:[self baseParams]];
    [realParams addEntriesFromDictionary:parameters];
    NSLog(@"\n发出请求：%@\n%@", [NSString stringWithFormat:@"%@?%@", address, [NSString paramsStringWithParams:realParams]], realParams);
}
@end
