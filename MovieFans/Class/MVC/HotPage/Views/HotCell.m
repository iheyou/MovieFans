//
//  HotCell.m
//  MovieFans
//
//  Created by hy on 16/1/7.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HotCell.h"
#import "UIImageView+WebCache.h"

@interface HotCell ()

@property (weak, nonatomic) IBOutlet UIImageView *hyImageView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UILabel *scroeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *scroeCountLabel;

@end

@implementation HotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scroeLabel.highlightedTextColor = [UIColor whiteColor];
    self.imageView.clipsToBounds = YES;
    //self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //[self.imageView sizeToFit];
    //图片contentModel
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    //self.gradientLayer.borderWidth = 0;
    
    self.gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.gradientView.bounds.size.height);
    
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                  (__bridge id)[UIColor blackColor].CGColor];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    //self.gradientLayer.locations = @[@(0.5f) ,@(1.0f)];
    
    [self.gradientView.layer addSublayer:self.gradientLayer];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    for (UIView *subview in self.contentView.superview.subviews) {
//        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
//            subview.hidden = NO;
//        }
//    }
//}

- (void)setModel:(HotModel *)model{
    _model = model;
   [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.poster_url]placeholderImage:[UIImage imageNamed:@"weibo movie_yingping_pic_placeholder"]];
    self.commentImageView.image = [UIImage imageNamed:@"home_comment"];
    self.scroeLabel.text = model.score;
    self.nameLabel.text = model.name;
    if (model.score_count < 10000) {
        self.scroeCountLabel.text = [NSString stringWithFormat:@"%ld人点评",(long)model.score_count];
    }else{
        long scoreCount = model.score_count / 10000;
        self.scroeCountLabel.text = [NSString stringWithFormat:@"%ld万人点评",scoreCount];
    }
}

- (void)scrollImageInTableview:(UITableView *)tableView inView:(UIView *)view{
    
    //1.获取当前cell在vc.view中的相对frame
    CGRect inSuperViewRect = [tableView convertRect:self.frame toView:view];
    //2.获取当前cell的起始 y 离vc.view的中线的距离
    CGFloat disFromCenterY = CGRectGetMidY(view.frame) - CGRectGetMinY(inSuperViewRect);
    //3.获取ImageView的高度和cell高度的差值
    CGFloat diff = CGRectGetHeight(self.imageView.frame) - CGRectGetHeight(self.frame);
    //4.获取移动多少像素 用cell离中线y距离和整个vc.view的高度之比 乘以图片和cell的高度差
    CGFloat moveDis = disFromCenterY / CGRectGetHeight(view.frame) * diff;
    //5.让图片的frame移动距离 --moveDis
    CGRect scrollRect = self.imageView.frame;
    scrollRect.origin.y = - (diff/2.0) + moveDis;
    self.imageView.frame = scrollRect;
}


@end
