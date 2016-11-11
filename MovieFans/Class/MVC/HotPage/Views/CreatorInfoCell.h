//
//  CreatorInfoCell.h
//  MovieFans
//
//  Created by hy on 16/1/13.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatorInfoModel.h"

@protocol ClickCreatorCellDelegate <NSObject>

-(void)choseCreatorTerm:(NSInteger)num;

@end

@interface CreatorInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *creatorScrollView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCreators;

@property (nonatomic, strong) NSMutableArray * creatorArr;

@property (assign, nonatomic) id<ClickCreatorCellDelegate> delegate;


@end
