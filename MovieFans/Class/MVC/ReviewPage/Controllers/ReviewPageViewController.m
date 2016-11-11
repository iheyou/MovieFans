//
//  ReviewPageViewController.m
//  movies
//
//  Created by hy on 16/1/7.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "ReviewPageViewController.h"
#import "AFHTTPSessionManager+Util.h"
#import "ReviewInfoModel.h"
#import "LongReviewCell.h"
#import "ShortReviewCell.h"
#import "ShortFrameModel.h"
#import "LongReviewDetailViewController.h"
#import "MovieDetailViewController.h"

@interface ReviewPageViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ClickMovieInfoCellDelegate>
{
    UIScrollView * _scrollview;
    NSInteger _currentPage; //记录当前请求的page
    NSMutableDictionary * _dataDict;
    
}

@property (nonatomic,strong)  UIButton *hotButton;
@property (nonatomic,strong)  UIButton *advanceButton;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *anotherDataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger anotherPage;
@property (nonatomic, assign) NSInteger tempPage;
@property (nonatomic, assign) NSInteger anotherTempPage;
@property (nonatomic, strong) NSMutableArray *idListArray;
@property (nonatomic, strong) NSMutableArray *lastIDArray;

@end

@implementation ReviewPageViewController {
    UITableView *_hotTableView;
    UITableView *_neWestTableView;
}

- (NSMutableArray *)dataArray
{
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)anotherDataArray{
    
    if (_anotherDataArray == nil) {
        _anotherDataArray = [NSMutableArray array];
    }
    return _anotherDataArray;
}

- (NSMutableArray *)idListArray{
    if (_idListArray == nil) {
        _idListArray = [NSMutableArray array];
    }
    return _idListArray;
}

- (NSMutableArray *)lastIDArray{
    if (_lastIDArray == nil) {
        _lastIDArray = [NSMutableArray array];
    }
    return _lastIDArray;
}

// 当前视图控制器是否支持旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    self.tabBarController.tabBar.hidden = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigationBarButton];
    _page = 1;
    _anotherPage = 1;
    UITableView * tableView = [_scrollview viewWithTag:100];
    [tableView.mj_header beginRefreshing];
}

