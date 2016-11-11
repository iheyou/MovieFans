//
//  RGCollectionViewCell.m
//  RGCardViewLayout
//
//  Created by ROBERA GELETA on 1/23/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//

#import "RGCollectionViewCell.h"

@implementation RGCollectionViewCell



- (void)setCellNumber:(NSInteger)cellNumber{
    _cellNumber = cellNumber;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tapGesture];
}

// 手势识别器响应方法
- (void)onTap:(UITapGestureRecognizer *)sender
{

    //    // 通过push方式显示
    if ([self.delegate respondsToSelector:@selector(choseMovieDetailTerm:)]) {

        [_delegate choseMovieDetailTerm:_cellNumber];
    }
}

@end
