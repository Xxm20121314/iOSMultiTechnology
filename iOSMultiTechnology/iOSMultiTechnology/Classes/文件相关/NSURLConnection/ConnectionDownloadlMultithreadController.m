//
//  ConnectionDownloadlMultithreadController.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/5.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "ConnectionDownloadlMultithreadController.h"

#import "pthread.h"
#import <MediaPlayer/MediaPlayer.h>

#define KBigMultiThreadFileName @"NSURLConnection_海贼王剧场版2009.mp4"

//比较大的资源
#define KDownloadURL @"https://vd2.bdstatic.com/mda-hktpwedv8tvr05qh/sc/mda-hktpwedv8tvr05qh.mp4?auth_key=1565027248-0-0-e1aff92c4923ceae83123549f329d8bf&bcevod_channel=searchbox_feed&pd=bjh&abtest=all"
//比较小的资源
//#define KDownloadURL @"https://vd2.bdstatic.com/mda-ikvg1pby3dt9srn5/sc/mda-ikvg1pby3dt9srn5.mp4?auth_key=1565027798-0-0-a80412693d14345dd203fcd2b029fa67&bcevod_channel=searchbox_feed&pd=bjh&abtest=alll"

@interface ConnectionDownloadlMultithreadController ()<NSURLConnectionDataDelegate>

/** （模拟用、一般有服务器提供）获取资源大小用*/
@property (nonatomic, strong) NSURLConnection *resoureCeconnection;

/**
  显示资源文件大小
 */
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;

/** 显示当前开启的线程数量 */
@property (weak, nonatomic) IBOutlet UILabel *stepperLabel;

/**  控制开启线程数量 */
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

/** 显示下载速度*/
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

/* 显示下载进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/** 用于存储请求缓存 */
@property (nonatomic, strong) NSMutableDictionary *cacheThreadDic;

/** 当前最大线程数量*/
@property (nonatomic, assign) NSInteger maxConThreadCount;

/** 文件句柄 */
@property (nonatomic,   copy) NSFileHandle *fileHandle;

/** 沙盒路径 */
@property (nonatomic, strong) NSString *fullPath;

/** 资源文件总大小 */
@property (nonatomic, assign) NSInteger totalSize;

/** 当前资源下载已经大小 */
@property (nonatomic, assign) NSInteger currentSize;

/** （用于计算下载速度）用于存储未满1秒的而没有进行计算的字节大小*/
@property (nonatomic, assign) NSInteger unCalculateCacheSize;

/** 当前时间*/
@property (nonatomic, strong) NSDate *currentDate;

/** 开始时间*/
@property (nonatomic, strong) NSDate *startDate;

/**（用于计算下载速度） 用于存储未满1秒而没有进行计算的时间大小*/
@property (nonatomic, assign) NSTimeInterval unCalculateCacehTime;

/** 读写锁 */
@property (nonatomic, assign) pthread_rwlock_t  rwlock_t;

@end

