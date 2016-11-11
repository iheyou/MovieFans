//
//  HotModel.h
//  MovieFans
//
//  Created by hy on 16/1/7.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import <MJExtension.h>

@interface HotModel : BaseModel


@property (nonatomic, copy) NSString *video_url;

@property (nonatomic, assign) NSInteger score_count;

@property (nonatomic, assign) NSInteger user_score;

@property (nonatomic, strong) NSArray *directors;

@property (nonatomic, assign) NSInteger is_wanttosee;

@property (nonatomic, copy) NSString *release_time;

@property (nonatomic, assign) NSInteger released;

@property (nonatomic, copy) NSString *intro;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *card_type;

@property (nonatomic, strong) NSArray *actors;

@property (nonatomic, assign) NSInteger can_wanttosee;

@property (nonatomic, copy) NSString *film_id;

@property (nonatomic, copy) NSString *large_poster_url;

@property (nonatomic, copy) NSString *release_date;

@property (nonatomic, copy) NSString *item_type;

@property (nonatomic, copy) NSString *poster_url;

@property (nonatomic, assign) NSInteger wanttosee;

@property (nonatomic, copy) NSString *genre;


@end
