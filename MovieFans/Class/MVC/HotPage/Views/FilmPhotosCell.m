//
//  FilmPhotosCell.m
//  MovieFans
//
//  Created by hy on 16/1/18.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "FilmPhotosCell.h"
#import "UIImageView+WebCache.h"
#import "FilmPhotosModel.h"

@implementation FilmPhotosCell

- (void)layoutSubviews{
    _filePhotoScrollView.contentSize = CGSizeMake(10+160*_filmPhotosArr.count,0);
    _filePhotoScrollView.showsHorizontalScrollIndicator = NO;
    _filePhotoScrollView.showsVerticalScrollIndicator = NO;
    
}

- (void)setFilmPhotosArr:(NSMutableArray *)filmPhotosArr{
    
    _filmPhotosArr = filmPhotosArr;
    _numberOfFilePhotos.text = [NSString stringWithFormat:@"查看全部%ld张剧照",(unsigned long)_filmPhotosArr.count];
    _numberOfFilePhotos.tag = 1000;
    _numberOfFilePhotos.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    [_numberOfFilePhotos addGestureRecognizer:tapGesture];
    
    for (int i = 0; i < _filmPhotosArr.count; i++) {
        FilmPhotosModel * model = [[FilmPhotosModel alloc]init];
        model = _filmPhotosArr[i];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+i*160, 10, 155, 110)];
        [_filePhotoScrollView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.photo_url_mid] placeholderImage:[UIImage imageNamed:@"weibo movie_yingping_pic_placeholder"]];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = CREATOR_IMAGEVIEW_TAG + i;
        imageView.userInteractionEnabled = YES;
        
               //为图片添加手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
        [imageView addGestureRecognizer:tapGesture];
    }
    
  

}

// 手势识别器响应方法
- (void)onTap:(UITapGestureRecognizer *)sender
{
    
    NSInteger selectedIndex = sender.view.tag - CREATOR_IMAGEVIEW_TAG;
    
    //    // 通过push方式显示
    if ([self.delegate respondsToSelector:@selector(choseFilmPhotosTerm:)]) {
        
        [_delegate choseFilmPhotosTerm:selectedIndex];
    }
}



@end
