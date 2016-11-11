//
//  CreatorInfoViewController.m
//  MovieFans
//
//  Created by hy on 16/1/14.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "CreatorInfoViewController.h"
#import "CreatorTableViewHeader.h"
#import "UINavigationBar+Awesome.h"
#import "AFHTTPSessionManager+Util.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+LBBlurredImage.h"
#import "RelationInfoModel.h"
#import "RelationMovieCell.h"
#import "MovieDetailViewController.h"
#import "HYActorWeiboCell.h"
#import "HYActorWeiboModel.h"
#import "TitleCell.h"
#import "HYActorInfoCell.h"
#import "HYActorInfoModel.h"
#import "RelationMovieCell.h"
#import "HYActorRelationListController.h"

@interface CreatorInfoViewController ()<UITableViewDataSource,UITableViewDelegate,ClickRelationInfoCellDelegate>
{
    HYActorInfoModel *_actorInfoModel;
    UIImageView * _iconImageView;
    NSUInteger _currentPage;
    NSNumber *_weiboNumber;
    BOOL _weiboIsNone;
    BOOL _descIsNone;
    MBProgressHUD *_HUD;
}

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)CreatorTableViewHeader* headView;
@property(nonatomic,strong)UIImageView* bigImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) NSMutableArray *relationArr;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * picUrl;
@property (nonatomic, assign) int maxPage;
@property (nonatomic, assign) int allCount;

@property (nonatomic, strong) NSMutableArray *weiboArray;

@end

@implementation CreatorInfoViewController

-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStylePlain];
        _tableView.dataSource=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _descIsNone = YES;
        _weiboIsNone = YES;
    }
    return _tableView;
}

- (NSMutableArray *)relationArr{
    if (!_relationArr) {
        _relationArr = [NSMutableArray array];
    }
    return _relationArr;
}

- (NSMutableArray *)weiboArray {
    if (_weiboArray == nil) {
        _weiboArray =@[].mutableCopy;
    }
    return _weiboArray;
}

// 当前视图控制器是否支持旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self requestData];
    [self customNavigationItem];
    [self.view addSubview: self.tableView];

    [self.tableView registerNib:[UINib nibWithNibName:@"IntroduceTableViewCell" bundle:nil] forCellReuseIdentifier:@"IntroduceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RelationMovieCell" bundle:nil] forCellReuseIdentifier:@"RelationMovieCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TitleCell" bundle:nil] forCellReuseIdentifier:@"TitleCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.tabBarController.tabBar.hidden = YES;
    _currentPage = 0;
    _weiboIsNone = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

- (void)customNavigationItem{
    // 获取视图控制器的UINavigationItem
    UINavigationItem * naviItem = self.navigationItem;
    UIImage * leftImage = [UIImage imageNamed:@"navigationbar_icon_back"];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    naviItem.leftBarButtonItem = leftBarItem;
}

- (void)customHeaderView {
    _bigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    _bigImageView.clipsToBounds=YES;
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _headView = [CreatorTableViewHeader new];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _iconImageView.center=CGPointMake(_bigImageView.center.x, _bigImageView.center.y);
    _iconImageView.clipsToBounds=YES;
    _iconImageView.layer.cornerRadius = 40;
    _iconImageView.layer.borderWidth = 2;
    _iconImageView.layer.borderColor = [UIColor brownColor].CGColor;
    _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    
    [_headView layoutWithTableView:self.tableView andBackGroundView:_bigImageView andIconImageView:_iconImageView];
}

- (void)leftBarButtonItemClicked:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLayoutSubviews
{
    [_headView resizeView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_headView scrollViewDidScroll:scrollView];
    if ([scrollView isEqual:_tableView]) {
        UIColor * color = [UIColor navigationStyleColor];
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 64) {
            CGFloat alpha = MIN(1, 1 - ((344 - offsetY) / 344));
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
            self.title = self.name;
            [self.navigationController.navigationBar hy_setTitleAlpha:alpha];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        }
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (!_descIsNone) {
            return 1;
        } else {
            return 0;
        }
    }
    if (section == 1) {
        if (self.relationArr.count != 0) {
            return 1;
        } else {
            return 0;
        }
    } else {
        if (!_weiboIsNone) {
            return _weiboArray.count + 1;;
        } else {
            return 0;
        }
    }
}

