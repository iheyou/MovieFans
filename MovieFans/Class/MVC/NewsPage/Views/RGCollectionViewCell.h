//
//  RGCollectionViewCell.h
//  RGCardViewLayout
//
//  Created by ROBERA GELETA on 1/23/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickMovieDetailCellDelegate <NSObject>

-(void)choseMovieDetailTerm:(NSInteger)num;

@end

@interface RGCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *dirctor;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITextView *introView;

@property (nonatomic, assign) NSInteger cellNumber;

@property (assign, nonatomic) id<ClickMovieDetailCellDelegate> delegate;


@end
