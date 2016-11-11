//
//  HYComentsModel.m
//  MovieFans
//
//  Created by hy on 2016/10/14.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYCommentsModel.h"

@implementation HYCommentsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"comment_id" : @"id"
             };
}

@end

@implementation CommentsUser

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"user_id" : @"id"
             };
}

@end
