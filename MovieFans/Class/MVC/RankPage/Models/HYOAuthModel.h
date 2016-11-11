//
//  HYOAuthModel.h
//  MovieFans
//
//  Created by hy on 2016/10/18.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYOAuthModel : NSObject <NSCoding>

/** 授权令牌*/
@property (nonatomic, copy) NSString *access_token;

/** 过期时间离现在时间差值*/
@property (nonatomic, copy) NSString *expires_in;

/** 过期时间(已废弃)*/
@property (nonatomic, copy) NSString *remind_in;

/** 授权用户ID*/
@property (nonatomic, copy) NSString *uid;

/** 过期时间点*/
@property (nonatomic, strong) NSDate *expriresData;

@end
