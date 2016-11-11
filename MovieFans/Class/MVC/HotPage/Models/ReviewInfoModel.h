//
//  ReviewInfoModel.h
//  MovieFans
//
//  Created by hy on 16/1/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import <MJExtension.h>
@class MovieDetailUser;

@interface ReviewInfoModel : BaseModel


@property (nonatomic, assign) NSInteger attitudes_count;

@property (nonatomic, copy) NSString *large_pic;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *badge;

@property (nonatomic, assign) NSInteger comments_count;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, strong) NSArray *large_pics;

@property (nonatomic, assign) NSInteger reposts_count;

@property (nonatomic, assign) NSInteger reads_count;

@property (nonatomic, strong) NSArray<NSString *> *small_pic;

@property (nonatomic, copy) NSString *card_type;

@property (nonatomic, copy) NSString *film_id;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, strong) MovieDetailUser *user;

@property (nonatomic, strong) NSArray *topic_tag;

@property (nonatomic, copy) NSString *longblog_objectid;

@property (nonatomic, copy) NSString *poster_url;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *film_poster;

@property (nonatomic, assign) NSInteger created_at;

@property (nonatomic, copy) NSString *film_name;

@property (nonatomic, strong) NSArray *html_list;

@end

@interface MovieDetailUser : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *avatar_large;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL verified;

@property (nonatomic, assign) NSInteger verified_type;

@end

