//
//  ShortReviewCell.h
//  MovieFans
//
//  Created by hy on 16/1/20.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShortFrameModel.h"

@protocol ClickMovieInfoCellDelegate <NSObject>

-(void)choseMovieInfoTerm:(NSInteger)num;

@end

@interface ShortReviewCell : UITableViewCell

@property (nonatomic, strong) ShortFrameModel *frameModel;

@property (nonatomic, strong) NSString *promtString;

@property (nonatomic, assign) NSInteger cellNumber;

@property (assign, nonatomic) id<ClickMovieInfoCellDelegate> delegate;


@end
