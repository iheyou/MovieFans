//
//  DatabaseManager.h
//  MovieFans
//
//  Created by hy on 16/2/13.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionTableModel.h"


@interface DatabaseManager : NSObject

// 单例
+ (DatabaseManager *)sharedManager;

// 插入数据
- (BOOL)insertCollectionTableModel:(CollectionTableModel *) model;

// 判断数据库中是否存在对应数据
- (BOOL)isExistsWithAppId:(NSString *) appId;

// 获取所有的收藏数据
- (NSArray *)getAllCollection;

// 删除收藏数据
- (BOOL)deleteColletionTableModel:(CollectionTableModel *) model;

@end
