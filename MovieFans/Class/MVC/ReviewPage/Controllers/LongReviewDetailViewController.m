//
//  LongReviewDetailViewController.m
//  MovieFans
//
//  Created by hy on 16/1/20.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "LongReviewDetailViewController.h"
#import "AFHTTPSessionManager+Util.h"
#import "ReviewInfoModel.h"
#import "LongReviewCell.h"
#import "FXBlurView.h"
#import "DetailTableViewHeader.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+Awesome.h"
#import "MovieDetailViewController.h"
#import "HYStarView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "HYLongReviewTextCell.h"
#import "HYLongReviewImageCell.h"
#import "HYCommentsModel.h"
#import "HYCommentsCell.h"

@interface LongReviewDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    FXBlurView * _fxView;
}

@property (nonatomic, strong) ReviewInfoModel *longReviewModel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *commentsArray;

@property (nonatomic, strong) DetailTableViewHeader *headView;
@property (nonatomic, strong) UIImageView *bigImageView;

@end

@implementation LongReviewDetailViewController {
    NSInteger _lastID;
    MBProgressHUD *_HUD;
}

- (ReviewInfoModel *)longReviewModel{
    if (!_longReviewModel) {
        _longReviewModel = [[ReviewInfoModel alloc]init];
    }
    return _longReviewModel;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)commentsArray {
    if (_commentsArray == nil) {
        _commentsArray = @[].mutableCopy;
    }
    return _commentsArray;
}

-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource=self;
//        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.fd_interactivePopDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
        self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lastID = 0;
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.view addSubview:self.tableView];
    [self requestData];
    [self customNavigationItem];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)customNavigationItem{
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // 获取视图控制器的UINavigationItem
    UINavigationItem * naviItem = self.navigationItem;
    UIImage * leftImage = [UIImage imageNamed:@"navigationbar_icon_back"];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    naviItem.leftBarButtonItem = leftBarItem;
    
    
    
    _bigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    _bigImageView.clipsToBounds=YES;
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bigImageView.userInteractionEnabled = YES;
    
    
    _headView=[[DetailTableViewHeader alloc]init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _fxView = [[FXBlurView alloc] init];
    [_headView layoutWithTableView:self.tableView andBackGroundView:_bigImageView andSubviews:_fxView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    [_fxView addGestureRecognizer:tapGesture];
}

- (void)onTap:(UITapGestureRecognizer *)sender{
    MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
    MDVC.filmId = _longReviewModel.film_id;
    [self.navigationController pushViewController:MDVC animated:YES];
}


//组头自定义
- (void)createHeaderUI{
    
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:_longReviewModel.poster_url]placeholderImage:[UIImage imageNamed:@"weibo_movie_empty_offline@2x"]];
    
    //创建模糊视图
    _fxView.frame = CGRectMake(0, 130, SCREEN_WIDTH, 70);
    _fxView.dynamic = YES;
    _fxView.blurRadius = 20;
    _fxView.tintColor = [UIColor clearColor];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [_fxView addSubview:titleLabel];
    titleLabel.text = _longReviewModel.title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];;
    
    float score = [HYStarView scroeToStarWith:_longReviewModel.score];
    int a = score * 2;
    if (a % 2 == 0) {
        for (int i = 0; i < 5;i++ ) {
            UIImageView * imageView =[[UIImageView alloc]init];
            if (i < a/2) {
                imageView.image = [UIImage imageNamed:@"rating_smallstar_selected_dark"];
            }else{
                imageView.image = [UIImage imageNamed:@"rating_smallstar_unchecked_dark"];
            }
            imageView.frame = CGRectMake(10+i*12, 50, 10, 10);
            //        imageView.center = CGPointMake(_fxView.center.x-40+i*12, _fxView.center.y-30);
            [_fxView addSubview:imageView];
        }
    }else{
        for (int i = 0; i < 5;i++ ) {
            UIImageView * imageView =[[UIImageView alloc]init];
            if (i < a/2) {
                imageView.image = [UIImage imageNamed:@"rating_smallstar_selected_dark"];
            }else if(i == a/2){
                imageView.image = [UIImage imageNamed:@"rating_smallstar_half_dark"];
            }else{
                imageView.image = [UIImage imageNamed:@"rating_smallstar_unchecked_dark"];
            }
            
            imageView.frame = CGRectMake(10+i*12, 50, 10, 10);
            [_fxView addSubview:imageView];
        }
    }
    UILabel * writerLabel = [[UILabel alloc]initWithFrame:CGRectMake(78, 50, 100, 10)];
    [_fxView addSubview:writerLabel];
    writerLabel.font = [UIFont systemFontOfSize:12];
    writerLabel.textColor = [UIColor whiteColor];
    NSDictionary * dic = (id)_longReviewModel.user;
    writerLabel.text = [NSString stringWithFormat:@"影评人:%@",[dic valueForKey:@"name"]];
    
    
    UILabel * promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 50, 100, 10)];
    [_fxView addSubview:promptLabel];
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.textColor = [UIColor redColor];
                        
}

