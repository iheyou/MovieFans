//
//  HYOAuthTool.h
//  MovieFans
//
//  Created by hy on 2016/10/18.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYOAuthModel.h"

@interface HYOAuthTool : NSObject

/** 存储授权信息*/
+ (BOOL) saveWith:(HYOAuthModel *)model;


/** 获取授权信息 ，如果过期或未获得授权就返回空，获取时需要判断*/
+ (HYOAuthModel *)fetch;

@end
