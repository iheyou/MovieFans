//
//  HYPictureContainerView.m
//  MovieFans
//
//  Created by hy on 2016/10/9.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYPictureContainerView.h"
#import <MJPhotoBrowser.h>
#import <UIImageView+WebCache.h>

CGFloat margin = 5;

@interface HYPictureContainerView ()

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation HYPictureContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}

- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = 0;
//    if (_picPathStringsArray.count == 1) {
//        UIImage *image = [UIImage imageNamed:_picPathStringsArray.firstObject];
//        if (image.size.width) {
//            itemH = image.size.height / image.size.width * itemW;
//        }
//    } else {
//        itemH = itemW;
//    }
    if (_picPathStringsArray.count == 1) {
        itemH = 300;
    } else {
        itemH = itemW;
    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        [imageView loadDefaultImageWithUrl:obj];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        if (_picPathStringsArray.count == 1) {
            imageView.frame = CGRectMake(0 , 0, itemW, itemH);
        } else {
            imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
        }
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    
    NSMutableArray *pbArr = @[].mutableCopy;
    for (int i = 0; i < self.picPathStringsArray.count; i++) {
        NSString * urlString = self.picPathStringsArray[i];
        //PicUrlsModel *model = self.dataArray[i];
        UIImageView *imgView = self.imageViewsArray[i];
        // 创建一个大图的对象
        MJPhoto *photo = [[MJPhoto alloc] init];
        // 设置大图的链接地址
        photo.url = [NSURL URLWithString:urlString];
        // 指定一个来源的imageView
        photo.srcImageView = imgView;
        [pbArr addObject:photo];
    }
    // 创建一个图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = pbArr;
    
    UIImageView *imgView = (UIImageView *)tap.view;
    NSInteger index = [self.imageViewsArray indexOfObject:imgView];
    browser.currentPhotoIndex = index;
    [browser show];
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return SCREEN_WIDTH - 20;
    }
    if (array.count == 2 || array.count == 4) {
        return (SCREEN_WIDTH - margin - 20) / 2;
    }
    else {
        return (SCREEN_WIDTH - margin * 2 - 20) / 3;
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return 1;
    }
    if (array.count <= 3) {
        return array.count;
    } else if (array.count <= 4) {
        return 2;
    } else {
        return 3;
    }
}

#pragma mark - SDPhotoBrowserDelegate

//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
//{
//    NSString *imageName = self.picPathStringsArray[index];
//    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
//    return url;
//}
//
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
//{
//    UIImageView *imageView = self.subviews[index];
//    return imageView.image;
//}


@end
