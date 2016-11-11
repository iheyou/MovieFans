//
//  HYComentsModel.h
//  MovieFans
//
//  Created by hy on 2016/10/14.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CommentsUser;

@interface HYCommentsModel : NSObject

@property (nonatomic, assign) NSInteger created_at;

@property (nonatomic, assign) NSInteger comment_id;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, strong) CommentsUser *user;

@end

@interface CommentsUser : NSObject

@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *avatar_large;

@end
