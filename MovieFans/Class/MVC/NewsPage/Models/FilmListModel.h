//
//  FilmListModel.h
//  MovieFans
//
//  Created by hy on 16/1/27.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import <MJExtension.h>

@class User;
@interface FilmListModel : BaseModel


@property (nonatomic, assign) NSInteger follow_count;

@property (nonatomic, copy) NSString *pagelist_id;

@property (nonatomic, assign) NSInteger movie_count;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) User *user;


@end
@interface User : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *avatar_large;

@end

