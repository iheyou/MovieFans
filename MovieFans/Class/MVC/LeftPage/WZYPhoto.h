//
//  WZYPhoto.h
//  MovieFans
//
//  Created by hy on 16/2/11.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYZPhotoState) {
    WZYPhotoStateNormal,
    WZYPhotoStateBig,
};

//@protocol SwipImageDelegate <NSObject>
//
//-(void)swipImageWithFilmId:(NSInteger)num;
//
//@end


@interface WZYPhoto : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) float speed;
@property (nonatomic) CGRect oldFrame;
@property (nonatomic) float oldSpeed;
@property (nonatomic) float oldAlpha;
@property (nonatomic) int state;
@property (nonatomic)NSTimer *timer;
//@property (assign, nonatomic) id<SwipImageDelegate> delegate;

- (void)updateImage:(NSString *)imageUrl andFilmID:(NSInteger)filmid;
- (void)setImageAlphaAndSpeedAndSize:(float)alpha;

@end