- (void)leftBarButtonItemClicked:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_tableView == scrollView) {
        UIColor * color = [UIColor navigationStyleColor];
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 0) {
            CGFloat alpha = MIN(1, 1 - ((200 - offsetY) / 200));
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
            if (alpha >= 0.8) {
                self.title = _longReviewModel.title;
            }
            [self.navigationController.navigationBar hy_setTitleAlpha:alpha];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        }
    }
}

//数据请求
- (void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_LONGREVIEW_DETAIL];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"id"] = self.ID;
    dict[@"type"] = @"long";
    dict[@"long_show"] = @"1";
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * longReviewDict = responseObject[@"data"][@"feed_long_show"] ;

        _longReviewModel = [[ReviewInfoModel alloc]init];
        [_longReviewModel setValuesForKeysWithDictionary:longReviewDict];
        
        NSArray * arr = longReviewDict[@"html_list"];
        for (NSDictionary * dic in arr) {
            [self.dataArray addObject:dic];
        }
        [self requestCommentData];
        __weak typeof(self) weakSelf = self;
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestCommentData];
        }];
        [footer setTitle:@"上拉加载更多数据" forState:MJRefreshStateIdle];
        self.tableView.mj_footer = footer;
        dispatch_async(dispatch_get_main_queue(), ^{
//            [_HUD hide:YES];
            [_HUD hideAnimated:YES];
            [self.tableView reloadData];
            [self createHeaderUI];
        });
    
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        _HUD.label.text = @"加载失败";
        [_HUD hideAnimated:YES afterDelay:2];
    }];
}

- (void)requestCommentData {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_COMMENTS];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:self.ID forKey:@"id"];
    [dic setObject:@(20) forKey:@"count"];
    if (_lastID) {
        [dic setObject:@(_lastID) forKey:@"last_id"];
    }
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
    
        NSArray *commentArr = responseObject[@"data"][@"feed_comment"];
        if (commentArr.count) {
            for (NSDictionary *dict in commentArr) {
                HYCommentsModel *model = [HYCommentsModel yy_modelWithDictionary:dict];
                [self.commentsArray addObject:model];
            }
            HYCommentsModel *model = self.commentsArray.lastObject;
            _lastID = model.comment_id;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDatasource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArray.count;
    } else {
        return self.commentsArray.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary * dic = _dataArray[indexPath.row];
        if ([dic[@"type"] isEqualToString:@"text"]) {
            HYLongReviewTextCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LongContentCell"];
            if (cell == nil) {
                cell = [[HYLongReviewTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LongContentCell"];
            }
            NSString *contentStr = dic[@"content"];
            cell.textStr = contentStr;
            return cell;
        }
        
        else{
            HYLongReviewImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LongImageViewCell"];
            if (cell == nil) {
                cell = [[HYLongReviewImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LongImageViewCell"];
            }
            cell.imageUrl = dic[@"content"];
            return cell;
        }
    } else {
        HYCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
        if (cell == nil) {
            cell = [[HYCommentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentsCell"];
        }
        cell.model = self.commentsArray[indexPath.row];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:self.tableView];
}

@end
