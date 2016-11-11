//
//  UIImageView+HYUtil.m
//  MovieFans
//
//  Created by hy on 2016/10/10.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "UIImageView+HYUtil.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (HYUtil)

- (void)loadDefaultImageWithUrl:(NSString *)urlStr {
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"weibo movie_yingping_pic_placeholder"]];
}

- (void)loadUserPhotoImageWithUrl:(NSString *)urlStr {
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"profile_Head_gray"]];
}

@end
