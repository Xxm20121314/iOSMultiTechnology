//
//  FileManager.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileManager : NSObject
+ (instancetype)sharedManager;
/**
 创建目录
 */
- (BOOL)creatDirectoryAtPath:(NSString*)path;
- (BOOL)createDirectoryAtPath:(NSString *)path intermediateDirectories:(BOOL)createIntermediates attributes:( NSDictionary<NSFileAttributeKey, id> *)attributes;
/**
 文件属性
 */
- (NSDictionary*)fileAttriutesAtPath:(NSString*)path;

/**删除url*/
-(BOOL)removeAtURL:(NSURL*)url;
/**删除path*/
-(BOOL)removeAtPath:(NSString*)path;
/** 遍历目录 **/
/**
 获取指定目录下的文件和目录，不遍历其下的子目录
 */
- (NSArray*)enumeratorAtPath1:(NSString*)path;
/** 枚举器
 遍历指定目录下的文件和子目录，遍历其下的子目录
 */
- (NSArray*)enumeratorAtPath2:(NSString*)path;
/**
 遍历指定目录下的文件和子目录，遍历其下的子目录
 */
- (NSArray*)enumeratorAtPath3:(NSString*)path;
/**
 遍历指定目录下的文件和子目录，遍历其下的子目录
 */
- (NSArray*)enumeratorAtPath4:(NSString*)path;


@end

