//
//  IntroduceTableViewCell.h
//  MovieFans
//
//  Created by hy on 16/1/13.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseInfoModel.h"

@interface IntroduceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *IntroduceLabel;

//@property (nonatomic, strong) BaseInfoModel *model;

@property (nonatomic, strong) NSString *introduceText;

@end
