//
//  AdvanceCell.m
//  MovieFans
//
//  Created by hy on 16/1/9.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "AdvanceCell.h"
#import "UIImageView+WebCache.h"

@interface AdvanceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *hyimageView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wangtoseeLabel;
@property (weak, nonatomic) IBOutlet UILabel *release_timeLabel;

@end

@implementation AdvanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.clipsToBounds = YES;

    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    //self.gradientLayer.borderWidth = 0;
    
    self.gradientLayer.frame = self.gradientView.bounds;
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                  (__bridge id)[UIColor blackColor].CGColor];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    //self.gradientLayer.locations = @[@(0.5f) ,@(1.0f)];
    [self.gradientView.layer addSublayer:self.gradientLayer];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HotModel *)model{
    
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.poster_url]placeholderImage:[UIImage imageNamed:@"weibo movie_yingping_pic_placeholder"]];
    self.nameLabel.text = model.name;
    self.release_timeLabel.text = [NSString stringWithFormat:@"%@上映",model.release_time];
    if (model.wanttosee < 10000) {
        self.wangtoseeLabel.text = [NSString stringWithFormat:@"%ld人想看",(long)model.wanttosee];
    }else{
        long wantSee = model.wanttosee / 10000;
        self.wangtoseeLabel.text = [NSString stringWithFormat:@"%ld万人想看",wantSee];
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
