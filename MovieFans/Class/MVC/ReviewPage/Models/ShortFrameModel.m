//
//  ShortFrameModel.m
//  MovieFans
//
//  Created by hy on 16/1/20.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "ShortFrameModel.h"
#import "PicBackgroundView.h"

CGFloat const vWH = 15;

@implementation ShortFrameModel

- (void)setReviewModel:(ReviewInfoModel *)reviewModel{
    
    _reviewModel = reviewModel;
    NSDictionary * userDic = (id)reviewModel.user;
    NSString * userName = [userDic valueForKey:@"name"];
    
    CGFloat topBGX = 0;
    CGFloat topBGY = 0;
    CGFloat topBGW = SCREEN_WIDTH;
    CGFloat topBGH = 0; // 暂时设为0;
    
    /** 顶部图层*/
    CGFloat bottomX = topBGX;
    CGFloat bottomY = topBGY;
    CGFloat bottomW = topBGW;
    CGFloat bottomH = 40;
    
    self.bottomBackgroundViewFrame = CGRectMake(bottomX, bottomY, bottomW, bottomH);
    
    self.titleimageViewFrame = CGRectMake(WB_SPACING_NORMAL, WB_SPACING_NORMAL, 20, 20);
    
    self.titleLabelFrame = CGRectMake(CGRectGetMaxX(self.titleimageViewFrame)+WB_SPACING_SMALL, WB_SPACING_NORMAL, 200, 20);
    
    /** 发布时间*/
    CGFloat wbCTimeX = SCREEN_WIDTH - 115;
    CGFloat wbCTimeY = WB_SPACING_NORMAL + WB_SPACING_SMALL;
    CGFloat wbCTimeW = 100;
    CGFloat wbCTimeH = 15;
    self.wbCreateTimeLabelFrame = CGRectMake(wbCTimeX, wbCTimeY, wbCTimeW, wbCTimeH);
    
    topBGH = CGRectGetMaxY(self.titleimageViewFrame) + WB_SPACING_NORMAL;
    
    /** 第二块*/
    /** 二、用户自己发布的微博内容背景图层*/
    CGFloat secondBGX = topBGX;
    CGFloat secondBGY = CGRectGetMaxY(self.bottomBackgroundViewFrame);
    CGFloat secondBGW = topBGW;
    CGFloat secondBGH = 0;
    
    /** 1.微博文字内容*/
    CGFloat wbContentX = WB_SPACING_NORMAL;
    CGFloat wbContentY = 0;
    
    CGSize wbContentSize = [reviewModel.text boundingRectWithSize:CGSizeMake(secondBGW - 2*wbContentX, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:WB_FONT_USERNAME} context:nil].size;
    
    self.wbContentLableFrame = (CGRect){{wbContentX,wbContentY},wbContentSize};
    
    /** 2.微博图片内容的背景图层*/
    CGFloat wbPicBgX = 0;
    CGFloat wbPicBgY = CGRectGetMaxY(self.wbContentLableFrame);
    if (reviewModel.large_pics.count != 0) {
        wbPicBgY = CGRectGetMaxY(self.wbContentLableFrame) + WB_SPACING_NORMAL;
    }
    
    CGFloat wbPicBgW = secondBGW;
    CGFloat wbPicBgH = [PicBackgroundView heightWithNum:reviewModel.large_pics.count];
    
    self.wbPicsBackgroundViewFrame = CGRectMake(wbPicBgX, wbPicBgY, wbPicBgW, wbPicBgH);
    
    secondBGH = CGRectGetMaxY(self.wbPicsBackgroundViewFrame);
    
    self.secondBackgroundViewFrame = CGRectMake(secondBGX, secondBGY, secondBGW, secondBGH);
    
    /** 底部*/
    /** 一、顶部背景图层*/
    
    /** 用户图像*/
    self.topBackgroundViewFrame = CGRectMake(topBGX, topBGY, topBGW, topBGH);
    
    CGFloat userIconX = WB_SPACING_NORMAL;
    CGFloat userIconY = CGRectGetMaxY(self.secondBackgroundViewFrame) + 10;
    CGFloat userIconWH = 40;
    self.userIconImageViewFrame = CGRectMake(userIconX, userIconY, userIconWH, userIconWH);
    
    /** 用户名*/
    CGFloat userNameX = CGRectGetMaxX(self.userIconImageViewFrame) + WB_SPACING_NORMAL;
    CGFloat userNameY = userIconY;
    
    CGSize userNameSize = [userName sizeWithAttributes:@{NSFontAttributeName:WB_FONT_USERNAME}];
    self.userNameLabelFrame = (CGRect) {{userNameX,userNameY},userNameSize};
    
    /** 星星评分*/
    CGFloat startX = CGRectGetMinX(self.userNameLabelFrame);
    CGFloat startY = CGRectGetMaxY(self.userNameLabelFrame) + WB_SPACING_SMALL;
    CGFloat startW = 60;
    CGFloat startH = 15;
    self.startViewFrame = CGRectMake(startX, startY, startW, startH);
    
    
    // 计算cell的高度
    self.cellHeight = CGRectGetMaxY(self.userIconImageViewFrame) + WB_SPACING_SMALL;;
}

@end
