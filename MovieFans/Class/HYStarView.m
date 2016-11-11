//
//  scroeToStar.m
//  MovieFans
//
//  Created by hy on 16/1/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYStarView.h"

@implementation HYStarView

+ (float)scroeToStarWith:(NSString *)scroe{
    float a = [scroe floatValue];
    if (a >= 9.5) {
        return 5;
    }
    else if (a >= 8.5 & a < 9.5){
        return 4.5;
    }
    else if (a >= 7.5 & a < 8.5){
        return 4;
    }
    else if (a >= 6.5 & a < 7.5){
        return 3.5;
    }
    else if (a >= 5.5 & a < 6.5){
        return 3;
    }
    else if (a >= 4.5 & a < 5.5){
        return 2.5;
    }
    else if (a >= 3.5 & a < 4.5){
        return 2;
    }
    else if (a >= 2.5 & a < 3.5){
        return 1.5;
    }
    else if (a >= 1.5 & a < 2.5){
        return 1;
    }
    else{
        return 0.5;
    }
}

- (void)setScore:(NSString *)score {
    _score = score;
    float scoreNum = [HYStarView scroeToStarWith:_score];
    int a = scoreNum * 2;
    if (a % 2 == 0) {
        for (int j = 0; j < 5;j++ ) {
            UIImageView * imageView =[[UIImageView alloc]init];
            if (j < a/2) {
                imageView.image = [UIImage imageNamed:@"rating_smallstar_selected_light"];
            }else{
                imageView.image = [UIImage imageNamed:@"rating_smallstar_unchecked_light"];
            }
            imageView.frame = CGRectMake(j*11,5, 10, 10);
            //        imageView.center = CGPointMake(_fxView.center.x-40+i*12, _fxView.center.y-30);
            [self addSubview:imageView];
        }
    }else{
        for (int j = 0; j < 5;j++ ) {
            UIImageView * imageView =[[UIImageView alloc]init];
            if (j < a/2) {
                imageView.image = [UIImage imageNamed:@"rating_smallstar_selected_light"];
            }else if(j == a/2){
                imageView.image = [UIImage imageNamed:@"rating_smallstar_half_light"];
            }else{
                imageView.image = [UIImage imageNamed:@"rating_smallstar_unchecked_light"];
            }
            
            imageView.frame = CGRectMake(j*11,5, 10, 10);
            [self addSubview:imageView];
        }
    }
}

@end
