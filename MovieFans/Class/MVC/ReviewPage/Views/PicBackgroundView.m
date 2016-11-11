//
//  PicBackgroundView.m
//  CD1505Weibo
//
//  Created by hy on 16/1/5.
//  Copyright (c) 2016年 hy. All rights reserved.
//

#import "PicBackgroundView.h"
#import "PicUrlsModel.h"
#import <UIImageView+WebCache.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ReviewInfoModel.h"

@interface PicBackgroundView ()

@property (nonatomic, strong) MJPhotoBrowser *pbrowser;

@property (nonatomic, strong) NSMutableArray *picsArray;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation PicBackgroundView



+ (CGFloat)heightWithNum:(NSInteger)num
{
    CGFloat height = 0;
    
    if (num == 1) {
        CGFloat picW = (SCREEN_WIDTH - 2 * WB_SPACING_NORMAL);
        height = picW - WB_SPACING_NORMAL*10;
    }
    else if(num == 2){
        CGFloat picW = (SCREEN_WIDTH - 2*WB_SPACING_NORMAL - PIC_SMALL)/2.0;
        height = picW;
    }
    else if(num == 4){
        CGFloat picW = (SCREEN_WIDTH - 2*WB_SPACING_NORMAL - PIC_SMALL)/2.0;
        height = 2*picW;
    }
    else{
        CGFloat picW = (SCREEN_WIDTH - 4 *WB_SPACING_NORMAL)/3.0;
        CGFloat spaceNum =0;
        if (num%3 == 0) {
            spaceNum = num/3;
        }else {
            spaceNum = (num/3 + 1);
        }
        height = (picW + WB_SPACING_NORMAL) * spaceNum;
    }
    return height ;
}

