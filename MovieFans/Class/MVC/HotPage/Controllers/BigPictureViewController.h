//
//  BigPictureViewController.h
//  LimitFreeDemo
//
//  Created by hy on 15/12/18.
//  Copyright © 2015年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigPictureViewController : UIViewController
// 所有照片
@property (nonatomic, strong) NSArray * photos;
// 当前选中的图片的位置
@property (nonatomic, assign) NSInteger selectedIndex;

@end
