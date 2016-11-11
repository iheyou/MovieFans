//
//  TitleCell.m
//  MovieFans
//
//  Created by hy on 16/1/19.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "TitleCell.h"

@implementation TitleCell

- (void)setTitle:(NSString *)title{
    _title = title;
}

- (void)setNumber:(NSString *)number{
    _number = number;
}

- (void)layoutSubviews{
    _titleLabel.text = _title;
    _numberLabel.text = [NSString stringWithFormat:@"查看全部%@",_number];
}

@end