- (void)showPicsWithArray:(NSArray *)arr
{
    
    self.dataArray = [arr copy];
    for (UIView *v  in self.subviews) {
        [v removeFromSuperview];
    }
    self.pbrowser = nil;
    if (self.picsArray.count > 0) {
        [self.picsArray removeAllObjects];
    }
    
    self.picsArray = nil;
    
    self.picsArray = @[].mutableCopy;
    
    if (arr.count) {
        
        if (arr.count == 1) {
            NSString * urlString = arr[0];
            //PicUrlsModel *model = arr[0];
            CGFloat picW = (SCREEN_WIDTH - 3 * WB_SPACING_NORMAL);
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(3*WB_SPACING_NORMAL/2, 0, picW, picW - WB_SPACING_NORMAL*10)];
            [self addSubview:img];
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.clipsToBounds = YES;

            NSString *small_pic = [urlString stringByReplacingOccurrencesOfString:@"large" withString:@"bmiddle"];
            [img loadDefaultImageWithUrl:small_pic];
            //[img sd_setImageWithURL:[NSURL URLWithString:model.large_pics]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLarge:)];
            img.userInteractionEnabled = YES;
            [img addGestureRecognizer:tap];
            [self.picsArray addObject:img];

            
        }else{
            if (arr.count == 2) {
                CGFloat picW = (SCREEN_WIDTH - 2*WB_SPACING_NORMAL - PIC_SMALL)/2.0;
                for (int i =0; i<arr.count; i++) {
                    NSString * urlString = arr[i];
                    //PicUrlsModel *model = arr[i];
                    UIImageView *imgView = [[UIImageView alloc] init];
                    [self addSubview:imgView];
                    
                    NSString *small_pic = [urlString stringByReplacingOccurrencesOfString:@"large" withString:@"bmiddle"];
                    [imgView loadDefaultImageWithUrl:small_pic];
                    //[imgView sd_setImageWithURL:[NSURL URLWithString:model.small_pic]];
                    CGFloat imgX = (picW + PIC_SMALL) * (i%2)+ WB_SPACING_NORMAL;
                    CGFloat imgY = 0;
                    imgView.frame = CGRectMake(imgX, imgY, picW, picW);
                    imgView.userInteractionEnabled = YES;
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    imgView.clipsToBounds = YES;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLarge:)];
                    
                    [imgView addGestureRecognizer:tap];
                    
                    [self.picsArray addObject:imgView];
                }
            }
            
            
            else if (arr.count == 4) {
                
                CGFloat picW = (SCREEN_WIDTH - 2*WB_SPACING_NORMAL - PIC_SMALL)/2.0;
                for (int i =0; i<arr.count; i++) {
                    NSString * urlString = arr[i];
                    //PicUrlsModel *model = arr[i];
                    UIImageView *imgView = [[UIImageView alloc] init];
                    [self addSubview:imgView];
                    
                    NSString *small_pic = [urlString stringByReplacingOccurrencesOfString:@"large" withString:@"bmiddle"];
                    [imgView loadDefaultImageWithUrl:small_pic];
                    //[imgView sd_setImageWithURL:[NSURL URLWithString:model.small_pic]];
                    CGFloat imgX = (picW + PIC_SMALL) * (i%2)+ WB_SPACING_NORMAL;
                    CGFloat imgY = (picW + PIC_SMALL) * (i/2);
                    imgView.frame = CGRectMake(imgX, imgY, picW, picW);
                    imgView.userInteractionEnabled = YES;
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    imgView.clipsToBounds = YES;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLarge:)];
                    
                    [imgView addGestureRecognizer:tap];
                    
                    [self.picsArray addObject:imgView];
                }

                
            }else {
                CGFloat picW = (SCREEN_WIDTH - 2 *WB_SPACING_NORMAL - 2*PIC_SMALL)/3.0;
                for (int i =0; i<arr.count; i++) {
                    NSString * urlString = arr[i];
                    //PicUrlsModel *model = arr[i];
                    UIImageView *imgView = [[UIImageView alloc] init];
                    [self addSubview:imgView];
                    
                    NSString *small_pic = [urlString stringByReplacingOccurrencesOfString:@"large" withString:@"bmiddle"];
                    [imgView loadDefaultImageWithUrl:small_pic];
                    //[imgView sd_setImageWithURL:[NSURL URLWithString:model.small_pic]];
                    CGFloat imgX = (picW + PIC_SMALL) * (i%3)+ WB_SPACING_NORMAL;
                    CGFloat imgY = (picW + PIC_SMALL) * (i/3);
                    imgView.frame = CGRectMake(imgX, imgY, picW, picW);
                    imgView.userInteractionEnabled = YES;
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    imgView.clipsToBounds = YES;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLarge:)];
                
                    [imgView addGestureRecognizer:tap];
                    
                    [self.picsArray addObject:imgView];
            
                 
                }
            }
        }
        
    }
}


- (void)showLarge:(UITapGestureRecognizer *)tap;
{
    
    NSMutableArray *pbArr = @[].mutableCopy;
    for (int i = 0; i<self.picsArray.count; i++) {
        NSString * urlString = self.dataArray[i];
        //PicUrlsModel *model = self.dataArray[i];
        
        UIImageView *imgView = self.picsArray[i];
        
        // 创建一个大图的对象
        MJPhoto *photo = [[MJPhoto alloc] init];
        // 设置大图的链接地址
        photo.url = [NSURL URLWithString:urlString];
        // 指定一个来源的imageView
        photo.srcImageView = imgView;
        
        [pbArr addObject:photo];
    }
   
    
    // 创建一个图片浏览器
    MJPhotoBrowser *pbrowser = [[MJPhotoBrowser alloc] init];
    pbrowser.photos = pbArr;
    
    UIImageView *imgView = (UIImageView *)tap.view;
    NSInteger index = [self.picsArray indexOfObject:imgView];
    pbrowser.currentPhotoIndex = index;
    [pbrowser show];
}



// 1     2    3    4     5     6   7    8     9
// w*0+space * 0  w*1  w*2   w*0   w*1  w*2 w*0   w*1  w*2
// w*0  w*0  w*0   w*1   w*1  w*1  w*2  w *2  w*2

@end
