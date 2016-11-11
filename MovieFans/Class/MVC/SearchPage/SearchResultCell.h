//
//  SearchResultCell.h
//  MovieFans
//
//  Created by hy on 16/2/9.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotModel.h"

@interface SearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *moviePostImageView;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorLabel;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) HotModel *model;

@end
