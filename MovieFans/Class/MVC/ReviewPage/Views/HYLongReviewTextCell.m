//
//  HYLongReviewTextCell.m
//  MovieFans
//
//  Created by hy on 2016/10/14.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYLongReviewTextCell.h"

@implementation HYLongReviewTextCell {
    UILabel *_textLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        UIView *contentView = self.contentView;
        CGFloat margin = 10;
        
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:16];
        [contentView sd_addSubviews:@[_textLabel]];
        _textLabel.sd_layout.leftSpaceToView(contentView,margin).rightSpaceToView(contentView,margin).topSpaceToView(contentView,0).autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:_textLabel bottomMargin:margin];
    }
    return self;
}

- (void)setTextStr:(NSString *)textStr {
    _textStr = textStr;
    _textLabel.text = _textStr;
}

@end
