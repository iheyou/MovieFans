//
//  ShortReviewListViewController.m
//  MovieFans
//
//  Created by hy on 16/1/21.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "ShortReviewListViewController.h"
#import "AFHTTPSessionManager+Util.h"
#import "ReviewInfoModel.h"
#import "ShortReviewCell.h"
#import "ShortFrameModel.h"

@interface ShortReviewListViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSInteger _currentPage; //记录当前请求的page
}

@property(nonatomic,strong)UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger tempPage;
@property (nonatomic, strong) NSMutableArray *idArray;

@end

@implementation ShortReviewListViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)idArray{
    if (!_idArray) {
        _idArray = [NSMutableArray array];
    }
    return _idArray;
}

-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    // 设置背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
    [self customNavigationItem];
    [self customUI];
    //[self requestData];
    //[self.tableView registerNib:[UINib nibWithNibName:@"LongReviewCell" bundle:nil] forCellReuseIdentifier:@"LongReviewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tabBarController.tabBar.hidden = YES;
    _page = 1;
    [self.tableView.mj_header beginRefreshing];
    
}


- (void)customNavigationItem{
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"热门短评";
    
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

- (void)customUI{
    
    //_tableView.backgroundColor = [UIColor lightGrayColor];
    
    HYWeakSelf(self);
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //先记录下拉之前的page
        _tempPage = _page;
        //1.将page变成1，刷新首页数据
        _page = 1;
        //2.重新请求数据
        [weakself requestData];
    }];
    
    self.tableView.mj_header = header;
    header.stateLabel.font = [UIFont fontWithName:@"Party LET" size:13];
    header.stateLabel.textColor = [UIColor redColor];
    header.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"Georgia" size:13];
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [weakself requestData];
    }];
    footer.automaticallyRefresh = NO;
    self.tableView.mj_footer = footer;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

//数据请求
- (void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_SHORTREVIEW];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"count"] = @"10";
    dict[@"page"]=[NSString stringWithFormat:@"%ld",(long)_page];
    dict[@"film_id"] = self.filmId;
    
    dict[@"since_id"] = [self.idArray lastObject];
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_page == 1) {
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }
        }
        NSArray * arr = responseObject[@"data"][@"list"];
        
        NSString * idString = responseObject[@"data"][@"next_since_id"];
        [self.idArray addObject:idString];
        
        if (arr.count == 0) {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            return ;
        }
        NSArray * modelArr = [ReviewInfoModel mj_objectArrayWithKeyValuesArray:arr];
        
        for (ReviewInfoModel * model in modelArr) {
            ShortFrameModel * frameModel = [[ShortFrameModel alloc]init];
            frameModel.reviewModel = model;
            [self.dataArray addObject:frameModel];
        }
//        ShortFrameModel * frameModel = [self.dataArray lastObject];
//        ReviewInfoModel * model = frameModel.reviewModel;
//        NSString * idString = model.id;
//        [self.idArray addObject:idString];
        
        // 刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_page == 1) {
                [self.tableView.mj_header endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
            
        });

    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (_page == 1) {
            [self.tableView.mj_header endRefreshing];
            _page = _tempPage;
        }else{
            [self.tableView.mj_footer endRefreshing];
            _page--;
        }
        
    }];
}

#pragma mark - UITableViewDatasource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShortFrameModel * model = self.dataArray[indexPath.section];
    return model.cellHeight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ShortCellID";
    
    ShortReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell =[[ShortReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    ShortFrameModel * model = self.dataArray[indexPath.section];
    cell.frameModel = model;
//    tableView.rowHeight = model.cellHeight;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}



@end
