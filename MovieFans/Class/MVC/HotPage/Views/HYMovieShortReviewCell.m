//
//  HYMovieShortReviewCell.m
//  MovieFans
//
//  Created by hy on 2016/10/14.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYMovieShortReviewCell.h"
#import "HYStarView.h"
#import "HYPictureContainerView.h"
#import "ReviewInfoModel.h"
#import "TimeSwitch.h"

@implementation HYMovieShortReviewCell {
    UIView *_lineView;
    
    UIView *_topView;
    UIImageView *_userPhoto;
    UILabel *_userName;
    HYStarView *_starView;
    UILabel *_timeLabel;
    
    UIView *_substanceView;
    UILabel *_substanceLabel;
    HYPictureContainerView *_picView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        UIView *contentView = self.contentView;
        CGFloat margin = 10;
        CGFloat marginHalf = 5;
        
        _topView = [UIView new];
        _substanceView = [UIView new];
        [contentView sd_addSubviews:@[_topView,_substanceView]];
        _topView.sd_layout.leftEqualToView(contentView).topEqualToView(contentView).rightEqualToView(contentView);
        _substanceView.sd_layout.leftEqualToView(contentView).topSpaceToView(_topView,0).rightEqualToView(contentView);
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor cellSplitLineColor];
        _userPhoto = [UIImageView new];
        _userPhoto.sd_cornerRadiusFromHeightRatio = @(0.5);
        _userName = [UILabel new];
        _userName.font = [UIFont systemFontOfSize:16];
        _starView = [HYStarView new];
        _timeLabel = [UILabel new];
        _timeLabel.font = WB_FONT_TIME;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [UIColor lightGrayColor];
        [_topView sd_addSubviews:@[_lineView,_userPhoto,_userName,_starView,_timeLabel]];
        _lineView.sd_layout.leftEqualToView(_topView).rightEqualToView(_topView).topEqualToView(_topView).heightIs(0.8);
        _userPhoto.sd_layout.leftSpaceToView(_topView,margin).topSpaceToView(_topView,margin).heightIs(40).widthIs(40);
        _userName.sd_layout.leftSpaceToView(_userPhoto,marginHalf).topEqualToView(_userPhoto).heightIs(20);
        [_userName setSingleLineAutoResizeWithMaxWidth:150];
        _starView.sd_layout.leftEqualToView(_userName).bottomEqualToView(_userPhoto).heightIs(15).widthIs(60);
        _timeLabel.sd_layout.rightSpaceToView(_topView,margin).bottomEqualToView(_starView).heightIs(15).widthIs(100);
        
        _substanceLabel = [UILabel new];
        _substanceLabel.font = [UIFont systemFontOfSize:16];
        _picView = [HYPictureContainerView new];
        [_substanceView sd_addSubviews:@[_substanceLabel,_picView]];
        _substanceLabel.sd_layout.leftSpaceToView(_substanceView,margin).rightSpaceToView(_substanceView,margin).topEqualToView(_substanceView).autoHeightRatio(0);
        _picView.sd_layout.leftEqualToView(_substanceLabel).rightEqualToView(_substanceLabel).topSpaceToView(_substanceLabel,marginHalf);
        
        [_topView setupAutoHeightWithBottomView:_userPhoto bottomMargin:margin];
        [_substanceView setupAutoHeightWithBottomView:_picView bottomMargin:margin];
        
        [self setupAutoHeightWithBottomView:_substanceView bottomMargin:0];
        
    }
    return self;
}

- (void)setModel:(ReviewInfoModel *)model {
    _model = model;

    [_userPhoto loadUserPhotoImageWithUrl:[_model.user valueForKey:@"avatar_large"]];
    _userName.text = [_model.user valueForKey:@"name"];
    _starView.score = _model.score;
    _timeLabel.text = [TimeSwitch timeSwitchWith:[NSString stringWithFormat:@"%ld",(long)_model.created_at]];
    _substanceLabel.text = _model.text;
    _picView.picPathStringsArray = _model.large_pics;
}

@end
