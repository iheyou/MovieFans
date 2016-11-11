//
//  HYOAuthTool.m
//  MovieFans
//
//  Created by hy on 2016/10/18.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYOAuthTool.h"

#define OAUTH_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"oauth.data"]

@implementation HYOAuthTool

+ (BOOL)saveWith:(HYOAuthModel *)model
{
    // user/xxx/ooo/Documents/oauth.data
    BOOL isSuc = NO;
    // 获取一个归档存储路径
    
    // 归档
    isSuc = [NSKeyedArchiver archiveRootObject:model toFile:OAUTH_PATH];
    
    return isSuc;
    
}


+ (HYOAuthModel *)fetch
{
    HYOAuthModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:OAUTH_PATH];
    
    if (model) {
        // 比较当前时间和过期时间点
        NSDate *nowDate = [NSDate date];
        
        // 如果过期就返回空
        if ([nowDate compare:model.expriresData] == NSOrderedDescending) {
            model = nil;
        }
    }
    return model;
}


@end
