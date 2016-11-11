//
//  HotPageViewController.m
//  movies
//
//  Created by hy on 16/1/7.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HotPageViewController.h"
#import "AFHTTPSessionManager+Util.h"
#import "HotModel.h"
#import "HotCell.h"
#import "AdvanceCell.h"
#import "MovieDetailViewController.h"
#import "SearchPageViewController.h"
#import "WZYCustomMenu.h"
#import "ClassifyViewController.h"
#import "ShakeViewController.h"
#import "GuideView.h"

@interface HotPageViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,WZYCustomMenuDelegate>
{
    UIScrollView * _scrollview;
    NSInteger _currentPage; //记录当前请求的page
    NSMutableDictionary * _dataDict;
    
}

//@property (nonatomic,strong)  UIScrollView *scrollview;
@property (nonatomic,strong)  UIButton *hotButton;
@property (nonatomic,strong)  UIButton *advanceButton;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *anotherDataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger anotherPage;
@property (nonatomic, assign) NSInteger tempPage;
@property (nonatomic, assign) NSInteger anotherTempPage;

@property (nonatomic, strong) WZYCustomMenu *menu;


@end

@implementation HotPageViewController {
    UITableView *_hotTableView;
    UITableView *_advanceTableView;
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

// 当前视图控制器是否支持旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNavigationBarButton];
    
    //[self requestData];
    _page = 1;
    _anotherPage = 1;
//     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * str = [userDefaults valueForKey:@"launched"];
//    if (str.length != 0) {
//        <#statements#>
//    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstreload) name:@"FirstReload" object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)firstreload{
    
    UITableView * tableView = [_scrollview viewWithTag:100];
    [tableView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];
    //[self guidePages];
}

//- (void)guidePages
//{
//    //数据源
//    NSArray *imageArray = @[ @"guide1.jpg", @"guide2.jpg", @"guide3.jpg", @"guide4.jpg" ];
//    
//    //  初始化方法1
//    GuideView *guide = [[GuideView alloc] init];
//    guide.imageDatas = imageArray;
//    __weak typeof(GuideView) *weakMZ = guide;
//    guide.buttonAction = ^{
//        [UIView animateWithDuration:2.0f
//                         animations:^{
//                             weakMZ.alpha = 0.0;
//                         }
//                         completion:^(BOOL finished) {
//                             [weakMZ removeFromSuperview];
//                             
//                         }];
//    };
//    [self.view addSubview:guide];
//    
//}

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

    
     _hotTableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
     _hotTableView.delegate = self;
     _hotTableView.dataSource = self;
     _hotTableView.rowHeight = 170;
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
         [weakself requestDataWithHot];
     }];
     _hotTableView.mj_header = header;
     header.stateLabel.font = [UIFont fontWithName:@"Party LET" size:13];
    header.stateLabel.textColor = [UIColor redColor];
    header.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"Georgia" size:13];
     
    
     [_hotTableView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellReuseIdentifier:@"HotCell"];
     _hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    
    _advanceTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH , 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _advanceTableView.delegate = self;
    _advanceTableView.dataSource = self;
    _advanceTableView.rowHeight = 170;
    _advanceTableView.tag = 101;
    [_scrollview addSubview:_advanceTableView];
    //添加下拉刷新

    MJRefreshNormalHeader * header1 = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //先记录下拉之前的page
        _anotherTempPage = _anotherPage;
        //1.将page变成1，刷新首页数据
        _anotherPage = 1;
        //2.重新请求数据
        [weakself requestDataWithAdvance];
    }];
    _advanceTableView.mj_header = header1;
    header1.stateLabel.font = [UIFont fontWithName:@"Party LET" size:13];
    header1.stateLabel.textColor = [UIColor redColor];
    header1.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"Georgia" size:13];
    
    [_advanceTableView registerNib:[UINib nibWithNibName:@"AdvanceCell" bundle:nil] forCellReuseIdentifier:@"AdvanceCell"];
    _advanceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 35)];
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 37, 50, 2)];
    _lineView.backgroundColor = [UIColor yellowColor];
    [view addSubview:_lineView];

    _hotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hotButton.frame = CGRectMake(0, 0, 60, 30);
    [_hotButton setTitle:@"热映" forState:UIControlStateNormal];
    [_hotButton addTarget:self action:@selector(hotButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [_hotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _hotButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
  
    [view addSubview:_hotButton];
    
    _advanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _advanceButton.frame = CGRectMake(60, 0, 60, 30);
    [_advanceButton setTitle:@"预告" forState:UIControlStateNormal];
    _advanceButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_advanceButton addTarget:self action:@selector(advanceButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [_advanceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:_advanceButton];
    
//    _listButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _listButton.frame = CGRectMake(120, 0, 60, 30);
//    [_listButton setTitle:@"影单" forState:UIControlStateNormal];
//    _listButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [_listButton addTarget:self action:@selector(listButtonClicked:) forControlEvents:UIControlEventTouchDown];
//    [_listButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [view addSubview:_listButton];
    
    self.navigationItem.titleView = view;

    
    // 获取视图控制器的UINavigationItem
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

//- (void)listButtonClicked:(UIButton *)sender{
//    
//    _scrollview.contentOffset = CGPointMake(self.view.frame.size.width * 2, 0);
//    [_listButton setTitleColor:[UIColor colorWithRed:1.000 green:0.332 blue:0.651 alpha:1.000] forState:UIControlStateNormal];
//    [_advanceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_hotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [UIView animateWithDuration:0.6 animations:^{
//    _lineView.frame = CGRectMake(125, 37, 50, 2);
//    }];
//
//}


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

//只要tableView滑动 cell就滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //需要让cell跟着滑动
    //取出显示在界面中所有的Cell
    UITableView * tableView = [_scrollview viewWithTag:100];
    UITableView * tableView1 = [_scrollview viewWithTag:101];

    if ([scrollView isEqual:tableView]) {
    
        NSArray * cells = [tableView visibleCells];

        //循环所有的可视cell 让cell里面的image的位置发生改变
        for (HotCell * cell in cells) {
            [cell scrollImageInTableview:tableView inView:self.view];
        }
    }else{
        NSArray * cells = [tableView1 visibleCells];
        
        //循环所有的可视cell 让cell里面的image的位置发生改变
        for (AdvanceCell * cell in cells) {
            [cell scrollImageInTableview:tableView1 inView:self.view];
        }

    }
   

}


- (void)requestDataWithHot{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_HOT];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"count"]=@"20";
    dict[@"page"]=[NSString stringWithFormat:@"%ld",(long)_page];
    
    UITableView * tableView = [_scrollview viewWithTag:100];

    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_page == 1) {
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
                tableView.mj_footer.state = MJRefreshStateIdle;
            }
        }
        NSDictionary * dataDict = responseObject[@"data"];
        NSArray * arr = dataDict[@"ranklist_hot"];
        if (arr.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"没有更多了"];
            tableView.mj_footer.state = MJRefreshStateNoMoreData;
            return ;
        }
        NSArray * modelArr = [HotModel mj_objectArrayWithKeyValuesArray:arr];

        for (HotModel * model in modelArr) {
            [self.dataArray addObject:model];
        }
        
        // 刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_page == 1) {
                [tableView.mj_header endRefreshing];
            }else{
                [tableView.mj_footer endRefreshing];
            }
            [tableView reloadData];
            HYWeakSelf(self);
            MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _page++;
                [weakself requestDataWithHot];
            }];
            footer.automaticallyRefresh = NO;
            _hotTableView.mj_footer = footer;
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


