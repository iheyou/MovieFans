//
//  AdvanceCell.h
//  MovieFans
//
//  Created by hy on 16/1/9.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotModel.h"

@interface AdvanceCell : UITableViewCell

@property (nonatomic, strong) CAGradientLayer * gradientLayer;
 
@property (nonatomic, strong) HotModel *model;

- (void)scrollImageInTableview:(UITableView *)tableView inView:(UIView *)view;

@end
