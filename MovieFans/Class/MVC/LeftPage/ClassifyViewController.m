//
//  ClassifyViewController.m
//  MovieFans
//
//  Created by hy on 16/2/11.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "ClassifyViewController.h"
#import "Masonry.h"
#import "ZLDropDownMenuUICalc.h"
#import "ZLDropDownMenuCollectionViewCell.h"
#import "ZLDropDownMenu.h"
#import "AFHTTPSessionManager+Util.h"
#import "MovieDetailViewController.h"
#import "HotModel.h"
#import "SearchResultCell.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface ClassifyViewController () <ZLDropDownMenuDelegate, ZLDropDownMenuDataSource,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _currentPage; //记录当前请求的page
    NSString * _type;
    NSString * _country;
    NSString * _year;
}

@property(nonatomic,strong)UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger tempPage;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSArray *mainTitleArray;
@property (nonatomic, strong) NSArray *subTitleArray;
@property (nonatomic, strong) NSArray *tagArray;

@end

@implementation ClassifyViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 114, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-114)style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
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
    _mainTitleArray = @[@"电影类型", @"国家", @"上映时间"];
    _subTitleArray = @[
                       @[@"全部", @"剧情", @"喜剧", @"动作", @"爱情", @"科幻", @"动画", @"悬疑", @"惊悚", @"恐怖"],
                       @[@"全部", @"美国", @"大陆", @"香港",@"台湾",@"日本",@"韩国",@"英国",@"法国",@"意大利"],
                       @[@"全部", @"2016", @"2015", @"2014", @"2013", @"2012", @"2011", @"2010", @"2009", @"2008"]
                       ];
    _tagArray = @[
                       @[@"", @"200", @"201", @"202", @"203", @"204", @"205", @"206", @"207", @"208"],
                       @[@"", @"400", @"401", @"402",@"403",@"404",@"405",@"406",@"407",@"408"],
                       @[@"", @"2016", @"2015", @"2014", @"2013", @"2012", @"2011", @"2010", @"2009", @"2008"]
                       ];
    
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(64.f);
    }];
    ZLDropDownMenu *menu = [[ZLDropDownMenu alloc] init];
    [self.view addSubview:menu];
    menu.delegate = self;
    menu.dataSource = self;
    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchResultCell" bundle:nil] forCellReuseIdentifier:@"SearchResultCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self customNavigationItem];
    _page = 1;
    _currentPage = 1;
    [self requestData];
}

- (NSInteger)numberOfColumnsInMenu:(ZLDropDownMenu *)menu
{
    return self.mainTitleArray.count;
}

- (NSInteger)menu:(ZLDropDownMenu *)menu numberOfRowsInColumns:(NSInteger)column
{
    NSArray * arr = self.subTitleArray[column];
    return arr.count;
}

- (NSString *)menu:(ZLDropDownMenu *)menu titleForColumn:(NSInteger)column
{
    return self.mainTitleArray[column];
}

- (NSString *)menu:(ZLDropDownMenu *)menu titleForRowAtIndexPath:(ZLIndexPath *)indexPath
{
    NSArray *array = self.subTitleArray[indexPath.column];
    return array[indexPath.row];
}

- (void)menu:(ZLDropDownMenu *)menu didSelectRowAtIndexPath:(ZLIndexPath *)indexPath
{
    //NSArray *array = self.subTitleArray[indexPath.column];
    
    NSArray * tagArr = self.tagArray[indexPath.column];
    if (indexPath.column == 0) {
        _type = tagArr[indexPath.row];
    }
    if (indexPath.column == 1) {
        _country = tagArr[indexPath.row];
    }
    if (indexPath.column == 2) {
        _year = tagArr[indexPath.row];
    }
    _page = 1;
    _currentPage = 1;
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];

    [self requestData];
}


- (void)customNavigationItem{
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.title = @"分类筛选";
    
    // 获取视图控制器的UINavigationItem
    UINavigationItem * naviItem = self.navigationItem;
    
    UIImage * leftImage = [UIImage imageNamed:@"navigationbar_icon_back"];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    naviItem.leftBarButtonItem = leftBarItem;
    
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


- (void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_CLASSIFY];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"count"] = @"20";
    dict[@"page"]=[NSString stringWithFormat:@"%ld",(long)_page];
    dict[@"type"] = _type;
    dict[@"country"] = _country;
    dict[@"year"] = _year;
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_page == 1) {
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }
        }
        NSArray * arr = responseObject[@"data"][@"ranklist_film"];
        if (arr.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"没有更多了"];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        NSArray * modelArr = [HotModel mj_objectArrayWithKeyValuesArray:arr];
        
        
        for (HotModel * model in modelArr) {
            [self.dataArray addObject:model];
        }
        
        [SVProgressHUD dismiss];
        
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
