//
//  ShortReviewCell.m
//  MovieFans
//
//  Created by hy on 16/1/20.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "ShortReviewCell.h"
#import "PicBackgroundView.h"
#import "HYStarView.h"
#import "TimeSwitch.h"

@interface ShortReviewCell ()

/** 一、顶部背景图层*/
@property (nonatomic,strong) UIView *topBackgroundView;

/** 用户图像*/
@property (nonatomic, strong) UIImageView *userIconImageView;

/** 用户名*/
@property (nonatomic, strong) UILabel *userNameLabel;

/** 评分*/
@property (nonatomic, strong) UIView *startView;

/**发布时间*/
@property (nonatomic, strong) UILabel *wbCreateTimeLabel;

/** 二、发布的微博内容背景图层*/
@property (nonatomic, strong) UIView *secondBackgroundView;

/** 微博文字内容*/
@property (nonatomic, strong) UILabel *wbContentLable;

/** 微博图片内容的背景图层*/
@property (nonatomic, strong) PicBackgroundView *wbPicsBackgroundView;

/** 三、底部图层*/
@property (nonatomic, strong)UIView *bottomBackgroundView;

@property (nonatomic, strong) UIImageView * titleimageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) UIView *lineView;
@end


@implementation ShortReviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化所有的子控件，并设置一次性的属性
        [self generateSubViews];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/** 初始化所有的子控件*/
- (void)generateSubViews
{
    /** 一、顶部背景图层*/
    self.topBackgroundView = [[UIView alloc] init];
    [self.contentView addSubview:self.topBackgroundView];
    
    /** 用户图像*/
    self.userIconImageView = [[UIImageView alloc] init];
    [self.topBackgroundView addSubview:self.userIconImageView];
    self.userIconImageView.layer.masksToBounds = YES;
    
    /** 用户名*/
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.font = WB_FONT_USERNAME;
    [self.topBackgroundView addSubview:self.userNameLabel];
    
    self.startView = [[UIView alloc]init];
    [self.topBackgroundView addSubview:self.startView];
    
    
    /** 微博发布时间*/
    self.wbCreateTimeLabel = [[UILabel alloc] init];
    self.wbCreateTimeLabel.font = WB_FONT_TIME;
    [self.topBackgroundView addSubview:self.wbCreateTimeLabel];
    

    
    /*============ 我是快乐的分割======================*/
    
    
    /** 二、用户自己发布的微博内容背景图层*/
    self.secondBackgroundView = [[UIView alloc] init];
    [self.contentView addSubview:self.secondBackgroundView];
    
    
    /** 微博文字内容*/
    self.wbContentLable = [[UILabel alloc] init];
    self.wbContentLable.font = WB_FONT_USERNAME;
    self.wbContentLable.numberOfLines = 0;
    [self.secondBackgroundView addSubview:self.wbContentLable];
    
    
    /** 微博图片内容的背景图层*/
    self.wbPicsBackgroundView =[[PicBackgroundView alloc] init];
    [self.secondBackgroundView addSubview:self.wbPicsBackgroundView];
    
    
    /*============ 我是快乐的分割======================*/
    
     /** 底部图层*/
    self.bottomBackgroundView = [[UIView alloc] init];
    [self.contentView addSubview:self.bottomBackgroundView];
    
    self.titleimageView = [[UIImageView alloc]init];
    [self.bottomBackgroundView addSubview:self.titleimageView];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.bottomBackgroundView addSubview:self.titleLabel];
    
    self.promptLabel = [[UILabel alloc]init];
    [self.bottomBackgroundView addSubview:self.promptLabel];
    
    self.lineView = [[UIView alloc]init];
    [self.bottomBackgroundView addSubview:self.lineView];

}

