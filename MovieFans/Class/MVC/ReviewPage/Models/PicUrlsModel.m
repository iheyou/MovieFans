//
//  PicUrlsModel.m
//  CD1505Weibo
//
//  Created by hy on 16/1/4.
//  Copyright (c) 2016年 hy. All rights reserved.
//

#import "PicUrlsModel.h"

@implementation PicUrlsModel


- (void)setLarge_pics:(NSString *)large_pics
{
    _large_pics = large_pics;
    
    // 将大图片的地址链接存储下来
    NSString *small_pic = [large_pics stringByReplacingOccurrencesOfString:@"large" withString:@"bmiddle"];
    _small_pic = small_pic;
    
}

@end
