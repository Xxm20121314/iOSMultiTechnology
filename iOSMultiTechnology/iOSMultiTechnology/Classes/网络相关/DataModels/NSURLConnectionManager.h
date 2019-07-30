//
//  NSURLConnectionManager.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, RNSURLConnectionRequestType){
    NSURLConnectionTypRequestSync   = 1 << 0,
    NSURLConnectionTypeRequestAsync   = 1 << 1,
    NSURLConnectionTypeRequestDelegate  = 1 << 2,
};
typedef void (^CompleteBlock)(id jsonObject,NSError *error);
typedef void (^DataBlock)(NSData *resultData,NSError *error);

@interface NSURLConnectionManager : NSObject

/**
 返回id 数据
 */
- (void)GET:(RNSURLConnectionRequestType)type url:(NSString *)url params:(NSDictionary *)params  complete:(CompleteBlock)complete;
- (void)POST:(RNSURLConnectionRequestType)type url:(NSString *)url params:(NSDictionary *)params  complete:(CompleteBlock)complete;


/**
  返回NSData 数据
 */
- (void)GET:(NSString *)url params:(NSDictionary *)params  data:(DataBlock)data;
@end

