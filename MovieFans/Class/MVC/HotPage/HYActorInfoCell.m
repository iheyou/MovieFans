//
//  HYActorInfoCell.m
//  MovieFans
//
//  Created by hy on 2016/10/10.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYActorInfoCell.h"
#import "HYActorInfoModel.h"

const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0;

@implementation HYActorInfoCell {
    UIView *_topView;
    UIView *_markView;
    UILabel *_titleLabel;
    
    UIView *_middleView;
    UILabel *_contentLabel;
    UIButton *_moreButton;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        UIView *contentView = self.contentView;
        CGFloat margin = 10;
        
        _topView = [UIView new];
        _middleView = [UIView new];
        [contentView sd_addSubviews:@[_topView,_middleView]];
        _topView.sd_layout.leftEqualToView(contentView).rightEqualToView(contentView).topEqualToView(contentView);
        _middleView.sd_layout.leftEqualToView(contentView).rightEqualToView(contentView).topSpaceToView(_topView,0);
        
        _markView = [UIView new];
        _markView.backgroundColor = [UIColor redColor];
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.text = @"简介";
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont textDefaultFontSize];
        _contentLabel.numberOfLines = 0;
        if (maxContentLabelHeight == 0) {
            maxContentLabelHeight = _contentLabel.font.lineHeight * 4;
        }
        _moreButton = [UIButton new];
        [_moreButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_topView sd_addSubviews:@[_markView,_titleLabel]];
        [_middleView sd_addSubviews:@[_contentLabel,_moreButton]];
        
        _markView.sd_layout.leftSpaceToView(_topView,8).topSpaceToView(_topView,16).widthIs(5);
        _titleLabel.sd_layout.leftSpaceToView(_markView,margin / 2).bottomEqualToView(_markView).widthIs(80);
        _contentLabel.sd_layout.leftSpaceToView(_middleView,margin).topSpaceToView(_middleView,16).rightSpaceToView(_middleView,margin).autoHeightRatio(0);
        CGFloat buttonMargin = SCREEN_WIDTH / 2 - 15;
        _moreButton.sd_layout.topSpaceToView(_contentLabel,0).leftSpaceToView(_middleView,buttonMargin).rightSpaceToView(_middleView,buttonMargin);
        
        [_topView setupAutoHeightWithBottomView:_markView bottomMargin:margin / 2];
        [_middleView setupAutoHeightWithBottomView:_moreButton bottomMargin:margin];
        [self setupAutoHeightWithBottomView:_middleView bottomMargin:0];
    }
    return self;
}

- (void)setModel:(HYActorInfoModel *)model {
    _model = model;
    _contentLabel.text = _model.desc;
    if (self.descIsNone) {
        _markView.sd_layout.heightIs(0);
        _titleLabel.sd_layout.heightIs(0);
    } else {
        _markView.sd_layout.heightIs(16);
        _titleLabel.sd_layout.heightIs(18);
        if (_model.shouldShowMoreButton) {
            _moreButton.sd_layout.heightIs(30);
            _moreButton.hidden = NO;
            if (model.isOpening) {
                _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
                [_moreButton setImage:[UIImage imageNamed:@"common_arrow_up_header"] forState:UIControlStateNormal];
            } else {
                _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
                [_moreButton setImage:[UIImage imageNamed:@"common_arrow_down_header"] forState:UIControlStateNormal];
            }
        } else {
            _moreButton.sd_layout.heightIs(0);
            _moreButton.hidden = YES;
        }
    }
}

- (void)moreButtonOnClicked {
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

@end
