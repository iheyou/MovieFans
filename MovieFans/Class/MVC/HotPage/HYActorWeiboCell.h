//
//  HYActorWeiboCell.h
//  MovieFans
//
//  Created by hy on 2016/10/9.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYActorWeiboModel;

@interface HYActorWeiboCell : UITableViewCell

@property (nonatomic, strong) HYActorWeiboModel *model;

@property (nonatomic, assign) BOOL weiboIsNone;

@end
