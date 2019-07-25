//
//  NSURLConnectionManager.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, NSURLConnectionGetType){
    NSURLConnectionTypeGetSync   = 1 << 0,
    NSURLConnectionTypeGetAsync   = 1 << 1,
    NSURLConnectionTypeGetDelegate  = 1 << 2,
};
@interface NSURLConnectionManager : NSObject

- (void)GET:(NSURLConnectionGetType)type url:(NSString *)url params:(NSDictionary *)params  complete:(void (^)(id jsonObject,NSError *error))complete;
- (void)POST;
@end

