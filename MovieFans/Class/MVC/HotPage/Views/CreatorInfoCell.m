//
//  CreatorInfoCell.m
//  MovieFans
//
//  Created by hy on 16/1/13.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "CreatorInfoCell.h"
#import "UIImageView+WebCache.h"
#import "CreatorInfoViewController.h"


@implementation CreatorInfoCell


//- (UIViewController *)viewController
//{
//    UIResponder *next = [self nextResponder];
//    do {
//        if ([next isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)next;
//        }
//        
//        next = [next nextResponder];
//        
//    } while (next != nil);
//    
//    
//    return nil;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCreatorArr:(NSMutableArray *)creatorArr{
    _creatorArr = creatorArr;
    _numberOfCreators.text = [NSString stringWithFormat:@"%ld名主创",(unsigned long)_creatorArr.count];
    
}

// 手势识别器响应方法
- (void)onTap:(UITapGestureRecognizer *)sender
{

    NSInteger selectedIndex = sender.view.tag - CREATOR_IMAGEVIEW_TAG;

//    // 通过push方式显示
    if ([self.delegate respondsToSelector:@selector(choseCreatorTerm:)]) {
        
        [_delegate choseCreatorTerm:selectedIndex];
    }
}

- (void)layoutSubviews{
    _creatorScrollView.contentSize = CGSizeMake(10+90*_creatorArr.count,CGRectGetHeight(_creatorScrollView.frame));
    _creatorScrollView.showsHorizontalScrollIndicator = NO;
    _creatorScrollView.showsVerticalScrollIndicator = NO;
    
    if (_creatorScrollView.subviews.count != 0) {
        return;
    }
    for (int i = 0; i < _creatorArr.count; i++) {
        CreatorInfoModel * model = [[CreatorInfoModel alloc]init];
        model = _creatorArr[i];
        //        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(5+i*85, 5, 70, 70)];
        //        [_creatorScrollView addSubview:button];
        //        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.profile_image_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"profile_Head_gray"]];
        //        button.layer.cornerRadius = CGRectGetWidth(button.frame)/2;
        //        button.layer.masksToBounds = YES;
        //        button.contentMode = UIViewContentModeScaleAspectFill;
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+i*90, 10, 70, 70)];
        [_creatorScrollView addSubview:imageView];
        imageView.layer.cornerRadius = CGRectGetWidth(imageView.frame)/2;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.profile_image_url] placeholderImage:[UIImage imageNamed:@"profile_Head_gray"]];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = CREATOR_IMAGEVIEW_TAG + i;
        imageView.userInteractionEnabled = YES;
        
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+i*90, CGRectGetMaxY(imageView.frame)+3, 70, 18)];
        [_creatorScrollView addSubview:nameLabel];
        nameLabel.text = model.name;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:11];
        
        UILabel * jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+i*90, CGRectGetMaxY(nameLabel.frame)+2, 70, 18)];
        [_creatorScrollView addSubview:jobLabel];
        jobLabel.text = model.job;
        jobLabel.textAlignment = NSTextAlignmentCenter;
        jobLabel.font = [UIFont systemFontOfSize:10];
        jobLabel.textColor = [UIColor grayColor];
        
        //为图片添加手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
        [imageView addGestureRecognizer:tapGesture];
        
        
        
    }


    
}

@end
