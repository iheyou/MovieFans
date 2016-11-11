//
//  RelationMovieCell.m
//  MovieFans
//
//  Created by hy on 16/1/14.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "RelationMovieCell.h"
#import "UIImageView+WebCache.h"
#import "HYStarView.h"

@implementation RelationMovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews{
    _relationMovieScrollView.contentSize = CGSizeMake(10+100*_relationMovieArr.count,0);
    [_relationMovieScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    if (_isRandomColor) {
        NSArray * colorArr = @[[UIColor greenColor],[UIColor redColor],[UIColor blueColor],[UIColor cyanColor],[UIColor brownColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor magentaColor],[UIColor darkGrayColor],[UIColor yellowColor]];
        self.cubeView.backgroundColor = colorArr[arc4random()%10];
        //self.numberOfMovieLabel.text = self.number2;
    }
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UIScrollView")]) {
            
        }
    }];
    
    if (_relationMovieScrollView.subviews.count != 0) {
        //复用时若有子视图删除了重新添加避免cell复用重复数据
        for (UIView *subView in _relationMovieScrollView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    for (int i = 0; i < _relationMovieArr.count; i++) {
        RelationInfoModel * model = [[RelationInfoModel alloc]init];
        model = _relationMovieArr[i];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+i*100, 10, 95, 130)];
        [_relationMovieScrollView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.poster_url] placeholderImage:[UIImage imageNamed:@"page_second_actorfilms_more"]];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = CREATOR_IMAGEVIEW_TAG + i;
        imageView.userInteractionEnabled = YES;
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+i*100, CGRectGetMaxY(imageView.frame)+5, 95, 15)];
        [_relationMovieScrollView addSubview:nameLabel];
        nameLabel.text = model.name;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:11];
        
        float score = [HYStarView scroeToStarWith:model.score];
        int a = score * 2;
        if (a % 2 == 0) {
            for (int j = 0; j < 5;j++ ) {
                UIImageView * imageView =[[UIImageView alloc]init];
                if (j < a/2) {
                    imageView.image = [UIImage imageNamed:@"rating_smallstar_selected_light"];
                }else{
                    imageView.image = [UIImage imageNamed:@"rating_smallstar_unchecked_light"];
                }
                imageView.frame = CGRectMake(15+i*100+j*11,CGRectGetMaxY(nameLabel.frame)+5, 10, 10);
                //        imageView.center = CGPointMake(_fxView.center.x-40+i*12, _fxView.center.y-30);
                [_relationMovieScrollView addSubview:imageView];
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
                
                imageView.frame = CGRectMake(15+i*100+j*11,CGRectGetMaxY(nameLabel.frame)+5, 10, 10);
                [_relationMovieScrollView addSubview:imageView];
            }
        }
        
        UILabel * scroeLabel = [[UILabel alloc]initWithFrame:CGRectMake(75+i*100, CGRectGetMaxY(nameLabel.frame), 30,15)];
        [_relationMovieScrollView addSubview:scroeLabel];
        scroeLabel.text = model.score;
        scroeLabel.textColor = [UIColor orangeColor];
        scroeLabel.font =  [UIFont fontWithName:@"Chalkboard SE" size:14];
        
        //为图片添加手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
        [imageView addGestureRecognizer:tapGesture];
        
    }
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapMore:)];
    _gestrueView.tag = 999;
    [_gestrueView addGestureRecognizer:tapGesture];
}

- (void)setNumbers:(NSString *)numbers{
    _numbers = numbers;
    _numberOfMovieLabel.text = numbers;
}

- (void)setCellTitle:(NSString *)cellTitle {
    _cellTitle = cellTitle;
    _titleLabel.text = _cellTitle;
}


- (void)setRelationMovieArr:(NSMutableArray *)relationMovieArr{
    _relationMovieArr = relationMovieArr;
    //_numberOfMovieLabel.text = [NSString stringWithFormat:@"%ld部电影",_relationMovieArr.count];
    
}

- (void)setArtist_id:(NSString *)artist_id {
    _artist_id = artist_id;
}

- (void)onTapMore:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(actorMoreMovieList:)]) {
        [self.delegate actorMoreMovieList:_artist_id];
    }
}

// 手势识别器响应方法
- (void)onTap:(UITapGestureRecognizer *)sender
{
    NSInteger selectedIndex = sender.view.tag - CREATOR_IMAGEVIEW_TAG;
    // 通过push方式显示
    if ([self.delegate respondsToSelector:@selector(choseRelationInfoTerm:andPageID:andCellNumber:)]) {
        [_delegate choseRelationInfoTerm:selectedIndex andPageID:self.detailId andCellNumber:self.cellNumber];
    }
}


@end
