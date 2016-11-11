//
//  IntroduceTableViewCell.m
//  MovieFans
//
//  Created by hy on 16/1/13.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "IntroduceTableViewCell.h"


@implementation IntroduceTableViewCell

//-(void)setModel:(BaseInfoModel *)model{
//    _model = model;
//    self.IntroduceLabel.text = _model.desc;
//}

- (void)setIntroduceText:(NSString *)introduceText{
    _introduceText = introduceText;
    self.IntroduceLabel.text = _introduceText;
}


//- (void)setDesc:(NSString *)desc{
//    self.IntroduceLabel.text = desc;
//}

@end