- (void)requestDataWithAdvance{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_ADVANCE];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"count"]=@"20";
    dict[@"page"]=[NSString stringWithFormat:@"%ld",(long)_anotherPage];
    
    UITableView * tableView = [_scrollview viewWithTag:101];
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_anotherPage == 1) {
            if (self.anotherDataArray.count > 0) {
                [self.anotherDataArray removeAllObjects];
                tableView.mj_footer.state = MJRefreshStateIdle;
            }
        }
        NSDictionary * dataDict = responseObject[@"data"];
        NSArray * arr = dataDict[@"ranklist_coming"];
        if (arr.count == 0) {
            tableView.mj_footer.state = MJRefreshStateNoMoreData;
            return ;
        }
        NSArray * modelArr = [HotModel mj_objectArrayWithKeyValuesArray:arr];
        
        for (HotModel * model in modelArr) {
            [self.anotherDataArray addObject:model];
        }
        // 刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_anotherPage == 1) {
                [tableView.mj_header endRefreshing];
            }else{
                [tableView.mj_footer endRefreshing];
            }
            [tableView reloadData];
            HYWeakSelf(self);
            MJRefreshAutoNormalFooter * footer1 = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _anotherPage++;
                [weakself requestDataWithAdvance];
            }];
            footer1.automaticallyRefresh = NO;
            _advanceTableView.mj_footer = footer1;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger index = tableView.tag - 100;
    if (index == 0) {
        return self.dataArray.count;
    }else{
        return self.anotherDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = tableView.tag - 100;
    if (index == 0) {
        HotCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HotCell" forIndexPath:indexPath];
        HotModel * model = self.dataArray[indexPath.row];
        cell.model = model;
        return cell;
        
    }else{
        AdvanceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AdvanceCell" forIndexPath:indexPath];
        HotModel * model = self.anotherDataArray[indexPath.row];
        cell.model = model;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = tableView.tag - 100;
    HotModel * model = [[HotModel alloc]init];
    MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
    if (index == 0) {
        model = self.dataArray[indexPath.row];
    }else{
        model = self.anotherDataArray[indexPath.row];
    }
    MDVC.filmId = model.film_id;
    [self.navigationController pushViewController:MDVC animated:YES];
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    MDVC.navigationController.navigationBar.titleTextAttributes = dict;
    MDVC.navigationItem.hidesBackButton = YES;

//    [MDVC.navigationController.navigationItem.leftBarButtonItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_icon_back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    MDVC.title = model.name;

}

@end