- (void)setFrameModel:(ShortFrameModel *)frameModel{
    _frameModel =frameModel;
    ReviewInfoModel * reviewModel = frameModel.reviewModel;
    NSDictionary * userDic = (id)reviewModel.user;
    NSString * userName = [userDic valueForKey:@"name"];
    NSString * userIcon = [userDic valueForKey:@"avatar_large"];
    
    /** 第一块*/
    self.topBackgroundView.frame = frameModel.topBackgroundViewFrame;
    /** 用户图像*/
    NSURL *userIconUrl = [NSURL URLWithString:userIcon] ;
    
    [self.userIconImageView sd_setImageWithURL:userIconUrl placeholderImage:[UIImage imageNamed:@"profile_Head_gray"]];
    self.userIconImageView.frame = frameModel.userIconImageViewFrame;
    
    /** 用户名*/
    self.userNameLabel.text = userName;
    self.userNameLabel.textColor = [UIColor grayColor];
    self.userNameLabel.frame = frameModel.userNameLabelFrame;
    
    
    //星星评分
    self.startView.frame = frameModel.startViewFrame;
    float score = [HYStarView scroeToStarWith:reviewModel.score];
    int a = score * 2;
    if (a % 2 == 0) {
        for (int j = 0; j < 5;j++ ) {
            UIImageView * imageView =[[UIImageView alloc]init];
            if (j < a/2) {
                imageView.image = [UIImage imageNamed:@"rating_smallstar_selected_light"];
            }else{
                imageView.image = [UIImage imageNamed:@"rating_smallstar_unchecked_light"];
            }
            imageView.frame = CGRectMake(j*11,5, 10, 10);
            //        imageView.center = CGPointMake(_fxView.center.x-40+i*12, _fxView.center.y-30);
            [self.startView addSubview:imageView];
        }
    }else{
        for (int j = 0; j < 5;j++ ) {
            UIImageView * imageView =[[UIImageView alloc]init];
            if (j < a/2) {
                imageView.image = [UIImage imageNamed:@"rating_smallstar_selected_light"];
            }else if(j == a/2){
                imageView.image = [UIImage imageNamed:@"rating_smallstar_half_light"];
            }else{
                imageView.image = [UIImage imageNamed:@"rating_smallstar_unchecked_light"];
            }
            
            imageView.frame = CGRectMake(j*11,5, 10, 10);
            [self.startView addSubview:imageView];
        }
    }
    
    
    /** 发布时间*/
    NSString * time = [NSString stringWithFormat:@"%ld",(long)reviewModel.created_at];
    self.wbCreateTimeLabel.textColor = [UIColor lightGrayColor];
    self.wbCreateTimeLabel.text = [TimeSwitch timeSwitch:time];
    self.wbCreateTimeLabel.textAlignment = NSTextAlignmentRight;

   // self.wbCreateTimeLabel.text = [TimeSwitch timeSwitch:[NSString stringWithFormat:@"ld",reviewModel.created_at]] ;
    CGRect ctFrame = frameModel.wbCreateTimeLabelFrame;
    
    self.wbCreateTimeLabel.frame = ctFrame;
    
    /** 第二块*/
    /** 二、用户自己发布的微博内容背景图层*/
    self.secondBackgroundView.frame = frameModel.secondBackgroundViewFrame;
    
    /** 1.微博文字内容*/
    self.wbContentLable.text = reviewModel.text;
    self.wbContentLable.frame = frameModel.wbContentLableFrame;
    //self.wbContentLable.backgroundColor = [UIColor orangeColor];
    
    
    /** 2.微博图片内容的背景图层*/
    [self.wbPicsBackgroundView showPicsWithArray:reviewModel.large_pics];
    self.wbPicsBackgroundView.frame = frameModel.wbPicsBackgroundViewFrame;
    
    
    
    self.bottomBackgroundView.frame = frameModel.bottomBackgroundViewFrame;
    //self.bottomBackgroundView.backgroundColor = [UIColor greenColor];
    
    self.titleimageView.image = [UIImage imageNamed:@"weibo_movie_empty_offline"];
    self.titleimageView.frame = frameModel.titleimageViewFrame;
    
    self.titleLabel.text = reviewModel.film_name;
    self.titleLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:15];;
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.titleLabel.frame = frameModel.titleLabelFrame;
    
    self.promptLabel.text = self.promtString; 
    self.promptLabel.font = [UIFont systemFontOfSize:12];
    self.promptLabel.textColor = [UIColor redColor];
    self.promptLabel.frame = frameModel.promptLabelFrame;

    self.lineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    [self.bottomBackgroundView addGestureRecognizer:tapGesture];
}

- (void)layoutSubviews
{
//    [super layoutSubviews];
    ReviewInfoModel * reviewModel = _frameModel.reviewModel;
    self.userIconImageView.layer.cornerRadius = CGRectGetWidth(self.userIconImageView.frame) * 0.5;
    //self.wbCreateTimeLabel.text = [TimeSwitch timeSwitch:[NSString stringWithFormat:@"ld",reviewModel.created_at]] ;
    NSString * time = [NSString stringWithFormat:@"%ld",(long)reviewModel.created_at];
    self.wbCreateTimeLabel.text = [TimeSwitch timeSwitch:time];
    self.promptLabel.text = self.promtString;

}

- (void)setCellNumber:(NSInteger)cellNumber{
    _cellNumber = cellNumber;
}

// 手势识别器响应方法
- (void)onTap:(UITapGestureRecognizer *)sender
{
    
    //    // 通过push方式显示
    if ([self.delegate respondsToSelector:@selector(choseMovieInfoTerm:)]) {
        
        [_delegate choseMovieInfoTerm:_cellNumber];
    }
}

@end
