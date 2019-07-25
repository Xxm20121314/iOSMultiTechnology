//
//  NSURLConnectionManager.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "NSURLConnectionManager.h"
@interface NSURLConnectionManager()
/** 注释 */
@property (nonatomic, strong) NSMutableData *resultData;
@property (nonatomic,   copy)NSString *GETURLstring;
@end
@implementation NSURLConnectionManager
#pragma mark - GET方法
- (void)GET:(NSURLConnectionGetType)type url:(NSString *)url params:(NSDictionary *)params complete:(void (^)(id, NSError *))complete
{
    /*
     请求:请求头(NSURLRequest默认包含)+请求体(GET没有)
     响应:响应头(真实类型--->NSHTTPURLResponse)+响应体(要解析的数据)
     协议+主机地址+接口名称+?+参数1&参数2&参数3
     */
    self.GETURLstring = [NSString stringWithFormat:@"%@?%@",url,[NSString paramsStringWithParams:params]];
    if (type & NSURLConnectionTypeGetSync) {
        // 方法1 同步
         [self GETSync];
        return;
    }
    if (type & NSURLConnectionTypeGetAsync) {
        // 方法2 异步
         [self GETAsync];
        return;
    }
    if (type & NSURLConnectionTypeGetDelegate) {
        // 方法3 代理
        [self GETDelegate];
        return;
    }
}
-(void)GETSync
{
    NSLog(@"GET同步请求地址: %@",self.GETURLstring);
    
}
-(void)GETAsync
{
    NSLog(@"GET异步请求地址: %@",self.GETURLstring);

}
- (void)GETDelegate
{
    NSLog(@"GET代理请求地址: %@",self.GETURLstring);

}
#pragma mark - POST方法
- (void)POST
{
    
}
-(NSMutableData *)resultData
{
    if (_resultData == nil) {
        _resultData = [NSMutableData data];
    }
    return _resultData;
}

@end
