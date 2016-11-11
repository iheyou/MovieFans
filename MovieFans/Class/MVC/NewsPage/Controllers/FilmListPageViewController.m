//
//  NewsPageViewController.m
//  movies
//
//  Created by hy on 16/1/7.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "FilmListPageViewController.h"
#import "AFHTTPSessionManager+Util.h"
#import "FilmListModel.h"
#import "RelationMovieCell.h"
#import "ListDetailGuideViewController.h"
#import "MovieDetailViewController.h"
#import "WZYCustomMenu.h"
#import "ClassifyViewController.h"
#import "ShakeViewController.h"
#import "SearchPageViewController.h"

@interface FilmListPageViewController ()<UITableViewDataSource,UITableViewDelegate,ClickRelationInfoCellDelegate,WZYCustomMenuDelegate>

@property(nonatomic,strong)UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) NSMutableArray *otherInfoArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger tempPage;
@property (nonatomic, strong) WZYCustomMenu *menu;

@end

@implementation FilmListPageViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)picArray{
    if (!_picArray) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
}

- (NSMutableArray *)otherInfoArray{
    if (!_otherInfoArray) {
        _otherInfoArray = [NSMutableArray array];
    }
    return _otherInfoArray;
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
    self.tabBarController.tabBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self customUI];
    [self customNavigationItem];
    [self.tableView registerNib:[UINib nibWithNibName:@"RelationMovieCell" bundle:nil] forCellReuseIdentifier:@"RelationMovieCell"];
    _page = 1;
    [self.tableView.mj_header beginRefreshing];

}

- (void)customNavigationItem{
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"影单";
    
    UINavigationItem * naviItem = self.navigationItem;
    UIImage * rightImage = [UIImage imageNamed:@"movie_all_search"];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    rightBarItem.tintColor = [UIColor whiteColor];
    naviItem.rightBarButtonItem = rightBarItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"schoolListItem.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showList:)];
    leftItem.tintColor = [UIColor whiteColor];
    naviItem.leftBarButtonItem = leftItem;
}

- (void)showList:(UIBarButtonItem *)barButtonItem
{
    __weak __typeof(self) weakSelf = self;
    if (!self.menu) {
        self.menu = [[WZYCustomMenu alloc] initWithDataArr:@[@"随机推荐", @"分类筛选"] origin:CGPointMake(0, 0) width:125 rowHeight:44];
        _menu.delegate = self;
        _menu.dismiss = ^() {
            weakSelf.menu = nil;
        };
        _menu.arrImgName = @[@"item_battle.png", @"item_list.png"];
        [self.view addSubview:_menu];
    } else {
        [_menu dismissWithCompletion:^(WZYCustomMenu *object) {
            weakSelf.menu = nil;
        }];
    }
}

- (void)CustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ShakeViewController * shakeVC = [[ShakeViewController alloc]init];
        [self.navigationController pushViewController:shakeVC animated:YES];
    }
    if (indexPath.row == 1) {
        ClassifyViewController * classifyVC = [[ClassifyViewController alloc]init];
        [self.navigationController pushViewController:classifyVC animated:YES];
    }
}

- (void)rightBarButtonItemClicked:(UIBarButtonItem *)sender{
    
    SearchPageViewController * SPVC = [[SearchPageViewController alloc]init];
    [self.navigationController pushViewController:SPVC animated:YES];
    
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
        [weakself requestData:YES];
    }];
    
    self.tableView.mj_header = header;
    header.stateLabel.font = [UIFont fontWithName:@"Party LET" size:13];
    header.stateLabel.textColor = [UIColor redColor];
    header.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"Georgia" size:13];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

//数据请求
- (void)requestData:(BOOL)refresh {
    if (refresh) {
        [self.dataArray removeAllObjects];
        [self.picArray removeAllObjects];
        [self.otherInfoArray removeAllObjects];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_LIST];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"count"] = @"10";
    dict[@"page"]=[NSString stringWithFormat:@"%ld",(long)_page];
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * arr = responseObject[@"data"][@"list"];
        if (arr.count == 0) {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        } else {
            NSArray * modelArr = [FilmListModel mj_objectArrayWithKeyValuesArray:arr];
            
            
            for (FilmListModel * model in modelArr) {
                [self.dataArray addObject:model];
            }
            if (self.dataArray.count == _page * 10) {
                [self requestPic];
            }
            
            // 刷新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_page == 1) {
                    [self.tableView.mj_header endRefreshing];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            });
        }
        
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


- (void)requestPic{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_LIST_EVERYPATH];
    //循环请求数据,直到最后一组数据请求下来
    for (NSInteger i = self.dataArray.count - 10; i < self.dataArray.count; i++) {

        FilmListModel * model = self.dataArray[i];
        NSMutableDictionary *dict = @{}.mutableCopy;
        dict[@"count"] = @"20";
        dict[@"page"] = @"1";
        dict[@"id"] = model.pagelist_id;
//        dict[@"id"] = picUrl;
        dict[@"type"] = @"recommend";
        
        [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSArray * picArr = responseObject[@"data"][@"list"];
            NSArray * picModelArr = [RelationInfoModel mj_objectArrayWithKeyValuesArray:picArr];
            
            FilmListModel * filmModel = [[FilmListModel alloc]init];
            [filmModel setValuesForKeysWithDictionary:responseObject[@"data"]];
            [self.otherInfoArray addObject:filmModel];
            
            
            NSMutableArray * arr = [NSMutableArray array];
            for (RelationInfoModel * model in picModelArr) {
                [arr addObject:model];
            }
            [self.picArray addObject:arr];
            
            
            if (self.picArray.count == self.dataArray.count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadDataWithExistedHeightCache];
                    if (_page == 1) {
                        HYWeakSelf(self);
                        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            _page++;
                            [weakself requestData:NO];
                        }];
                        footer.automaticallyRefresh = YES;
                        footer.triggerAutomaticallyRefreshPercent = 0.1;
                        self.tableView.mj_footer = footer;
                    }
                });
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        }];
    }
}

#pragma mark - UITableViewDatasource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}

//footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RelationMovieCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RelationMovieCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RelationMovieCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RelationMovieCell"];
        //[cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } 
    FilmListModel * model = self.otherInfoArray[indexPath.section];
    NSMutableArray * arr = self.picArray[indexPath.section];
    cell.relationMovieArr = arr;
    cell.cellTitle = model.name;
    cell.isRandomColor = YES;
    cell.numbers = [NSString stringWithFormat:@"共%ld部",(long)model.movie_count];
    //cell.relationMovieArr = self.relationArr;
    cell.delegate = self;
    cell.detailId = model.pagelist_id;
    cell.cellNumber = indexPath.section;
    return cell;

}

#pragma mark - ClickRelationrCellDelegate
-(void)choseRelationInfoTerm:(NSInteger)num andPageID:(NSString *)pageid andCellNumber:(NSInteger)cellNumber
{
    if (num == 989) {
        ListDetailGuideViewController * LDGVC = [[ListDetailGuideViewController alloc]init];
        LDGVC.thisPageID = pageid;
        [self.navigationController pushViewController:LDGVC animated:YES];
    }else{
    // 取出对应的模型数据
    NSMutableArray * arr = self.picArray[cellNumber];
    RelationInfoModel * model = arr[num];
    MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
    MDVC.filmId = model.film_id;
    [self.navigationController pushViewController:MDVC animated:YES];
    }
    
}


@end
