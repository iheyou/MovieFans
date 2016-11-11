//
//  PicUrlsModel.h
//  CD1505Weibo
//
//  Created by hy on 16/1/4.
//  Copyright (c) 2016年 hy. All rights reserved.
//

#import "BaseModel.h"

@interface PicUrlsModel : BaseModel

/** 图片缩略图链接*/
@property (nonatomic, copy) NSString *small_pic;

/** 图片大图链接*/
@property (nonatomic, copy) NSString *large_pics;

@end
