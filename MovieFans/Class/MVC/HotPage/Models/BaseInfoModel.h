//
//  BaseInfoModel.h
//  MovieFans
//
//  Created by hy on 16/1/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import <MJExtension.h>
@class Feature_Videos,Videos,List;
@interface BaseInfoModel : BaseModel


@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *onlinestatus;

@property (nonatomic, copy) NSString *film_id;

@property (nonatomic, assign) NSInteger review_count;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, strong) Videos *videos;

//@property (nonatomic, assign) BOOL release;

@property (nonatomic, copy) NSString *directors;

@property (nonatomic, copy) NSString *release_time;

@property (nonatomic, strong) Feature_Videos *feature_videos;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger score_count;

@property (nonatomic, copy) NSString *year;

@property (nonatomic, copy) NSString *poster_url;

@property (nonatomic, copy) NSString *release_date;

@property (nonatomic, assign) NSInteger wanttosee_count;

@property (nonatomic, copy) NSString *actors;

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *genre;

@end
@interface Feature_Videos : NSObject

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<List *> *list;

@end

@interface Videos : NSObject

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<List *> *list;

@end

@interface List : NSObject

@property (nonatomic, copy) NSString *play_url;

@property (nonatomic, assign) NSInteger durtion;

@property (nonatomic, copy) NSString *image_url;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *video_url;

@property (nonatomic, copy) NSString *is_lead;

@end



