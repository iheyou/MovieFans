//
//  HYLongReviewImageCell.m
//  MovieFans
//
//  Created by hy on 2016/10/14.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYLongReviewImageCell.h"
#import "HYPictureContainerView.h"

@implementation HYLongReviewImageCell {
    HYPictureContainerView *_imageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        UIView *contentView = self.contentView;
        CGFloat margin = 10;
        
        _imageView = [HYPictureContainerView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [contentView sd_addSubviews:@[_imageView]];
        _imageView.sd_layout.leftSpaceToView(contentView,margin).topSpaceToView(contentView,margin);
        [self setupAutoHeightWithBottomView:_imageView bottomMargin:margin];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    _imageView.picPathStringsArray = [NSArray arrayWithObject:_imageUrl];
}

@end