- (void)customNavigationBarButton{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.navigationController.navigationBar.translucent = YES;
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _scrollview.pagingEnabled = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = YES;
    _scrollview.bounces = NO;
    //_scrollview.alwaysBounceHorizontal = NO;
    _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH * 2,SCREEN_HEIGHT-64);
    _scrollview.delegate = self;
    
    [self.view addSubview:_scrollview];
    
    
    _hotTableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT)];
    _hotTableView.delegate = self;
    _hotTableView.dataSource = self;
    //tbView.estimatedRowHeight = 290;
    _hotTableView.tag = 100;
    [_scrollview addSubview:_hotTableView];
    //添加下拉刷新
    HYWeakSelf(self);
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //先记录下拉之前的page
        _tempPage = _page;
        //1.将page变成1，刷新首页数据
        _page = 1;
        //2.重新请求数据
        [weakself requestDataWithHotFirst];
    }];
    _hotTableView.mj_header = header;
    header.stateLabel.font = [UIFont fontWithName:@"Party LET" size:13];
    header.stateLabel.textColor = [UIColor redColor];
    header.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"Georgia" size:13];
    
    
    [_hotTableView registerNib:[UINib nibWithNibName:@"LongReviewCell" bundle:nil] forCellReuseIdentifier:@"LongReviewCell"];
    _hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    _neWestTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH , 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT)];
    _neWestTableView.delegate = self;
    _neWestTableView.dataSource = self;
    //tbView1.rowHeight = 170;
    _neWestTableView.tag = 101;
    [_scrollview addSubview:_neWestTableView];
    
    //添加下拉刷新
    MJRefreshNormalHeader * header1 = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //先记录下拉之前的page
        _anotherTempPage = _anotherPage;
        //1.将page变成1，刷新首页数据
        _anotherPage = 1;
        //2.重新请求数据
        [weakself requestDataWithAdvance];
    }];
    _neWestTableView.mj_header = header1;
    header1.stateLabel.font = [UIFont fontWithName:@"Party LET" size:13];
    header1.stateLabel.textColor = [UIColor redColor];
    header1.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"Georgia" size:13];
    
    [_neWestTableView registerNib:[UINib nibWithNibName:@"LongReviewCell" bundle:nil] forCellReuseIdentifier:@"LongReviewCell"];
    _neWestTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 35)];
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 37, 50, 2)];
    _lineView.backgroundColor = [UIColor yellowColor];
    [view addSubview:_lineView];
    
    _hotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hotButton.frame = CGRectMake(0, 0, 60, 30);
    [_hotButton setTitle:@"热门" forState:UIControlStateNormal];
    [_hotButton addTarget:self action:@selector(hotButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [_hotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _hotButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    [view addSubview:_hotButton];
    
    _advanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _advanceButton.frame = CGRectMake(60, 0, 60, 30);
    [_advanceButton setTitle:@"最新" forState:UIControlStateNormal];
    _advanceButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_advanceButton addTarget:self action:@selector(advanceButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [_advanceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:_advanceButton];
    
    self.navigationItem.titleView = view;
    
}

- (void)hotButtonClicked:(UIButton *)sender{
    
    _scrollview.contentOffset = CGPointMake(0, 0);
    _hotButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    _advanceButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    //    [_listButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.6 animations:^{
        _lineView.frame = CGRectMake(5, 37, 50, 2);
    }];
}

- (void)advanceButtonClicked:(UIButton *)sender{
    if (self.anotherDataArray.count == 0) {
        _anotherPage = 1;
        UITableView * tableView = [_scrollview viewWithTag:101];
        [tableView.mj_header beginRefreshing];
    }
    _scrollview.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    
    _hotButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _advanceButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [UIView animateWithDuration:0.6 animations:^{
        _lineView.frame = CGRectMake(65, 37, 50, 2);
    }];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(_scrollview == scrollView){
        
        float Offset = scrollView.contentOffset.x + self.view.frame.size.width;
        int i = Offset / self.view.frame.size.width ;
        if (i == 1) {
            
            _hotButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
            _advanceButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [UIView animateWithDuration:0.4 animations:^{
                _lineView.frame = CGRectMake(5, 37, 50, 2);
            }];
            
        }else{
            if (self.anotherDataArray.count == 0) {
                _anotherPage = 1;
                UITableView * tableView = [_scrollview viewWithTag:101];
                [tableView.mj_header beginRefreshing];
            }
            _hotButton.titleLabel.font = [UIFont systemFontOfSize:15];
            _advanceButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
            [UIView animateWithDuration:0.4 animations:^{
                _lineView.frame = CGRectMake(65, 37, 50, 2);
            }];
        }
    }
}

#pragma mark - 数据相关
//第一页请求时需要请求所有id
- (void)requestDataWithHotFirst{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_HOT_REVIEW];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"count"]=@"10";
    dict[@"type"]=@"1";
    //dict[@"page"]=[NSString stringWithFormat:@"%ld",_page];
    UITableView * tableView = [_scrollview viewWithTag:100];
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_page == 1) {
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
                tableView.mj_footer.state = MJRefreshStateIdle;
            }
        }
        NSDictionary * dataDict = responseObject[@"data"];
        NSArray * arr = dataDict[@"feed_list"];
        self.idListArray = dataDict[@"id_list"];
        
        NSArray * modelArr = [ReviewInfoModel mj_objectArrayWithKeyValuesArray:arr];
        for (ReviewInfoModel * model in modelArr) {
            if (model.title.length != 0) {
                [self.dataArray addObject:model];
            }else{
                ShortFrameModel * frameModel = [[ShortFrameModel alloc]init];
                frameModel.reviewModel = model;
                [self.dataArray addObject:frameModel];
            }
        }
        
        // 刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_page == 1) {
                [tableView.mj_header endRefreshing];
            }else{
                [tableView.mj_footer endRefreshing];
            }
            HYWeakSelf(self);
            MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _page++;
                [weakself requestDataWithHotMore];
            }];
            footer.automaticallyRefresh = YES;
            footer.triggerAutomaticallyRefreshPercent = 0.1;
            _hotTableView.mj_footer = footer;
            [tableView reloadData];
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (_page == 1) {
            [tableView.mj_header endRefreshing];
            _page = _tempPage;
        }else{
            [tableView.mj_footer endRefreshing];
            _page--;
        }
    }];

}

