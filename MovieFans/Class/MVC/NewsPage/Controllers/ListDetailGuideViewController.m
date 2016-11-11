//
//  ListDetailGuideViewController.m
//  MovieFans
//
//  Created by hy on 16/1/28.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "ListDetailGuideViewController.h"
#import "AFHTTPSessionManager+Util.h"
#import "UIImageView+WebCache.h"
#import "FXBlurView.h"
#import "TimeSwitch.h"
#import "ListDetailViewController.h"

@interface ListDetailGuideViewController ()
{
    FXBlurView * _fxView;
    CGPoint _prePoint;
    CGPoint _lastPonint;
}
@property (nonatomic, strong) NSDictionary * dict;

@end

@implementation ListDetailGuideViewController

//- (ListDetailGuideModel *)infoModel{
//    if (!_infoModel) {
//        _infoModel = [[ListDetailGuideModel alloc]init];
//    }
//    return _infoModel;
//}

- (NSDictionary *)dict{
    if (!_dict) {
        _dict = [[NSDictionary alloc]init];
    }
    return _dict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self customNavigationItem];
    self.view.backgroundColor = [UIColor clearColor];
    [self customNavigationItem];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}

- (void)customNavigationItem{
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"影单";
    
    // 获取视图控制器的UINavigationItem
    UINavigationItem * naviItem = self.navigationItem;
    
    UIImage * leftImage = [UIImage imageNamed:@"navigationbar_icon_back"];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    naviItem.leftBarButtonItem = leftBarItem;
    
}

- (void)leftBarButtonItemClicked:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI{
    
    UIImageView * backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:backgroundImageView];
    [backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[_dict valueForKey:@"cover_url"]]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.userInteractionEnabled = YES;
    
    UIView * darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    [backgroundImageView addSubview:darkView];
    darkView.backgroundColor = [UIColor blackColor];
    darkView.alpha = 0.4;
    //darkView.userInteractionEnabled = YES;
    
    _fxView = [[FXBlurView alloc]init];
    _fxView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _fxView.dynamic = YES;
    _fxView.blurRadius = 30;
    _fxView.tintColor = [UIColor clearColor];
    [backgroundImageView addSubview:_fxView];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(2*WB_SPACING_NORMAL, 150, SCREEN_WIDTH-4*WB_SPACING_NORMAL, 100)];
    [_fxView addSubview:nameLabel];
    //nameLabel.backgroundColor = [UIColor redColor];
    nameLabel.text = _dict[@"name"];
    nameLabel.font = [UIFont fontWithName:@"SentyMARUKO" size:22];
    nameLabel.numberOfLines = 0;
    nameLabel.textColor = [UIColor colorWithRed:250/255.0 green:207/255.0 blue:12/255.0 alpha:1];
    
    UITextView * introduceView = [[UITextView alloc]initWithFrame:CGRectMake(2*WB_SPACING_NORMAL, CGRectGetMaxY(nameLabel.frame), SCREEN_WIDTH-4*WB_SPACING_NORMAL, 100)];
    [_fxView addSubview:introduceView];
    introduceView.text = _dict[@"intro"];
    introduceView.textColor = [UIColor whiteColor];
    introduceView.backgroundColor = [UIColor clearColor];
    introduceView.font = [UIFont systemFontOfSize:15];
    introduceView.editable = NO;
    introduceView.userInteractionEnabled = YES;
    introduceView.scrollEnabled = YES;
    
//    introduceView.showsVerticalScrollIndicator = YES;
//    
//    CGSize size = CGSizeMake(320.0f, 600.0f);
//    [introduceView setContentSize:size];

    UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(2*WB_SPACING_NORMAL, CGRectGetMaxY(introduceView.frame)+WB_SPACING_SMALL, 30, 30)];
    [_fxView addSubview:iconImage];
    iconImage.layer.cornerRadius = 15;
    [iconImage sd_setImageWithURL:_dict[@"user"][@"avatar_large"] placeholderImage:[UIImage imageNamed:@"profile_Head_gray"]];
    
    UILabel * userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+WB_SPACING_SMALL, CGRectGetMaxY(introduceView.frame)+WB_SPACING_SMALL, 100, 15)];
    [_fxView addSubview:userNameLabel];
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.font = [UIFont systemFontOfSize:12];
    userNameLabel.text = _dict[@"user"][@"name"];
    
    UILabel * otherInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+WB_SPACING_SMALL, CGRectGetMaxY(userNameLabel.frame), 300, 15)];
    [_fxView addSubview:otherInfoLabel];
    otherInfoLabel.textColor = [UIColor whiteColor];
    otherInfoLabel.font = [UIFont systemFontOfSize:10];
    
    
    NSString * time = [NSString stringWithFormat:@"%@",_dict[@"create_time"]];
    otherInfoLabel.text = [NSString stringWithFormat:@"%@创建,共%@部电影",[TimeSwitch timeSwitch:time],_dict[@"movie_count"]];
    
    UILabel * promtLabel = [[UILabel alloc]initWithFrame:CGRectMake(2*WB_SPACING_NORMAL, CGRectGetMaxY(otherInfoLabel.frame)+50, SCREEN_WIDTH-4*WB_SPACING_NORMAL, 30)];
    [_fxView addSubview:promtLabel];
    promtLabel.textColor = [UIColor colorWithRed:250/255.0 green:207/255.0 blue:12/255.0 alpha:1];
    promtLabel.font = [UIFont systemFontOfSize:10];
    promtLabel.textAlignment = NSTextAlignmentRight;
    promtLabel.text = @"左滑查看";
    
    UISwipeGestureRecognizer * swipGresture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwip:)];
    [self.view addGestureRecognizer:swipGresture];
    swipGresture.direction = UISwipeGestureRecognizerDirectionLeft;
}


- (void)onSwip:(UISwipeGestureRecognizer *)sender{
    
    //ListDetailViewController * LDVC = [[ListDetailViewController alloc]init];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"myView"];
    ListDetailViewController * LDVC = [story instantiateViewControllerWithIdentifier:@"myView"];
    LDVC.urlID = self.thisPageID;
    LDVC.titleName = _dict[@"name"];
    LDVC.listCount = [_dict[@"movie_count"] integerValue];
    NSInteger movieCount = [_dict[@"movie_count"] integerValue];
    if (movieCount%20 != 0) {
        LDVC.maxPage = movieCount/20 + 1;
    }else{
        LDVC.maxPage = movieCount/20;
    }
    [self.navigationController pushViewController:LDVC animated:YES];

}


- (void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_LIST_DETAIL_GUIDE];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"id"] = self.thisPageID;
    
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        _dict = responseObject[@"data"][@"base_info"];
        
        
            
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createUI];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
    }];

}



@end
