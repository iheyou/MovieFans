//
//  HYActorRelationListController.m
//  MovieFans
//
//  Created by hy on 2016/10/10.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYActorRelationListController.h"
#import "HotModel.h"
#import "SearchResultCell.h"
#import "MovieDetailViewController.h"

@interface HYActorRelationListController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation HYActorRelationListController {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSUInteger _currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"全部代表作品";
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor navigationStyleColor]];
    _tableView.delegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"SearchResultCell" bundle:nil] forCellReuseIdentifier:@"RelationListCell"];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClicked)];
    leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    HYWeakSelf(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself requestData:YES];
    }];
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself requestData:NO];
    }];
    _tableView.mj_footer = footer;
    
}

- (void)requestData:(BOOL)refresh {
    if (_dataArray == nil) {
        _dataArray = @[].mutableCopy;
    }
    if (refresh) {
        _currentPage = 1;
        [_dataArray removeAllObjects];
    } else {
        _currentPage += 1;
    }
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:@(20) forKey:@"count"];
    [dic setObject:@(_currentPage) forKey:@"page"];
    [dic setObject:self.artist_id forKey:@"artist_id"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_ACTOR_MOVIE];
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = responseObject[@"data"][@"profile_film"];
        if (array.count == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            NSArray *modelArray = [HotModel mj_objectArrayWithKeyValuesArray:array];
            for (HotModel *model in modelArray) {
                [_dataArray addObject:model];
            }
            [_tableView.mj_header endRefreshing];
            [_tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelationListCell"];
    if (cell == nil) {
        cell = [[SearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RelationListCell"];
    }
    HotModel * model = _dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
    HotModel * model = _dataArray[indexPath.row];
    MDVC.filmId = model.film_id;
    
    [self.navigationController pushViewController:MDVC animated:YES];
    
}

#pragma mark otherEvents
- (void)leftBarButtonClicked {
    [self.navigationController popViewControllerAnimated:NO];
}

@end
