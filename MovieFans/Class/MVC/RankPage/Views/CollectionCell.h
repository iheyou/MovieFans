//
//  CollectionCell.h
//  LimitFreeDemo
//
//  Created by Chaosky on 15/12/21.
//  Copyright © 2015年 1000phone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *appImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
