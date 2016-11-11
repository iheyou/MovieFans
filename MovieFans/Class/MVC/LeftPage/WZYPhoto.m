//
//  WZYPhoto.m
//  MovieFans
//
//  Created by hy on 16/2/11.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "WZYPhoto.h"
#import "UIImageView+WebCache.h"

@implementation WZYPhoto

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        
        _timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(movePhotos) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:@"NSDefaultRunLoopMode"];
        
        self.layer.borderWidth = 2;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        //        [NSTimer scheduledTimerWithTimeInterval:1/30 target:self selector:@selector(movePhotos) userInfo:nil repeats:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
        [self addGestureRecognizer:tap];
        
//        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipImage:)];
//            [swip setDirection:UISwipeGestureRecognizerDirectionRight];
//        [self addGestureRecognizer:swip];
        
        
    }
    return self;
}

- (void)tapImage {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (self.state == WZYPhotoStateNormal) {
            self.oldFrame = self.frame;
            self.oldAlpha = self.alpha;
            self.oldSpeed = self.speed;
            self.frame = CGRectMake(20, 20, self.superview.bounds.size.width - 40, self.superview.bounds.size.height - 40);
            self.imageView.frame = self.bounds;
            [self.superview bringSubviewToFront:self];
            self.speed = 0;
            self.alpha = 1;
            self.state = WZYPhotoStateBig;
            
        } else if (self.state == WZYPhotoStateBig) {
            
            self.frame = self.oldFrame;
            self.alpha = self.oldAlpha;
            self.speed = self.oldSpeed;
            self.imageView.frame = self.bounds;
            self.state = WZYPhotoStateNormal;
        }
        
    }];
    
}

//- (void)swipImage:(UISwipeGestureRecognizer *)sender {
//
//    if (self.state == WZYPhotoStateBig) {
//        NSInteger selectedIndex = sender.view.tag;
//            if ([self.delegate respondsToSelector:@selector(swipImageWithFilmId:)]) {
//            
//            [_delegate swipImageWithFilmId:selectedIndex];
//        }
//
//    }
//}


- (void)updateImage:(NSString *)imageUrl andFilmID:(NSInteger)filmid{
    self.imageView.tag = filmid;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}


- (void)setImageAlphaAndSpeedAndSize:(float)alpha {
    self.alpha = alpha;
    self.speed = alpha;
    self.transform = CGAffineTransformScale(self.transform, alpha, alpha);
}

- (void)movePhotos {
    if (self.speed >= 0.8) {
        self.speed = self.speed * 0.6;
    }
    self.center = CGPointMake(self.center.x + self.speed, self.center.y);
    if (self.center.x > self.superview.bounds.size.width + self.frame.size.width/2) {
        self.center = CGPointMake(-self.frame.size.width/2, arc4random()%(int)(self.superview.bounds.size.height - self.bounds.size.height) + self.bounds.size.height/2);
    }
}


@end
