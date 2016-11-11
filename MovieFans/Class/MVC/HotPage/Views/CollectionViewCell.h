//
//  CollectionViewCell.h
//  MovieFans
//
//  Created by hy on 16/1/19.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) NSString *imageUrl;

@end
