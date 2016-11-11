//
//  ListDetailViewController.h
//  MovieFans
//
//  Created by hy on 16/2/3.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic, copy) NSString *urlID;

@property (nonatomic, assign) NSInteger maxPage;

@property (nonatomic, copy) NSString *titleName;

@property (nonatomic, assign) NSInteger listCount;
@end
