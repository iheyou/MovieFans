//
//  FilmPhotosCell.h
//  MovieFans
//
//  Created by hy on 16/1/18.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickFilmPhotosCellDelegate <NSObject>

-(void)choseFilmPhotosTerm:(NSInteger)num;

//-(void)checkAllPhotos;

@end

@interface FilmPhotosCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberOfFilePhotos;
@property (weak, nonatomic) IBOutlet UIScrollView *filePhotoScrollView;

@property (nonatomic, strong) NSMutableArray * filmPhotosArr;

@property (assign, nonatomic) id<ClickFilmPhotosCellDelegate> delegate;

@end
