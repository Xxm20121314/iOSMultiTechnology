//
//  FileManager.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "FileManager.h"

@interface FileManager ()
/** 文件管理者*/
@property (nonatomic, strong) NSFileManager *fileManager;
@end
@implementation FileManager
+ (instancetype)sharedManager {
    static FileManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[FileManager alloc] init];
        _sharedManager.fileManager = [NSFileManager defaultManager];
    });
    return _sharedManager;
}
/**创建目录*/
- (BOOL)creatDirectoryAtPath:(NSString*)path
{
   return [self createDirectoryAtPath:path intermediateDirectories:YES attributes:nil];
}
- (BOOL)createDirectoryAtPath:(NSString *)path intermediateDirectories:(BOOL)createIntermediates attributes:(nullable NSDictionary<NSFileAttributeKey, id> *)attributes
{
    if (path.length==0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = YES;
    BOOL isExist = [fileManager fileExistsAtPath:path];
    if (isExist==NO) {
        NSError *error;
        isSuccess = [fileManager createDirectoryAtPath:path withIntermediateDirectories:createIntermediates attributes:attributes error:&error];
        if (error) {
            NSLog(@"creat Directory Failed:%@",[error localizedDescription]);
        }
    }
    return isSuccess;
}
/**
 文件属性
 */
- (NSDictionary*)fileAttriutesAtPath:(NSString*)path
{
    NSError *error;
    NSDictionary *info = [self.fileManager attributesOfItemAtPath:path error:&error];
    if (error) {
        NSLog(@"%s\n error:%@",__func__, error);
        return nil;
    }
    return info;
}
/*删除*/
- (BOOL)removeAtURL:(NSURL *)url
{
    return [self.fileManager removeItemAtURL:url error:nil];

}
-(BOOL)removeAtPath:(NSString*)path
{
   return [self.fileManager removeItemAtPath:path error:nil];
}
/** 获取指定目录下的文件和目录，不遍历其下的子目录*/
- (NSArray*)enumeratorAtPath1:(NSString*)path
{
    return  [self.fileManager contentsOfDirectoryAtPath:path error:nil];

}
/** 枚举器
 遍历指定目录下的文件和子目录，遍历其下的子目录*/
- (NSArray*)enumeratorAtPath2:(NSString*)path
{
    NSMutableArray *array = [NSMutableArray new];
    NSDirectoryEnumerator *directoryEnum = [self.fileManager enumeratorAtPath:path];
    NSString *tempPath;
    while (tempPath = [directoryEnum nextObject]) {
        [array addObject:tempPath];
    }
    return array;
}
/**
 遍历指定目录下的文件和子目录，遍历其下的子目录
 */
- (NSArray*)enumeratorAtPath3:(NSString*)path
{
   return [self.fileManager subpathsAtPath:path];
}
/**
 遍历指定目录下的文件和子目录，遍历其下的子目录
 */
- (NSArray*)enumeratorAtPath4:(NSString*)path
{
    return [self.fileManager subpathsOfDirectoryAtPath:path error:nil];
}


@end
