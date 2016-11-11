//
//  LongReviewCell.h
//  MovieFans
//
//  Created by hy on 16/1/19.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewInfoModel.h"

@interface LongReviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UIImageView *hyimageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *filmNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hytextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UILabel *boolLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelHeight;

@property (nonatomic, strong) CAGradientLayer * gradientLayer;
@property (nonatomic, strong) ReviewInfoModel * model;
@property (nonatomic, strong) NSString *string;
//@property (nonatomic, assign) BOOL isDetail;

@end
