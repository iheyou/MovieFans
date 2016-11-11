//
//  LongReviewCell.m
//  MovieFans
//
//  Created by hy on 16/1/19.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "LongReviewCell.h"
#import "UIImageView+WebCache.h"
#import "TimeSwitch.h"
#import "HYStarView.h"

@implementation LongReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.clipsToBounds = YES;
    //图片contentModel
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    
    self.gradientLayer.frame = self.gradientView.bounds;
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor blackColor].CGColor];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    //self.gradientLayer.locations = @[@(0.5f) ,@(1.0f)];
    [self.gradientView.layer addSublayer:self.gradientLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ReviewInfoModel *)model{
    _model = model;
//    @property (weak, nonatomic) IBOutlet UIImageView *imageView;
//    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *filmNameLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *textLabel;
//    @property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
//    @property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.poster_url]placeholderImage:[UIImage imageNamed:@"weibo movie_yingping_pic_placeholder"]];
    
    self.titleLabel.text = _model.title;
    self.filmNameLabel.text = _model.film_name;
    
    NSString * time = [NSString stringWithFormat:@"%ld",(long)_model.created_at];
    self.dateLabel.text = [TimeSwitch timeSwitch:time];
    
    self.textLabel.text = _model.text;

    
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:[_model.user valueForKey:@"avatar_large"]] placeholderImage:[UIImage imageNamed:@"profile_Head_gray"]];
    self.userIconImageView.layer.masksToBounds = YES;
    self.userIconImageView.layer.cornerRadius = 15;
    
    self.userNameLabel.text = [_model.user valueForKey:@"name"];
}


-(void)layoutSubviews{
    self.boolLabel.text = _string;
    [self.imageView loadDefaultImageWithUrl:_model.poster_url];
    
    self.titleLabel.text = _model.title;
    self.filmNameLabel.text = _model.film_name;
    
    NSString * time = [NSString stringWithFormat:@"%ld",(long)_model.created_at];
    self.dateLabel.text = [TimeSwitch timeSwitch:time];
    

    self.textLabel.text = _model.text;

    
    [self.userIconImageView loadDefaultImageWithUrl:[_model.user valueForKey:@"avatar_large"]];
    self.userIconImageView.layer.masksToBounds = YES;
    self.userIconImageView.layer.cornerRadius = 15;
    
    self.userNameLabel.text = [_model.user valueForKey:@"name"];
    
//    if (self.startView.subviews.count != 0) {
//        
//        return;
//    }
    float score = [HYStarView scroeToStarWith:_model.score];
    int a = score * 2;
    if (a % 2 == 0) {
        for (int j = 0; j < 5;j++ ) {
            UIImageView * imageView =[[UIImageView alloc]init];
            if (j < a/2) {
                imageView.image = [UIImage imageNamed:@"rating_smallstar_selected_light"];
            }else{
                imageView.image = [UIImage imageNamed:@"rating_smallstar_unchecked_light"];
            }
            imageView.frame = CGRectMake(j*11,0, 10, 10);
            //        imageView.center = CGPointMake(_fxView.center.x-40+i*12, _fxView.center.y-30);
            [self.startView addSubview:imageView];
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
            
            imageView.frame = CGRectMake(j*11,0, 10, 10);
            [self.startView addSubview:imageView];
        }
    }



}

@end
