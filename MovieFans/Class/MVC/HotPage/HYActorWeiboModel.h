//
//  HYActorWeiboModel.h
//  MovieFans
//
//  Created by hy on 2016/10/9.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ActorWeiboUser;

@interface HYActorWeiboModel : NSObject

@property (nonatomic, assign) NSInteger created_at;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) ActorWeiboUser *user;
@property (nonatomic, strong) NSArray *large_pics;

@end

@interface ActorWeiboUser : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar_large;
@property (nonatomic, copy) NSString *artist_id;

@end
