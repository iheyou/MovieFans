//
//  DetailTableViewHeader.h
//  MovieFans
//
//  Created by hy on 16/1/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXBlurView.h"
@interface DetailTableViewHeader : NSObject

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)UIView* bigImageView;
@property(nonatomic,strong)FXBlurView* fxView;

-(void)layoutWithTableView:(UITableView*)tableView andBackGroundView:(UIView*)view andSubviews:(FXBlurView *)subviews;

- (void)scrollViewDidScroll:(UIScrollView*)scrollView;

- (void)resizeView;

@end
