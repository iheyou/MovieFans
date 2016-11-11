//
//  HYActorInfoCell.h
//  MovieFans
//
//  Created by hy on 2016/10/10.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYActorInfoModel;

@interface HYActorInfoCell : UITableViewCell

@property (nonatomic, strong) HYActorInfoModel *model;
@property (nonatomic, assign) BOOL descIsNone;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@end
