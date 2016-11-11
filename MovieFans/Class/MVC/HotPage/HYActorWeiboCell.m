//
//  HYActorWeiboCell.m
//  MovieFans
//
//  Created by hy on 2016/10/9.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYActorWeiboCell.h"
#import "HYPictureContainerView.h"
#import "HYActorWeiboModel.h"
#import "TimeSwitch.h"

@implementation HYActorWeiboCell {
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    HYPictureContainerView *_picContainerView;
    
    UIView *_topView;
    UIView *_middleView;
    UIView *_bottomView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        CGFloat margin = 10;
        UIView *contentView = self.contentView;
        
        
        _topView = [UIView new];
        _middleView = [UIView new];
        _bottomView = [UIView new];
        [contentView sd_addSubviews:@[_topView,_middleView,_bottomView]];
        
        
        _imageView = [UIImageView new];
        _nameLabel = [UILabel new];
        _timeLabel = [UILabel new];
        _contentLabel = [UILabel new];
        _picContainerView = [HYPictureContainerView new];
        
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor grayColor];
        _contentLabel.font = [UIFont textDefaultFontSize];
        
        [_topView sd_addSubviews:@[_imageView,_nameLabel,_timeLabel]];
        [_middleView sd_addSubviews:@[_contentLabel,_picContainerView]];
        _topView.sd_layout.leftEqualToView(contentView).rightEqualToView(contentView).topEqualToView(contentView);
        
        _middleView.sd_layout.leftEqualToView(contentView).rightEqualToView(contentView).topSpaceToView(_topView,0);

        
        _imageView.sd_layout.leftSpaceToView(_topView,margin).topSpaceToView(_topView,margin).heightIs(40).widthIs(40);
        _imageView.sd_cornerRadiusFromHeightRatio = @(0.5);
        _nameLabel.sd_layout.leftSpaceToView(_imageView,margin).centerYEqualToView(_imageView).heightIs(18);
        [_nameLabel setSingleLineAutoResizeWithMaxWidth:150];
        _timeLabel.sd_layout.rightSpaceToView(_topView,margin).bottomEqualToView(_imageView).heightIs(15);
        [_timeLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        _contentLabel.sd_layout.leftSpaceToView(_middleView,margin).rightSpaceToView(_middleView,margin).topEqualToView(_middleView).autoHeightRatio(0);
        _picContainerView.sd_layout.leftSpaceToView(_middleView,margin).topSpaceToView(_contentLabel,margin);
        
        
        [_topView setupAutoHeightWithBottomView:_imageView bottomMargin:margin];
        [_middleView setupAutoHeightWithBottomView:_picContainerView bottomMargin:margin];
        [self setupAutoHeightWithBottomView:_middleView bottomMargin:margin];
    }
    return self;
}

- (void)setModel:(HYActorWeiboModel *)model {
    _model = model;
    if (self.weiboIsNone) {
        
    } else {
        [_imageView loadUserPhotoImageWithUrl:_model.user.avatar_large];
        _nameLabel.text = _model.user.name;
        _timeLabel.text = [TimeSwitch timeSwitch:[NSString stringWithFormat:@"%ld",(long)_model.created_at]];
        _contentLabel.text = _model.text;
        _picContainerView.picPathStringsArray = _model.large_pics;
    }
}

@end
