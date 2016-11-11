//
//  SearchResultCell.m
//  MovieFans
//
//  Created by hy on 16/2/9.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "SearchResultCell.h"
#import "UIImageView+WebCache.h"
#import "HYStarView.h"

@implementation SearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HotModel *)model{
    
    _model = model;
    
    self.NameLabel.text = model.name;
    
    [self.moviePostImageView sd_setImageWithURL:[NSURL URLWithString:model.poster_url]placeholderImage:[UIImage imageNamed:@"weibo movie_yingping_pic_placeholder"]];
    
    NSArray * directorArr = model.directors;
    NSString * directorName = [[directorArr firstObject] valueForKey:@"name"];
    if (directorName.length != 0) {
        self.directorLabel.text = [NSString stringWithFormat:@"导演:%@",directorName];
    }
    
    
    NSArray * actorsArr = model.actors;
    NSMutableString * actorString = [[NSMutableString alloc]init];
    for (int i = 0; i < actorsArr.count; i++) {
        [actorString appendFormat:@"%@/",[actorsArr[i] valueForKey:@"name"]];
    }
    if (actorString.length != 0) {
        self.actorLabel.text = [NSString stringWithFormat:@"主演:%@",actorString];
    }
    
    if (model.release_date.length != 0) {
        self.dateLabel.text = [NSString stringWithFormat:@"%@上映",model.release_date];
    }
    
    
}

- (void)layoutSubviews{
    
    if (self.starView.subviews.count != 0) {

        //复用时若有子视图删除了重新添加避免cell复用重复数据
        for (UIView *subView in self.starView.subviews)
        {
            [subView removeFromSuperview];
        }
        
    }
    
    float score = [HYStarView scroeToStarWith:_model.score];
    if ([_model.score isEqualToString:@"0.0"]) {
        return;
    }else{
    
    int a = score * 2;
    if (a % 2 == 0) {
        for (int j = 0; j < 5;j++ ) {
            UIImageView * imageView =[[UIImageView alloc]init];
            if (j < a/2) {
                imageView.image = [UIImage imageNamed:@"rating_smallstar_selected_light"];
            }else{
                imageView.image = [UIImage imageNamed:@"rating_smallstar_unchecked_light"];
            }
            imageView.frame = CGRectMake(2+j*11,5,10,10);
            //        imageView.center = CGPointMake(_fxView.center.x-40+i*12, _fxView.center.y-30);
            [self.starView addSubview:imageView];
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
            
            imageView.frame = CGRectMake(2+j*11,5, 10, 10);
            [self.starView addSubview:imageView];
        }
    }
    }
    if ([_model.score isEqualToString:@"0.0"]) {
        return;
    }else{

        UILabel * scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 40, 10)];
        [self.starView addSubview:scoreLabel];
        scoreLabel.text = _model.score;
        scoreLabel.font = [UIFont systemFontOfSize:12];
        scoreLabel.textColor = [UIColor colorWithRed:250/255.0 green:207/255.0 blue:12/255.0 alpha:1];
    }
    
}


@end
