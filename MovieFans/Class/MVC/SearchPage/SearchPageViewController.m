//
//  SearchPageViewController.m
//  MovieFans
//
//  Created by hy on 16/2/7.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "SearchPageViewController.h"
#import "AFHTTPSessionManager+Util.h"
#import "MovieDetailViewController.h"
#import "HotModel.h"
#import "SearchResultCell.h"


@interface SearchPageViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

{
    NSInteger _currentPage; //记录当前请求的page
}

@property(nonatomic,strong)UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger tempPage;
@property (nonatomic, copy) NSString *keyWord;

@end

@implementation SearchPageViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchResultCell" bundle:nil] forCellReuseIdentifier:@"SearchResultCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self customNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //    self.tableView.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];

}

- (void)customNavigationItem{
    // 获取视图控制器的UINavigationItem
    UINavigationItem * naviItem = self.navigationItem;
    
    UIImage * leftImage = [UIImage imageNamed:@"navigationbar_icon_back"];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    naviItem.leftBarButtonItem = leftBarItem;
    
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    // 将UISearchBar添加到UITableView的表头
    naviItem.titleView = searchBar;
    searchBar.delegate = self;
    searchBar.placeholder = @"电影,影人";
    // 显示取消按钮
    searchBar.showsCancelButton = YES;
    
    
    __weak typeof (self) weakSelf = self;
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [weakSelf requestData];
    }];
    footer.automaticallyRefresh = NO;
    self.tableView.mj_footer = footer;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)leftBarButtonItemClicked:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark - UISearchBarDelegate
// 点击Cancel按钮回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // 清空输入框内容、收起键盘
    searchBar.text = nil;
    [searchBar resignFirstResponder];
}

// 点击键盘上搜索时回调
// 跳转到搜索界面显示搜索结果
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.keyWord = searchBar.text;
    _page = 1;
    
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    
    [self requestData];
    [searchBar resignFirstResponder];

}


- (void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_SEARCH];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"count"] = @"20";
    dict[@"page"]=[NSString stringWithFormat:@"%ld",(long)_page];
    dict[@"search_key"] = self.keyWord;
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_page == 1) {
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }
        }
        NSArray * arr = responseObject[@"data"][@"ranklist_search"];
        if (arr.count == 0) {
            if (_page == 1) {
                [SVProgressHUD showInfoWithStatus:@"抱歉，没有相关电影"];
                return;
            }else{
                [SVProgressHUD showInfoWithStatus:@"没有更多了"];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                return ;
            }
        }
        NSArray * modelArr = [HotModel mj_objectArrayWithKeyValuesArray:arr];
        
        
        for (HotModel * model in modelArr) {
            [self.dataArray addObject:model];
        }
        
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        
        // 刷新界面
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
            
            [self.tableView reloadData];
            
        });
        
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
       
        [self.tableView.mj_footer endRefreshing];
        _page--;
        
    }];
}

#pragma mark - UITableViewDatasource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    if (cell == nil) {
        cell = [[SearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchResultCell"];
    }
    
    HotModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
    HotModel * model = self.dataArray[indexPath.row];
    MDVC.filmId = model.film_id;
    
    [self.navigationController pushViewController:MDVC animated:YES];
    
}



@end
