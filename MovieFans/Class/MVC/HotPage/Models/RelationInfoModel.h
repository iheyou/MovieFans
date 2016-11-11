//
//  RelationInfoModel.h
//  MovieFans
//
//  Created by hy on 16/1/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import <MJExtension.h>

@class Directors;
@interface RelationInfoModel : BaseModel


@property (nonatomic, assign) NSInteger released;

@property (nonatomic, copy) NSString *intro;

@property (nonatomic, copy) NSString *film_id;

@property (nonatomic, copy) NSString *video_url;

@property (nonatomic, assign) NSInteger wanttosee;

@property (nonatomic, strong) NSArray<Directors *> *directors;

@property (nonatomic, assign) NSInteger is_wanttosee;

@property (nonatomic, copy) NSString *release_time;

@property (nonatomic, assign) NSInteger can_wanttosee;

@property (nonatomic, copy) NSString *large_poster_url;

@property (nonatomic, copy) NSString *card_type;

@property (nonatomic, copy) NSString *item_type;

@property (nonatomic, assign) NSInteger score_count;

@property (nonatomic, copy) NSString *poster_url;

@property (nonatomic, copy) NSString *release_date;

@property (nonatomic, assign) NSInteger user_score;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *genre;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;


@end
@interface Directors : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger artist_id;

@property (nonatomic, assign) NSInteger sinaid;

@end

