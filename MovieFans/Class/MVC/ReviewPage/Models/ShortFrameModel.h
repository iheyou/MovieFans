//
//  ShortFrameModel.h
//  MovieFans
//
//  Created by hy on 16/1/20.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ReviewInfoModel.h"

@interface ShortFrameModel : NSObject

@property (nonatomic, strong) ReviewInfoModel* reviewModel;

/** 一、顶部背景图层*/
@property (nonatomic,assign) CGRect topBackgroundViewFrame;

/** 用户图像*/
@property (nonatomic, assign) CGRect userIconImageViewFrame;

/** 用户名*/
@property (nonatomic, assign) CGRect userNameLabelFrame;

/** 评分*/
@property (nonatomic, assign) CGRect startViewFrame;

/**发布时间*/
@property (nonatomic, assign) CGRect wbCreateTimeLabelFrame;

/** 二、发布的微博内容背景图层*/
@property (nonatomic, assign) CGRect secondBackgroundViewFrame;

/** 微博文字内容*/
@property (nonatomic, assign) CGRect wbContentLableFrame;

/** 微博图片内容的背景图层*/
@property (nonatomic, assign) CGRect wbPicsBackgroundViewFrame;

/** 三、底部图层*/
@property (nonatomic, assign)CGRect bottomBackgroundViewFrame;

@property (nonatomic, assign) CGRect  titleimageViewFrame;

@property (nonatomic, assign) CGRect titleLabelFrame;

@property (nonatomic, assign) CGRect promptLabelFrame;

@property (nonatomic, assign) CGRect lineViewFrame;

/** cell高度*/
@property (nonatomic, assign) CGFloat cellHeight;

@end
