//
//  CreatorInfoModel.h
//  MovieFans
//
//  Created by hy on 16/1/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import <MJExtension.h>

@interface CreatorInfoModel : BaseModel


@property (nonatomic, copy) NSString *sinaid;

@property (nonatomic, copy) NSString *profile_image_url;

@property (nonatomic, copy) NSString *verified;

@property (nonatomic, copy) NSString *job;

@property (nonatomic, copy) NSString *artist_id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *verified_type;


@end