- (void)requestDataWithHotMore{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_HOT_REVIEW_MORE];
    NSMutableDictionary *dict = @{}.mutableCopy;
    
    NSMutableString  * idString = [[NSMutableString alloc]init];
    
    NSInteger nowPage = _page;
    for (NSInteger i = nowPage * 10; i < (nowPage+1)*10; i++) {
        [idString appendFormat:@"%@,",_idListArray[i]];
    }
    dict[@"ids"] = idString;

    UITableView * tableView = [_scrollview viewWithTag:100];
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        //[SVProgressHUD dismiss];
        
//        if (_page == 1) {
//            if (self.dataArray.count > 0) {
//                [self.dataArray removeAllObjects];
//                tableView.mj_footer.state = MJRefreshStateIdle;
//            }
//        }
        
        NSDictionary * dataDict = responseObject[@"data"];
        NSArray * arr = dataDict[@"feed_list"];
        //self.idListArray = dataDict[@"id_list"];
        //        if (arr.count == 0) {
        //            [SVProgressHUD showInfoWithStatus:@"没有更多了"];
        //            tableView.mj_footer.state = MJRefreshStateNoMoreData;
        //            return ;
        //        }
        NSArray * modelArr = [ReviewInfoModel mj_objectArrayWithKeyValuesArray:arr];
        for (ReviewInfoModel * model in modelArr) {
            if (model.title.length != 0) {
                [self.dataArray addObject:model];
            }else{
                ShortFrameModel * frameModel = [[ShortFrameModel alloc]init];
                frameModel.reviewModel = model;
                [self.dataArray addObject:frameModel];
            }
        }
        
        // 刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_page == 1) {
                [tableView.mj_header endRefreshing];
            }else{
                [tableView.mj_footer endRefreshing];
            }
            [tableView reloadDataWithExistedHeightCache];
            
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (_page == 1) {
            [tableView.mj_header endRefreshing];
            _page = _tempPage;
        }else{
            [tableView.mj_footer endRefreshing];
            _page--;
        }
    }];

    
}

