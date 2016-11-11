//
//  HYCommentsCell.m
//  MovieFans
//
//  Created by hy on 2016/10/14.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYCommentsCell.h"
#import "HYCommentsModel.h"
#import "TimeSwitch.h"

@implementation HYCommentsCell {
    UIView *_lineView;
    UIView *_userView;
    UIImageView *_userPhoto;
    UILabel *_userName;
    UILabel *_timeLabel;
    
    UIView *_substansView;
    UILabel *_contentLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        UIView *contentView = self.contentView;
        CGFloat margin = 10;
        CGFloat halfMargin = 5;
        
        _userView = [UIView new];
        _substansView = [UIView new];
        [contentView sd_addSubviews:@[_userView,_substansView]];
        _userView.sd_layout.leftEqualToView(contentView).rightEqualToView(contentView).topEqualToView(contentView);
        _substansView.sd_layout.leftEqualToView(contentView).rightEqualToView(contentView).topSpaceToView(_userView,margin);
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor cellSplitLineColor];
        
        _userPhoto = [UIImageView new];
        _userPhoto.sd_cornerRadiusFromHeightRatio = @(0.5);
        
        _userName = [UILabel new];
        _userName.textColor = [UIColor customDefaultGrayColor];
        _userName.font = [UIFont systemFontOfSize:16];
        _userName.textAlignment = NSTextAlignmentLeft;
        
        _timeLabel = [UILabel new];
        _timeLabel.textColor = [UIColor customDefaultGrayColor];
        _timeLabel.font = WB_FONT_TIME;

        [_userView sd_addSubviews:@[_lineView,_userPhoto,_userName,_timeLabel]];
        _lineView.sd_layout.leftEqualToView(_userView).rightEqualToView(_userView).topEqualToView(_userView).heightIs(0.8);
        _userPhoto.sd_layout.leftSpaceToView(_userView,margin).topSpaceToView(_lineView,margin).heightIs(40).widthIs(40);
        _userName.sd_layout.leftSpaceToView(_userPhoto,halfMargin).topEqualToView(_userPhoto).heightIs(20);
        [_userName setSingleLineAutoResizeWithMaxWidth:200];
        _timeLabel.sd_layout.leftEqualToView(_userName).bottomEqualToView(_userPhoto).heightIs(15);
        [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        [_substansView sd_addSubviews:@[_contentLabel]];
        _contentLabel.sd_layout.leftEqualToView(_userName).rightSpaceToView(_substansView,margin).topSpaceToView(_substansView,margin).autoHeightRatio(0);
        
        [_userView setupAutoHeightWithBottomView:_userPhoto bottomMargin:0];
        [_substansView setupAutoHeightWithBottomView:_contentLabel bottomMargin:margin];
        [self setupAutoHeightWithBottomView:_substansView bottomMargin:0];
    }
    return self;
}

- (void)setModel:(HYCommentsModel *)model {
    _model = model;
    
    [_userPhoto loadUserPhotoImageWithUrl:_model.user.avatar_large];
    _userName.text = _model.user.name;
    _timeLabel.text = [TimeSwitch timeSwitchWith:[NSString stringWithFormat:@"%ld",(long)_model.created_at]];
    _contentLabel.text = _model.text;
}

@end