@implementation ConnectionDownloadlMultithreadController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.unCalculateCacehTime = 0;
        self.unCalculateCacheSize = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化 读写锁
    pthread_rwlock_init(&_rwlock_t, NULL);
    // 默认线程数据
    self.stepper.value = 5;
    // 配置stepper
    [self configStepper];
    // 获取资源大小
    [self getResoureSize];
}
- (void)dealloc
{
    // 销毁读写锁
    pthread_rwlock_destroy(&_rwlock_t);
}
#pragma mark - 获取资源大小
-(void)getResoureSize
{
    //1.创建url
    NSURL *url = [NSURL URLWithString:KDownloadURL];
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
    [connect start];
    self.resoureCeconnection = connect;
}
/** 取消获取资源请求*/
- (void)cancelResoureImmediately
{
    if (!self.resoureCeconnection) {
        return;
    }
    [self.resoureCeconnection cancel];
    self.resoureCeconnection = nil;
    NSLog(@"%s",__func__);
}
- (IBAction)play:(UIButton *)sender
{
    if (!self.startDate) {
        NSLog(@"请先下载");
        return;
    }
    // 1.获取文件地址
    NSString *fullPath = [kCachesDownloadPath stringByAppendingPathComponent:KBigMultiThreadFileName];
    // 2.创建播放url
    NSURL *url = [[NSURL alloc] initFileURLWithPath:fullPath];
    //3.创建播放控制器
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    //4.弹出控制器
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma 设置最大线程数量
- (void)configStepper
{
    self.maxConThreadCount = self.stepper.value;
    self.stepperLabel.text = [NSString stringWithFormat:@"%@",@(self.maxConThreadCount)];
}
#pragma mark - 下载
- (IBAction)download:(UIButton *)sender
{
    [self.cacheThreadDic removeAllObjects];
    //计算平均大小 （总字节 - 线程数量）/ （线程数量）
    NSInteger averageLength = (self.totalSize - self.maxConThreadCount ) / self.maxConThreadCount;
//    //取余数
//    NSInteger remainderLength = (self.totalSize -self.maxConThreadCount ) % self.maxConThreadCount;
//    NSLog(@"最后一个需要加补充:%zd字节",remainderLength);
    // 计算range 位置
    __block NSInteger tmpPostion = 0;
    kWeakSelf
    for (int i = 0; i < self.maxConThreadCount; i++) {
        NSString *rangeValue = nil;
        if (i == self.maxConThreadCount - 1) {
            rangeValue = [NSString stringWithFormat:@"%@-",@(tmpPostion)];
        }else{
            
            rangeValue = [NSString stringWithFormat:@"%@-%@",@(tmpPostion),@(tmpPostion + averageLength)];
        }
        tmpPostion += (averageLength + 1);
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_async(queue, ^{
            NSURL *url = [NSURL URLWithString:KDownloadURL];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            /**
                设置下载文件的某一部分
                只要设置HTTP请求头的Range属性, 就可以实现从指定位置开始下载
                表示头500个字节：Range: bytes=0-499
                表示第二个500字节：Range: bytes=500-999
                表示最后500个字节：Range: bytes=-500
                表示500字节以后的范围：Range: bytes=500-
             */

            NSString *range = [NSString stringWithFormat:@"bytes=%@",rangeValue];
            [request setValue:range forHTTPHeaderField:@"Range"];
            NSLog(@"range:%@",range);
            //发送请求
            NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
            [connect setDelegateQueue:[[NSOperationQueue alloc] init]];
            [connect start];
            //缓存请求
            NSDictionary *dic = @{@"rangeValue":rangeValue,
                                  @"connect":connect,
                                  @"cacheSize":@(0)
                                  };
            NSString *md5 = [NSString stringWithFormat:@"%p",connect];
            [weakSelf.cacheThreadDic setObject:dic forKey:md5];
            NSLog(@"%@",[NSThread currentThread]);
        });
    }
}
#pragma mark - 设置线程最大数量
- (IBAction)stepperChanged:(UIStepper *)sender
{
    [self configStepper];
}

#pragma mark - 时间格式转化
- (NSString*)downloadTime:(NSTimeInterval)timeInterval
{
    NSInteger days = (int)(timeInterval/(3600*24));
    NSInteger hours = (int)((timeInterval-days*24*3600)/3600);
    NSInteger minute = (int)(timeInterval-days*24*3600-hours*3600)/60;
    NSInteger second = timeInterval - days*24*3600 - hours*3600 - minute*60;
    
    NSInteger showDay = days*24+hours;
    NSString *strTime = @"";
    if (showDay>10) {
        strTime = [NSString stringWithFormat:@"%@:%02zd:%02zd",@(days*24+hours),minute, second];
    }else{
        strTime = [NSString stringWithFormat:@"%02zd:%02zd:%02zd",(days*24+hours),minute, second];
    }
    return strTime;
}
#pragma mark - NSURLConnectionDataDelegate
//当接收到服务器响应的时候调用，该方法只会调用一次
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s",__func__);
    // 获取资源大小）
    if (connection == self.resoureCeconnection) {
//        NSLog(@"suggestedFilename:%@",response.suggestedFilename);
        self.totalSize = response.expectedContentLength;
        self.fileSizeLabel.text = [NSString stringWithFormat:@"约%@",[NSString formatByteCount:self.totalSize]];
        [self cancelResoureImmediately];
        return;
    }
}
//当接收到服务器返回的数据时会调用
//该方法可能会被调用多次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    /** 加锁 */
    pthread_rwlock_wrlock(&_rwlock_t);
    // 取出储请求缓存 connection 对应的内容
    __block NSURLConnection *con = nil;
    __block NSString *rangeValue = nil;
    __block NSInteger cacheSize = 0;
    // 找到对应数据
    [self.cacheThreadDic.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if( [obj[@"connect"] isEqual:connection]){
            con = connection;
            rangeValue = obj[@"rangeValue"];
            cacheSize = [obj[@"cacheSize"] integerValue];
            *stop = YES;
        }
    }];
    // 找了
    if (con) {
        // 取出原始位置
        NSInteger orgin = [[[rangeValue componentsSeparatedByString:@"-"] firstObject] integerValue];
    
        // offset = 原始位置 + 已缓存的大小
        NSInteger offset = orgin + cacheSize;
        
        //移动文件句柄移到指定位置
        [self.fileHandle seekToFileOffset:offset];
        
        // 更新缓存进度
        cacheSize += data.length;
        NSString *md5 = [NSString stringWithFormat:@"%p",connection];
        NSDictionary *dic = @{@"rangeValue":rangeValue,
                              @"connect":con,
                              @"cacheSize":@(cacheSize)
                              };
        [self.cacheThreadDic setObject:dic forKey:md5];
        
        // 写入数据
        [self.fileHandle writeData:data];

        // 获得进度
        self.currentSize += data.length;
        
        // 显示进度=已经下载/文件的总大小
        NSLog(@"%f",1.0 *  self.currentSize / self.totalSize);
        NSDate *date = [NSDate date];
        // 缓存未计算的字节大小和时间
        NSTimeInterval time = 0;
        if (self.currentDate) {
            time = [date timeIntervalSinceDate:self.currentDate];
        }else{
            // 第一次 缓存最开始下载的时间
            self.startDate = date;
        }
        self.unCalculateCacehTime += time;
        self.unCalculateCacheSize += data.length;

        // 计算速度
        __weak NSString *speedVaule = nil;
        if (self.unCalculateCacehTime >= 1.0) {
             CGFloat speed = 1.0 * self.unCalculateCacheSize / self.unCalculateCacehTime;
            // 把速度转成KB或M
             speedVaule = [NSString formatByteCount:speed];
            //清空已经计算的缓存size
            self.unCalculateCacehTime = 0;
            self.unCalculateCacheSize = 0;
        }
        // 临时时间
        self.currentDate = date;
        kWeakSelf
        // 更新主线程UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 进度条
            weakSelf.progressView.progress = 1.0 *  weakSelf.currentSize / weakSelf.totalSize;
            //下载速度
            if (speedVaule) {
                weakSelf.speedLabel.text =  [NSString stringWithFormat:@"%@/s",speedVaule];
            }
        });
    }
    /** 解锁 */
    pthread_rwlock_unlock(&_rwlock_t);

}
//当请求失败的时候调用该方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"请求失败, 当前未完成的请求%@",self.cacheThreadDic.allKeys);
}