//组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    if (section == 1) {
        if (self.relationArr.count != 0) {
            return 10;
        } else {
            return 0.01;
        }
    } else {
        if (!_weiboIsNone) {
            return 10;
        } else {
            return 0.01;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HYActorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        if (cell == nil) {
            cell = [[HYActorInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoCell"];
        }
        HYWeakSelf(self);
        if (!cell.moreButtonClickedBlock) {
            [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
                HYActorInfoModel *model = _actorInfoModel;
                model.isOpening = !model.isOpening;
                [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
        cell.indexPath = indexPath;
        cell.descIsNone = _descIsNone;
        cell.model = _actorInfoModel;
        return cell;
    }
    if (indexPath.section == 1) {
        RelationMovieCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RelationMovieCell"];
        cell.relationMovieArr = self.relationArr;
        cell.delegate = self;
        cell.artist_id = self.creatorID;
        cell.cellTitle = @"代表作品";
        cell.delegate = self;
        cell.numbers = [NSString stringWithFormat:@"%ld部作品",(unsigned long)self.relationArr.count];
        return cell;
    } else {
        if (indexPath.row == 0) {
            TitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            cell.title = @"Ta的微博";
            cell.number = [NSString stringWithFormat:@"%@条微博",_weiboNumber];
            return cell;
            
        } else {
            HYActorWeiboModel *model = self.weiboArray[indexPath.row - 1];
            HYActorWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActorWeiboCell"];
            if (cell == nil) {
                cell = [[HYActorWeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActorWeiboCell"];
            }
            cell.weiboIsNone = _weiboIsNone;
            cell.model = model;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_descIsNone) {
            return 0;
        } else {
            id model = _actorInfoModel;
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HYActorInfoCell class] contentViewWidth:SCREEN_WIDTH];
        }
    }
    if (indexPath.section == 1) {
        return 230;
    }
    else {
        if (indexPath.row == 0) {
            if (_weiboIsNone) {
                return 0;
            } else {
                return 40;
            }
        } else {
            id model = self.weiboArray[indexPath.row - 1];
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HYActorWeiboCell class] contentViewWidth:SCREEN_WIDTH];
        }
    }
}

#pragma mark RequestData
- (void)requestData{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_ACTOR];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"artist_id"] = self.creatorID;
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.name = responseObject[@"data"][@"profile_info"][@"name"];
        self.picUrl = responseObject[@"data"][@"profile_info"][@"avatar_large"];
        [self customHeaderView];
        
        NSString *descStr = responseObject[@"data"][@"profile_info"][@"desc"];
        _actorInfoModel = [HYActorInfoModel new];
        if ([descStr isEqualToString:@""]) {
            _descIsNone = YES;
        } else {
            _descIsNone = NO;
            _actorInfoModel.desc = descStr;
        }
        
        NSNumber *number = responseObject[@"data"][@"profile_film"][@"count"];
        _allCount = [number intValue];
        
        if (_allCount%20 != 0) {
            self.maxPage = [number intValue]/20 + 1;
        }else{
            self.maxPage = [number intValue]/20;
        }
        [self requestPic];
        [self.weiboArray removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [_HUD hide:YES];
            [_HUD hideAnimated:YES];
            [self renewUI];
            [self.tableView reloadData];
        });
        
        NSDictionary *weibo =responseObject[@"data"][@"profile_weibo"];
        if ((NSNull *)weibo == [NSNull null]) {
            _weiboIsNone = YES;
        } else {
            _weiboIsNone = NO;
            [self requestWeiboData];
            _weiboNumber = weibo[@"count"];
            HYWeakSelf(self);
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakself requestWeiboData];
            }];
            [footer setTitle:@"上拉加载更多数据" forState:MJRefreshStateIdle];
            self.tableView.mj_footer = footer;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        _HUD.label.text = @"请求数据失败";
        [_HUD hideAnimated:YES afterDelay:2];
    }];
}

- (void)requestWeiboData {
    _currentPage += 1;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:self.creatorID forKey:@"artist_id"];
    [dict setObject:@(10) forKey:@"count"];
    [dict setObject:@(_currentPage) forKey:@"page"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_ACTOR_WEIBO];
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = responseObject[@"data"][@"profile_weibo"];
        if (array.count == 0) {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            _currentPage -= 1;
        } else {
            for (NSDictionary *dic in array) {
                HYActorWeiboModel *model = [HYActorWeiboModel yy_modelWithDictionary:dic];
                [self.weiboArray addObject:model];
            }
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        _currentPage -= 1;
    }];
}

//更新UI
- (void)renewUI{
    //[_bigImageView sd_setImageWithURL:[NSURL URLWithString:self.picUrl]];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.picUrl]placeholderImage:[UIImage imageNamed:@"profile_Head_gray"]];
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:self.picUrl] placeholderImage:[UIImage imageNamed:@"profile_Head_gray"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 20 左右 R  模糊图片
        [_bigImageView setImageToBlur:_bigImageView.image blurRadius:21 completionBlock:nil];
    }];
    
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    _nameLabel.center = CGPointMake(_bigImageView.center.x, _bigImageView.center.y+60);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [_tableView addSubview:_nameLabel];
    _nameLabel.text = self.name;
    
}

- (void)requestPic{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_ACTOR_MOVIE];
    //循环请求数据,直到最后一组数据请求下来
    for (int i = 1; i <= self.maxPage; i++) {
        
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"count"] = @"20";
    dict[@"artist_id"] = self.creatorID;
    dict[@"page"] = [NSString stringWithFormat:@"%d",i];
    
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray * profile_filmArr = responseObject[@"data"][@"profile_film"];
        NSArray * relationModelArr = [RelationInfoModel mj_objectArrayWithKeyValuesArray:profile_filmArr];
        
        for (RelationInfoModel * model in relationModelArr) {
            [self.relationArr addObject:model];
        }
        
        if (_allCount == self.relationArr.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
          });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
        
    }
}

#pragma mark - ClickRelationrCellDelegate
- (void)actorMoreMovieList:(NSString *)artist_id {
    HYActorRelationListController *relationListVC = [HYActorRelationListController new];
    relationListVC.artist_id = artist_id;
    [self.navigationController pushViewController:relationListVC animated:NO];
}

-(void)choseRelationInfoTerm:(NSInteger)num andPageID:(NSString *)pageid andCellNumber:(NSInteger)cellNumber
{
    if (num == 989) {
        return;
    }else{
    // 取出对应的模型数据
    RelationInfoModel * model = self.relationArr[num];
    MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
    MDVC.filmId = model.film_id;
    [self.navigationController pushViewController:MDVC animated:YES];
    }
}



@end
