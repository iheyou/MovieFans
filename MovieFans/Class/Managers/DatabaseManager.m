//
//  DatabaseManager.m
//  MovieFans
//
//  Created by hy on 16/2/13.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDB.h"

@implementation DatabaseManager

{
    FMDatabase * _db;
}

+ (DatabaseManager *)sharedManager
{
    static dispatch_once_t onceToken;
    static DatabaseManager * globalManager = nil;
    dispatch_once(&onceToken, ^{
        if (!globalManager) {
            globalManager = [[DatabaseManager alloc] init];
        }
    });
    return globalManager;
}

// 重写初始化方法
- (instancetype)init
{
    if (self = [super init]) {
        [self initDB];
    }
    return self;
}

// 初始化数据库
- (void)initDB
{
    if (!_db) {
        // 将数据库文件放入沙盒路径下的Documents中
        NSString * dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/limitfree.db"];
        // 创建数据库管理对象
        _db = [[FMDatabase alloc] initWithPath:dbPath];
    }
    // 打开数据库
    if ([_db open]) {
        // 创建数据库表
        [_db executeUpdate:@"create TABLE if not exists collection (appId text primary key, appName text, appImage text);"];
    }
    else {
        NSLog(@"打开数据失败");
    }
}

- (BOOL)isExistsWithAppId:(NSString *)appId
{
    // 从数据库查询对应appid的数据
    FMResultSet * rs = [_db executeQuery:@"select * from collection where appId=?", appId];
    // 判断查询的数据是否存在
    if ([rs next]) {
        return YES;
    }
    else {
        return NO;
    }
}

// 插入数据
- (BOOL)insertCollectionTableModel:(CollectionTableModel *)model
{
    // 判断是否已有数据
    if ([self isExistsWithAppId:model.appId]) {
        // 更新已存在的数据
        // SQL是不区分大小写的
        BOOL isSuccess = [_db executeUpdate:@"update collection SET appName=?, appImage=? where appId=?", model.appName, model.appImage, model.appId];
        return isSuccess;
    }
    else {
        BOOL isSuccess = [_db executeUpdate:@"insert into collection values(?, ?, ?)", model.appId, model.appName, model.appImage];
        return isSuccess;
    }
}

- (NSArray *)getAllCollection
{
    NSMutableArray * colletionModels = [NSMutableArray array];
    // 获取collection表中所有数据
    FMResultSet * rs = [_db executeQuery:@"select * from collection"];
    // 遍历结果集
    while ([rs next]) {
        // 创建模型数据
        CollectionTableModel * model = [[CollectionTableModel alloc] init];
        model.appId = [rs stringForColumn:@"appId"];
        model.appName = [rs stringForColumn:@"appName"];
        model.appImage = [rs stringForColumn:@"appImage"];
        [colletionModels addObject:model];
    }
    return [colletionModels copy];
}


- (BOOL)deleteColletionTableModel:(CollectionTableModel *)model
{
    if ([self isExistsWithAppId:model.appId]) {
        BOOL isSuccess = [_db executeUpdate:@"DELETE FROM collection where appId=?", model.appId];
        return isSuccess;
    }
    else {
        return NO;
    }
}


@end