//当网络请求结束之后调用
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s",__func__);
    NSString *md5 = [NSString stringWithFormat:@"%p",connection];
    // 完成一次 删除缓存成功的请求
    [self.cacheThreadDic removeObjectForKey:md5];
    if (self.cacheThreadDic.count) {
        return;
    }
    //1.关闭文件句柄
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
    //计算 整体下载耗时
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSinceDate:self.startDate];
    //计算 整体下载速度
    CGFloat speed = 1.0 * self.totalSize / time;

    kWeakSelf
    // 更新主线程UI
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.speedLabel.text =  [NSString stringWithFormat:@"下载完成:总体耗时%@平均下载速度%@/s",[weakSelf downloadTime:time] ,[NSString formatByteCount:speed]];
    });
    NSLog(@"下载完成地址：\n%@",self.fullPath);

}
#pragma mark - Getters
- (NSMutableDictionary *)cacheThreadDic
{
    if (!_cacheThreadDic) {
        _cacheThreadDic = [NSMutableDictionary new];
    }
    return _cacheThreadDic;
}
- (NSString *)fullPath
{
    if (!_fullPath) {
        //沙盒
        _fullPath = [kCachesDownloadPath stringByAppendingPathComponent:KBigMultiThreadFileName];
        NSLog(@"%@",self.fullPath);
        //创建一个空的文件
        [[NSFileManager defaultManager] createFileAtPath:_fullPath contents:nil attributes:nil];
    }
    return _fullPath;
}
- (NSFileHandle *)fileHandle
{
    if (!_fileHandle) {
        //创建文件句柄(指针)
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
    }
    return _fileHandle;
}

@end
