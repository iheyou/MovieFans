//
//  CollectionViewCell.m
//  MovieFans
//
//  Created by hy on 16/1/19.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"weibo movie_yingping_pic_placeholder"]];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
