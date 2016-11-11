//
//  scroeToStar.h
//  MovieFans
//
//  Created by hy义 on 16/1/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYStarView : UIView

+ (float)scroeToStarWith:(NSString *)scroe;

@property (nonatomic, copy) NSString *score;

@end
