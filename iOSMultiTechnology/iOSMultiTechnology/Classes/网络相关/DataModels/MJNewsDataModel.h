//
//  MJNewsDataModel.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJNewsSubDataModel;
@interface MJNewsDataModel : NSObject

@property (nonatomic, assign) NSInteger stat;

@property (nonatomic, strong) NSArray <MJNewsSubDataModel*>*newsLists;

@end
@interface MJNewsSubDataModel : NSObject

//@property (nonatomic, assign) NSInteger ID;

@property (nonatomic,   copy) NSString *uniquekey;

@property (nonatomic,   copy) NSString *title;

@property (nonatomic,   copy) NSString *date;

@property (nonatomic,   copy) NSString *category;

@property (nonatomic,   copy) NSString *author_name;

@property (nonatomic,   copy) NSString *url;

@property (nonatomic,   copy) NSString *thumbnail_pic_s;

@property (nonatomic,   copy) NSString *thumbnail_pic_s02;

@property (nonatomic,   copy) NSString *thumbnail_pic_s03;

@end

