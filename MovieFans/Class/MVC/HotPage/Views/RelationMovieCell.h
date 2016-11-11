//
//  RelationMovieCell.h
//  MovieFans
//
//  Created by hy on 16/1/14.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelationInfoModel.h"

@protocol ClickRelationInfoCellDelegate <NSObject>

@optional
- (void)actorMoreMovieList:(NSString *)artist_id;

- (void)choseRelationInfoTerm:(NSInteger)num andPageID:(NSString *)pageid andCellNumber:(NSInteger)cellNumber;

@end

@interface RelationMovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfMovieLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *relationMovieScrollView;
@property (weak, nonatomic) IBOutlet UIView *cubeView;
@property (weak, nonatomic) IBOutlet UIView *gestrueView;

@property (nonatomic, copy) NSString *cellTitle;
@property (nonatomic, strong) NSMutableArray *relationMovieArr;
@property (nonatomic, assign) BOOL isRandomColor;
@property (nonatomic, copy) NSString *numbers;
@property (nonatomic, copy) NSString * detailId;
@property (nonatomic, assign) NSInteger cellNumber;
@property (nonatomic, copy) NSString *artist_id;

@property (assign, nonatomic) id<ClickRelationInfoCellDelegate> delegate;


@end
