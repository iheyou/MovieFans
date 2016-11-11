//
//  HYActorInfoModel.h
//  MovieFans
//
//  Created by hy on 2016/10/10.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYActorInfoModel : NSObject

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@end
