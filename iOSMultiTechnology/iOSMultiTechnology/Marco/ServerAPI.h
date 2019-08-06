//
//  ServerAPI.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/8/1.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#ifndef ServerAPI_h
#define ServerAPI_h

#define kServerAddress 0
#if (kServerAddress == 0)
#define kBaseUrl @"http://v.juhe.cn/"
#elif (kServerAddress == 1)
#define kBaseUrl @"http://192.186.11.21:60081/"
#endif

//微信精选列表 (AppKey：d51792ae54cb6fa161747ed7a08b781a)  不支持xml
#define  kAPIURL_weChat_choice_list [kBaseUrl stringByAppendingString:@"weixin/query"]
//新闻头条 (AppKey：6f32779a067f86e9818845e403ce1f25) 支持xml
#define  kAPIURL_news_toutiao_list [kBaseUrl stringByAppendingString:@"/toutiao/index"]

//上传语音获得返回路径
#define  kAPIURL_upload_image @"http://busapi.jiwu.com/base/uploadimage"

#endif /* ServerAPI_h */
