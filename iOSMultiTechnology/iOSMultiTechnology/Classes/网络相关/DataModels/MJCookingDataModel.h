//
//  MJCookingDataModel.h
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/30.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJCookingSubDataModel;
@interface MJCookingDataModel : NSObject

/** 子菜 列表*/
@property (nonatomic, strong) NSArray <MJCookingSubDataModel*>*list;

/** 菜名*/
@property (nonatomic,   copy) NSString *name;

/** 上一级id*/
@property (nonatomic, assign) NSInteger parentId;

@end

// 子菜名 model
@interface MJCookingSubDataModel : NSObject

/** id*/
@property (nonatomic, assign) NSInteger cookingId;

/** 菜名*/
@property (nonatomic,   copy) NSString *name;

/** 上一级id*/
@property (nonatomic, assign) NSInteger parentId;

@end

