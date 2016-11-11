//
//  RandomMovieViewController.m
//  MovieFans
//
//  Created by hy on 16/2/11.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "RandomMovieViewController.h"
#import "AFHTTPSessionManager+Util.h"
#import "MovieDetailViewController.h"
#import "HotModel.h"
#import "WZYPhoto.h"
#import "UINavigationController+FDFullscreenPopGesture.h"



#define IMAGEWIDTH 120
#define IMAGEHEIGHT 160

@interface RandomMovieViewController ()
{
    NSString * _country;
    NSString * _year;
    NSString * _page;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSArray *tagArray;

@end

@implementation RandomMovieViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _backgroundView.backgroundColor = [UIColor lightGrayColor];
    }
    return _backgroundView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    // 设置背景图片
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];
    self.fd_interactivePopDisabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tagArray = @[
                  @[@"400", @"", @""],
                  @[@"", @"2015", @"2014", @"2013", @"2012", @"2011", @"2010", @"2009", @"2008"],
                  @[@"", @"2015", @"2014", @"2013", @"2012", @"2011", @"2010", @"2009", @"2008",@"2015", @"2014", @"2013", @"2012", @"2011", @"2010", @"2009", @"2008",@"2015", @"2014", @"2013", @"2012"]
                  ];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    [self customNavigationItem];
    [self requestData];
    
}


- (void)customNavigationItem{
    
    // 获取视图控制器的UINavigationItem
    UINavigationItem * naviItem = self.navigationItem;
    UIImage * leftImage = [UIImage imageNamed:@"navigationbar_icon_back"];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    naviItem.leftBarButtonItem = leftBarItem;
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"alert_failed_icon@3x"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    rightBarItem.tintColor = [UIColor whiteColor];
    naviItem.rightBarButtonItem = rightBarItem;
    
}

- (void)leftBarButtonItemClicked:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClicked:(UIBarButtonItem *)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击电影海报进入大图模式，向左滑即可查看详情" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)requestData{
    int a = arc4random() % 3;
    _country = _tagArray[0][a];
    if (a == 0) {
        int b = arc4random() % 9;
        _year = _tagArray[1][b];
        _page = [NSString stringWithFormat:@"%d",arc4random()%12+1];
    }else{
        int b = arc4random() % 21;
        if (b == 0) {
            _year = _tagArray[2][0];
            _page = [NSString stringWithFormat:@"%d",arc4random()%5+1];
        }else{
            _year = _tagArray[2][b];
            _page = [NSString stringWithFormat:@"%d",arc4random()%25+1];
        }
    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_CLASSIFY];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"count"] = @"20";
    dict[@"page"]= _page;
    dict[@"country"] = _country;
    dict[@"year"] = _year;
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * arr = responseObject[@"data"][@"ranklist_film"];
        
        NSArray * modelArr = [HotModel mj_objectArrayWithKeyValuesArray:arr];
        
        
        for (HotModel * model in modelArr) {
            [self.dataArray addObject:model];
        }
        
        
        
        // 刷新界面
        if (self.dataArray.count == 20) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createUI];
                
            });
        }
        [SVProgressHUD dismiss];
        
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        
    }];
}

- (void)createUI{
    int a = arc4random() % 10;
    for (int i = a; i < a+10; i++) {
        float X = arc4random()%((int)self.view.bounds.size.width - IMAGEWIDTH);
        float Y = arc4random()%((int)self.view.bounds.size.height - IMAGEHEIGHT);
        float W = IMAGEWIDTH;
        float H = IMAGEHEIGHT;
        
        WZYPhoto *photo = [[WZYPhoto alloc]initWithFrame:CGRectMake(X, Y, W, H)];
        //photo.delegate = self;
        HotModel * model = self.dataArray[i];
        [photo updateImage:model.large_poster_url andFilmID:[model.film_id integerValue]];
        [self.backgroundView addSubview:photo];
        
        float alpha = i*1.0/10 + 0.2;
        [photo setImageAlphaAndSpeedAndSize:alpha];
        
        photo.tag = [model.film_id integerValue];
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipImage:)];
        [swip setDirection:UISwipeGestureRecognizerDirectionLeft];
        [photo addGestureRecognizer:swip];
        //[self.photos addObject:photo];
    }

}

- (void)swipImage:(UISwipeGestureRecognizer *)sender {
    NSInteger selectedIndex = sender.view.tag;
    WZYPhoto * photo = [self.view viewWithTag:selectedIndex];
    if (photo.state == WZYPhotoStateBig) {
        MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
        MDVC.filmId = [NSString stringWithFormat:@"%ld",(long)selectedIndex];
        [self.navigationController pushViewController:MDVC animated:YES];
        
    }
}

//- (void)swipImageWithFilmId:(NSInteger)num{
//    
//    MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
//    MDVC.filmId = [NSString stringWithFormat:@"%ld",num];
//    [self.navigationController pushViewController:MDVC animated:YES];
//}

@end
