//
//  HYRelationListModel.h
//  MovieFans
//
//  Created by hy on 2016/10/10.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RelationList,RelationInfo;

@interface HYRelationListModel : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, strong) NSArray *list;

@end

@interface RelationList : NSObject

@property (nonatomic, strong) RelationInfo *relation;

@end

@interface RelationInfo : NSObject

@property (nonatomic, copy) NSString *film_id;
@property (nonatomic, copy) NSString *name;


@end