//最新影评
- (void)requestDataWithAdvance{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_HOT_REVIEW];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"count"]=@"10";
    //dict[@"page"]=[NSString stringWithFormat:@"%ld",_anotherPage];
    dict[@"type"]=@"0";
    
    if (_anotherPage == 1) {
        dict[@"first_id"] = @"";
    }
    else{
        if ([[self.anotherDataArray lastObject] isKindOfClass:[ReviewInfoModel class]]){
            ReviewInfoModel * model = [self.anotherDataArray lastObject];
            dict[@"last_id"] = model.id;
            
        }else{
            ReviewInfoModel * model = [[ReviewInfoModel alloc]init];
            ShortFrameModel * frameModel = [self.anotherDataArray lastObject];
            model = frameModel.reviewModel;
            dict[@"last_id"] = model.id;
        }
    }
    

    UITableView * tableView = [_scrollview viewWithTag:101];
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_anotherPage == 1) {
            if (self.anotherDataArray.count > 0) {
                [self.anotherDataArray removeAllObjects];
            }
        }
        NSDictionary * dataDict = responseObject[@"data"];
        NSArray * arr = dataDict[@"feed_list"];
        //self.idListArray = dataDict[@"id_list"];
            if (arr.count == 0) {
                tableView.mj_footer.state = MJRefreshStateNoMoreData;
                return ;
            }
        NSArray * modelArr = [ReviewInfoModel mj_objectArrayWithKeyValuesArray:arr];
        for (ReviewInfoModel * model in modelArr) {
            if (model.title.length != 0) {
                [self.anotherDataArray addObject:model];
            }else{
                ShortFrameModel * frameModel = [[ShortFrameModel alloc]init];
                frameModel.reviewModel = model;
                [self.anotherDataArray addObject:frameModel];
            }
        }
        if (_anotherPage == 1) {
            [tableView.mj_header endRefreshing];
            HYWeakSelf(self);
            MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _anotherPage++;
                [weakself requestDataWithAdvance];
            }];
            footer.automaticallyRefresh = YES;
            footer.triggerAutomaticallyRefreshPercent = 0.1;
            _neWestTableView.mj_footer = footer;
        }else{
            [tableView.mj_footer endRefreshing];
        }
        // 刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadDataWithExistedHeightCache];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (_anotherPage == 1) {
            [tableView.mj_header endRefreshing];
            _anotherPage = _anotherTempPage;
        }else{
            [tableView.mj_footer endRefreshing];
            _anotherPage--;
        }
    }];

    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger index = tableView.tag - 100;
    if (index == 0) {
        return self.dataArray.count;
    }else{
        return self.anotherDataArray.count;
    }
    //return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = tableView.tag - 100;
    if (index == 0) {
    if ([self.dataArray[indexPath.section] isKindOfClass:[ReviewInfoModel class]])
    {
        ReviewInfoModel * model = self.dataArray[indexPath.section];

        LongReviewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LongReviewCell"];
        if (cell == nil) {
            cell = [[LongReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LongReviewCell"];
        }
        //tableView.rowHeight = 290;
        
        cell.model = model;
        return cell;

    }else{

        static NSString *cellID = @"ShortCellID";
        
        ShortReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (cell == nil) {
            cell =[[ShortReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
//        ShortFrameModel * frameModel = [[ShortFrameModel alloc]init];
//        frameModel.reviewModel = model;
        ShortFrameModel * model = self.dataArray[indexPath.section];
        cell.frameModel = model;
        cell.delegate = self;
        cell.cellNumber = indexPath.section;
        //tableView.rowHeight = model.cellHeight;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
     }
    }
    else{

        if ([self.anotherDataArray[indexPath.section] isKindOfClass:[ReviewInfoModel class]])
            
        {
            ReviewInfoModel * model = self.anotherDataArray[indexPath.section];
            
            LongReviewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LongReviewCell"];
            if (cell == nil) {
                cell = [[LongReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LongReviewCell"];
            }
            //tableView.rowHeight = 290;
            
            cell.model = model;
            return cell;
            
        }else{
            
            static NSString *cellID = @"ShortCellID";
            
            ShortReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (cell == nil) {
                cell =[[ShortReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            //        ShortFrameModel * frameModel = [[ShortFrameModel alloc]init];
            //        frameModel.reviewModel = model;
            ShortFrameModel * model = self.anotherDataArray[indexPath.section];
            cell.frameModel = model;
            cell.delegate = self;
            cell.cellNumber = indexPath.section;
            //tableView.rowHeight = model.cellHeight;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = tableView.tag - 100;
    if (index == 0) {
        if ([self.dataArray[indexPath.section] isKindOfClass:[ReviewInfoModel class]]){
            return 290;
        }else{
            ShortFrameModel * model = self.dataArray[indexPath.section];
            return model.cellHeight;
        }
        
    }else{
        if ([self.anotherDataArray[indexPath.section] isKindOfClass:[ReviewInfoModel class]]){
            return 290;
        }else{
            ShortFrameModel * model = self.anotherDataArray[indexPath.section];
            return model.cellHeight;
        }
    
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = tableView.tag - 100;
    if (index == 0) {

    if ([self.dataArray[indexPath.section] isKindOfClass:[ReviewInfoModel class]]){
        
        ReviewInfoModel * model = self.dataArray[indexPath.section];
        LongReviewDetailViewController * LDVC = [[LongReviewDetailViewController alloc]init];
    
        LDVC.ID = model.id;
        [self.navigationController pushViewController:LDVC animated:YES];
    }
    }else{
        
        if ([self.anotherDataArray[indexPath.section] isKindOfClass:[ReviewInfoModel class]]){
            
            ReviewInfoModel * model = self.anotherDataArray[indexPath.section];
            LongReviewDetailViewController * LDVC = [[LongReviewDetailViewController alloc]init];
            
            LDVC.ID = model.id;
            [self.navigationController pushViewController:LDVC animated:YES];
        }

        
    }
}

#pragma mark - ClickMovieCellDelegate
-(void)choseMovieInfoTerm:(NSInteger)num
{
    // 取出对应的模型数据
    float Offset = _scrollview.contentOffset.x + self.view.frame.size.width;
    int i = Offset / self.view.frame.size.width ;
    if (i == 1) {
    ReviewInfoModel * reviewModel = [[ReviewInfoModel alloc]init];
    ShortFrameModel * model = self.dataArray[num];
    reviewModel = model.reviewModel;
    MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
    MDVC.filmId = reviewModel.film_id;
    [self.navigationController pushViewController:MDVC animated:YES];
    }else{
        ReviewInfoModel * reviewModel = [[ReviewInfoModel alloc]init];
        ShortFrameModel * model = self.anotherDataArray[num];
        reviewModel = model.reviewModel;
        MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
        MDVC.filmId = reviewModel.film_id;
        [self.navigationController pushViewController:MDVC animated:YES];

    }
}


@end
