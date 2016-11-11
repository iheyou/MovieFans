//
//  MovieDetailViewController.m
//  MovieFans
//
//  Created by hy on 16/1/11.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "DetailTableViewHeader.h"
#import "AFHTTPSessionManager+Util.h"
#import "UIImageView+WebCache.h"
#import "BaseInfoModel.h"
#import "CreatorInfoModel.h"
#import "Dialogue_weiboModel.h"
#import "FilmPhotosModel.h"
#import "RelationInfoModel.h"
#import "ReviewInfoModel.h"
#import "MoviePlayerViewController.h"
#import "PlayViewController.h"
#import "HYStarView.h"
#import "FXBlurView.h"
#import "IntroduceTableViewCell.h"
#import "CreatorInfoCell.h"
#import "CreatorInfoViewController.h"
#import "FilmPhotosModel.h"
#import "FilmPhotosCell.h"
#import "BigPictureViewController.h"
#import "AllPhotosViewController.h"
#import "TitleCell.h"
#import "LongReviewCell.h"
#import "RelationMovieCell.h"
#import "LongReviewListViewController.h"
#import "LongReviewDetailViewController.h"
#import "ShortReviewCell.h"
#import "ShortFrameModel.h"
#import "PicUrlsModel.h"
#import "ShortReviewListViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "CollectionTableModel.h"
#import "DatabaseManager.h"
#import "HYMovieShortReviewCell.h"

@interface MovieDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ClickCreatorCellDelegate,ClickFilmPhotosCellDelegate,ClickRelationInfoCellDelegate>
{
    NSString * _str1;
    NSString * _str2;
    FXBlurView * _fxView;
    UIBarButtonItem * rightBarItem;
    NSMutableArray *_sinceIDArray;
    NSUInteger _page;
    MBProgressHUD *_HUD;
}
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)DetailTableViewHeader* headView;
@property(nonatomic,strong)UIImageView* bigImageView;
@property (nonatomic, strong) BaseInfoModel * baseInfoModel;
@property (nonatomic, strong) ReviewInfoModel * longReviewModel;
@property (nonatomic, strong) ReviewInfoModel * shortReviewModel;
@property (nonatomic, strong) ReviewInfoModel *bottomShortReviewModel;
@property (nonatomic, assign) int groupNumber;
@property (nonatomic, assign) int maxPage;
@property (nonatomic, assign) int allCount;
@property (nonatomic, strong) NSString * numberOfLong;
@property (nonatomic, strong) NSString *numberOfShort;
@property (nonatomic, strong) NSMutableArray *creatorArr;
@property (nonatomic, strong) NSMutableArray *filmPhotosArr;
@property (nonatomic, strong) NSMutableArray *relationArr;
@property (nonatomic, strong) NSMutableArray *reviewArr;

@end

@implementation MovieDetailViewController

- (NSMutableArray *)creatorArr{
    if (!_creatorArr) {
        _creatorArr = [NSMutableArray array];
    }
    return _creatorArr;
}

- (NSMutableArray *)filmPhotosArr{
    if (!_filmPhotosArr) {
        _filmPhotosArr = [NSMutableArray array];
    }
    return _filmPhotosArr;
}

- (NSMutableArray *)relationArr{
    if (!_relationArr) {
        _relationArr = [NSMutableArray array];
    }
    return _relationArr;
}

- (BaseInfoModel *)baseInfoModel{
    if (!_baseInfoModel) {
        _baseInfoModel = [[BaseInfoModel alloc]init];
    }
    return _baseInfoModel;
}

- (ReviewInfoModel *)longReviewModel{
    if (!_longReviewModel) {
        _longReviewModel = [[ReviewInfoModel alloc]init];
    }
    return _longReviewModel;
}

- (ReviewInfoModel *)shortReviewModel{
    if (!_shortReviewModel) {
        _shortReviewModel = [[ReviewInfoModel alloc]init];
    }
    return _shortReviewModel;
}

- (NSMutableArray *)reviewArr {
    if (_reviewArr == nil) {
        _reviewArr = @[].mutableCopy;
    }
    return _reviewArr;
}

-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)style:UITableViewStylePlain];
        _tableView.dataSource=self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _page = 0;
    [self requestData];
    [self customNavigationItem];
    [self.view addSubview: self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"IntroduceTableViewCell" bundle:nil] forCellReuseIdentifier:@"IntroduceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreatorInfoCell" bundle:nil] forCellReuseIdentifier:@"CreatorInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FilmPhotosCell" bundle:nil] forCellReuseIdentifier:@"FilmPhotosCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LongReviewCell" bundle:nil] forCellReuseIdentifier:@"LongReviewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TitleCell" bundle:nil] forCellReuseIdentifier:@"TitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RelationMovieCell" bundle:nil] forCellReuseIdentifier:@"RelationMovieCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.tabBarController.tabBar.hidden = YES;
    self.fd_interactivePopDisabled = YES;
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
    
    rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"film_list_page_interested_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    rightBarItem.tintColor = [UIColor whiteColor];
    naviItem.rightBarButtonItem = rightBarItem;
    // 判断当前应用是否已收藏
    BOOL isCollection = [[DatabaseManager sharedManager] isExistsWithAppId:self.filmId];
    // 修改收藏按钮的状态
    if (isCollection) {
        rightBarItem.enabled = !isCollection;
        [rightBarItem setImage:[UIImage imageNamed:@"film_list_page_interested_pressed"]];
    }
    
    
//    UIImage * rightImage = [UIImage imageNamed:@""];
//    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
//    rightBarItem.tintColor = [UIColor lightGrayColor];
//    naviItem.rightBarButtonItem = rightBarItem;
    _bigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, BIGIMAGEVIEW_HEIGHT)];
    _bigImageView.clipsToBounds=YES;
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
   
    _headView=[[DetailTableViewHeader alloc]init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _fxView = [[FXBlurView alloc] init];
    [_headView layoutWithTableView:self.tableView andBackGroundView:_bigImageView andSubviews:_fxView];
    
}


- (void)rightBarButtonItemClicked:(UIBarButtonItem *)sender{
    
    if (!self.baseInfoModel) {
        [KVNProgress showErrorWithStatus:@"应用详情暂未加载"];
        return;
    }
    
    CollectionTableModel * model = [[CollectionTableModel alloc] init];
    model.appId = self.baseInfoModel.film_id;
    model.appName = self.baseInfoModel.name;
    model.appImage = self.baseInfoModel.poster_url;
    
    // 将数据插入数据库中
    BOOL isSuccess = [[DatabaseManager sharedManager] insertCollectionTableModel:model];
    if (isSuccess) {
        rightBarItem.enabled = NO;
        [rightBarItem setImage:[UIImage imageNamed:@"film_list_page_interested_pressed"]];
        rightBarItem.tintColor = [UIColor whiteColor];

        [KVNProgress showSuccessWithStatus:@"收藏成功"];
    }
    else {
        [KVNProgress showErrorWithStatus:@"收藏失败"];
    }

}

//组头自定义
- (void)createHeaderUI{
    self.navigationItem.hidesBackButton = YES;
    self.title = _baseInfoModel.name;
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:_baseInfoModel.poster_url]placeholderImage:[UIImage imageNamed:@"weibo_movie_empty_offline@2x"]];
    
    //创建模糊视图
    _fxView.frame = CGRectMake(0, BIGIMAGEVIEW_HEIGHT-150*KWidth_Scale, SCREEN_WIDTH, 150*KWidth_Scale);
    _fxView.dynamic = YES;
    _fxView.blurRadius = 20;
    _fxView.tintColor = [UIColor clearColor];
    
    float score = [HYStarView scroeToStarWith:_baseInfoModel.score];
    int a = score * 2;
    if (a % 2 == 0) {
        for (int i = 0; i < 5;i++ ) {
            UIImageView * imageView =[[UIImageView alloc]init];
            if (i < a/2) {
                imageView.image = [UIImage imageNamed:@"rating_smallstar_selected_dark"];
            }else{
                imageView.image = [UIImage imageNamed:@"rating_smallstar_unchecked_dark"];
            }
            imageView.frame = CGRectMake(SCREEN_WIDTH/2-50+i*12, 25, 10, 10);
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

        imageView.frame = CGRectMake(SCREEN_WIDTH/2-50+i*12, 25, 10, 10);
        [_fxView addSubview:imageView];
       }
    }
    UILabel * scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+25, 12, 40, 30)];
    [_fxView addSubview:scoreLabel];
    scoreLabel.text = _baseInfoModel.score;
    scoreLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:25];
    scoreLabel.textColor = [UIColor orangeColor];
    
    UILabel * directorLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, CGRectGetMaxY(scoreLabel.frame)+3, 200, 20)];
    [_fxView addSubview:directorLabel];
    if (_baseInfoModel.directors.length != 0) {
        directorLabel.text = [NSString stringWithFormat:@"导演：%@",_baseInfoModel.directors];
    }
    
    directorLabel.textColor = [UIColor whiteColor];
    directorLabel.font = [UIFont systemFontOfSize:12];
    directorLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(directorLabel.frame), CGRectGetMaxY(directorLabel.frame)+3, 200,20)];
    [_fxView addSubview:infoLabel];
    if (_baseInfoModel.genre.length != 0 || _baseInfoModel.country != 0) {
        infoLabel.text = [NSString stringWithFormat:@"%@/%@",_baseInfoModel.genre,_baseInfoModel.country];
    }
    
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = [UIFont systemFontOfSize:10];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    
    if (_baseInfoModel.release_date.length != 0) {
        UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(directorLabel.frame), CGRectGetMaxY(infoLabel.frame)+3, 200,20)];
        [_fxView addSubview:dateLabel];
        dateLabel.text = [NSString stringWithFormat:@"%@上映",_baseInfoModel.release_date];
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.font = [UIFont systemFontOfSize:10];
        dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    
//    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    
//    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
//    view.frame = CGRectMake(0, 250, SCREEN_WIDTH, 150);
//    [_bigImageView addSubview:view];
    
}

//播放电影或预告

- (void)playMovie{
    MoviePlayerViewController * MPVC = [[MoviePlayerViewController alloc]init];
    //PlayViewController * playVC = [[PlayViewController alloc]init];
    if (_str1.length != 0) {
        //playVC.movieUrl = _str1;
        MPVC.movieUrl = _str1;
    }
    else{
       // playVC.movieUrl = _str2;
        MPVC.movieUrl = _str2;
    }
    [self presentViewController:MPVC animated:YES completion:nil];
}

- (void)leftBarButtonItemClicked:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    UIColor * color = [UIColor blackColor];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
}

-(void)viewDidLayoutSubviews
{
    [_headView resizeView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_headView scrollViewDidScroll:scrollView];

    if (_tableView == scrollView) {
        UIColor * color = [UIColor navigationStyleColor];
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 0) {
            CGFloat alpha = MIN(1, 1 - ((200 - offsetY) / 200));
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        }
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        if (self.creatorArr.count != 0) {
            return 1;
        } else {
            return 0;
        }
    }
    if (section == 2) {
        if (self.filmPhotosArr.count != 0) {
            return 1;
        } else {
            return 0;
        }
    }
    if (section == 3) {
        if (_longReviewModel != nil) {
            return 2;
        } else {
            return 0;
        }
    }
    if (section == 4) {
        if (_numberOfShort != 0) {
            return 2;
        } else {
            return 0;
        }
    }
    if (section == 5) {
        if (self.relationArr.count != 0) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return self.reviewArr.count;
    }
}

//组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    else if (section == 1) {
        if (self.creatorArr.count == 0) {
            return 0.1;
        }else{
            return 15;
        }
    }else if(section == 2){
        if (self.filmPhotosArr.count == 0) {
            return 0.1;
        }else{
            return 15;
        }
    }
    else if(section == 3){
        if (_longReviewModel.film_name.length == 0) {
            return 0.1;
        }else{
            return 15;
        }
    }
    else if(section == 4){
        if (_shortReviewModel.film_name.length == 0) {
            return 0.1;
        }else{
            return 15;
        }
    }
    else if(section == 5){
        if (self.relationArr.count == 0) {
            return 0.1;
        }else{
            return 15;
        }
    }
    else {
        if (self.reviewArr.count == 0) {
            return 0.1;
        } else {
            return 15;
        }
    }

}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        IntroduceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IntroduceCell"];
        tableView.estimatedRowHeight = 100;
        cell.introduceText = _baseInfoModel.desc;
        if (_baseInfoModel.desc.length == 0) {
            tableView.rowHeight = 0;
            cell.hidden = YES;
        }
        return cell;
    }
    if(indexPath.section == 1){
        CreatorInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CreatorInfoCell"];
        cell.creatorArr = self.creatorArr;
        cell.delegate = self;
        return cell;
    }
    if(indexPath.section == 2){
        FilmPhotosCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FilmPhotosCell"];

        cell.filmPhotosArr = self.filmPhotosArr;
        cell.delegate = self;
        return cell;

    }
    if (indexPath.section == 3){
        if (indexPath.row == 0) {
            TitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            cell.title = @"热门长评";
            cell.number = [NSString stringWithFormat:@"%@条长评",_numberOfLong];
            return cell;
            
        }else{
            LongReviewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LongReviewCell"];
            cell.model = _longReviewModel;
            cell.string = @"点击查看全文";
            return cell;
        }
    }
    if (indexPath.section == 4){
        if (indexPath.row == 0) {
            TitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            cell.title = @"热门短评";
            cell.number = [NSString stringWithFormat:@"%@条短评",_numberOfShort];
            return cell;
            
        }else{
            static NSString *cellID = @"ShortCellID";
            ShortReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell =[[ShortReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            ShortFrameModel * model = [[ShortFrameModel alloc]init];
            model.reviewModel = _shortReviewModel;
            cell.frameModel = model;
            tableView.rowHeight = model.cellHeight;
            return cell;
        }
    }
    if (indexPath.section == 5) {
        RelationMovieCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RelationMovieCell"];
        cell.relationMovieArr = self.relationArr;
        cell.delegate = self;
        cell.cellTitle = @"相关电影";
        return cell;
    }
    else  {
        static NSString *cellID = @"MovieShortCellID";
        HYMovieShortReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell =[[HYMovieShortReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        ReviewInfoModel * model = self.reviewArr[indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }
    if (indexPath.section == 1) {
        return 170;
    }
    if (indexPath.section == 2) {
        return 170;
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 40;
        } else {
            return 290;
        }
    }
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            return 40;
        } else {
            ShortFrameModel * model = [[ShortFrameModel alloc]init];
            model.reviewModel = _shortReviewModel;
            return model.cellHeight;
        }
    }
    if (indexPath.section == 5) {
        return 230;
    }
    else {
        return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:self.tableView];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            LongReviewListViewController * LLVC = [[LongReviewListViewController alloc]init];
            
            LLVC.filmId = self.filmId;
            [self.navigationController pushViewController:LLVC animated:YES];
        }else{
            LongReviewDetailViewController * LDVC = [[LongReviewDetailViewController alloc]init];
            
            LDVC.ID = _longReviewModel.id;
            [self.navigationController pushViewController:LDVC animated:YES];
        }
    }
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            ShortReviewListViewController * SRLVC = [[ShortReviewListViewController alloc]init];
            SRLVC.filmId = self.filmId;
            [self.navigationController pushViewController:SRLVC animated:YES];
        }
    }
    
}


//数据请求
- (void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_DETAIL];
    NSMutableDictionary *dict = @{}.mutableCopy;
    //dict[@"count"] = @"20";
    dict[@"film_id"] = self.filmId;
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * dataDict = responseObject[@"data"];
        NSDictionary * baseInfo = dataDict[@"base_info"];
        
        _baseInfoModel = [[BaseInfoModel alloc]init];
        [_baseInfoModel setValuesForKeysWithDictionary:baseInfo];
        
        
        
        //全片或者预告按钮
        NSArray * arr1 = [_baseInfoModel.videos valueForKey:@"list"];
        NSArray * arr2 = [_baseInfoModel.feature_videos valueForKey:@"list"];
        _str1 = [[arr1 firstObject] valueForKey:@"video_url"];
        _str2 = [[arr2 firstObject] valueForKey:@"video_url"];
        if (_str1.length != 0 || _str2.length != 0) {
            
            UIButton* playButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
            if (_str1.length != 0) {
                [playButton setImage:[UIImage imageNamed:@"page_play_trailer"] forState:UIControlStateNormal];
            }else{
                [playButton setImage:[UIImage imageNamed:@"page_play_entirefilm"] forState:UIControlStateNormal];
            }
            [playButton addTarget:self action:@selector(playMovie) forControlEvents:UIControlEventTouchUpInside];
            playButton.center=CGPointMake(_bigImageView.center.x, _bigImageView.center.y-60);
            playButton.clipsToBounds=YES;
            playButton.contentMode=UIViewContentModeScaleAspectFill;
            [_tableView addSubview:playButton];
        }
        
        //主创数据
        NSDictionary * creatorInfo = dataDict[@"creator_info"];
        NSArray * creatorListArr = creatorInfo[@"actors"][@"list"];
        NSArray * creatorModelArr = [CreatorInfoModel mj_objectArrayWithKeyValuesArray:creatorListArr];
        
        for (CreatorInfoModel * model in creatorModelArr) {
            [self.creatorArr addObject:model];
        }
        
        //剧照数据
        NSString * number = dataDict[@"film_photos"][@"total"];
        _allCount = [number intValue];
        
        if (_allCount%15 != 0) {
            self.maxPage = [number intValue]/15 + 1;
        }else{
            self.maxPage = [number intValue]/15;
        }
        
        //长评论
        NSDictionary * longReviewDict = [dataDict[@"review_info"][@"long_review"][@"list"] firstObject];
        _longReviewModel = [[ReviewInfoModel alloc]init];
        [_longReviewModel setValuesForKeysWithDictionary:longReviewDict];
        _numberOfLong = [NSString stringWithFormat:@"%d",[dataDict[@"review_info"][@"long_review"][@"total"] intValue]];
        
        //短评论
        NSDictionary * shortReviewDict = [dataDict[@"review_info"][@"short_review"][@"list"] firstObject];
        _shortReviewModel = [[ReviewInfoModel alloc]init];
        [_shortReviewModel setValuesForKeysWithDictionary:shortReviewDict];
        _numberOfShort = [NSString stringWithFormat:@"%d",[dataDict[@"review_info"][@"short_review"][@"total"] intValue]];
        
        //相似电影
        NSArray * relatiomFilmArray = dataDict[@"relation_info"][@"list"];
        NSArray * relationModelArr = [RelationInfoModel mj_objectArrayWithKeyValuesArray:relatiomFilmArray];
        
        for (RelationInfoModel * model in relationModelArr) {
            [self.relationArr addObject:model];
        }
        
        //最下边的短评论 1条
        NSArray *bottomShortReviewArray = dataDict[@"review_info"][@"short_review"][@"list"];
        if (bottomShortReviewArray.count == 2) {
            _bottomShortReviewModel = [ReviewInfoModel new];
            [_bottomShortReviewModel setValuesForKeysWithDictionary:[bottomShortReviewArray lastObject]];
            [self.reviewArr addObject:_bottomShortReviewModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [_HUD hide:YES];
            [_HUD hideAnimated:YES];
            [self createHeaderUI];
            [self.tableView reloadData];
        });
        
        if (_sinceIDArray == nil) {
            _sinceIDArray = @[].mutableCopy;
        }
        NSString *next_since_id = responseObject[@"data"][@"review_info"][@"short_review"][@"next_since_id"];
        if (![next_since_id isEqualToString:@""]) {
            [_sinceIDArray addObject:next_since_id];
            HYWeakSelf(self);
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _page += 1;
                [weakself requestShortReviewData];
            }];
            _tableView.mj_footer = footer;
        }
        
        NSArray * picArr = _shortReviewModel.small_pic;
        for (int i = 0; i < picArr.count; i++) {
            //            PicUrlsModel * model =
        }
        if (_allCount != 0) {
            [self requestPic];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        _HUD.label.text = @"请求数据失败";
        [_HUD hideAnimated:YES afterDelay:1];
    }];
}

- (void)requestShortReviewData {
    if ([_sinceIDArray.firstObject isEqualToString:@""]) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        NSMutableDictionary *dic = @{}.mutableCopy;
        [dic setObject:@"10" forKey:@"count"];
        [dic setObject:@(_page) forKey:@"page"];
        [dic setObject:self.filmId forKey:@"film_id"];
        [dic setObject:_sinceIDArray.firstObject forKey:@"since_id"];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_SHORTREVIEW];
        [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSDictionary *bottomShortReviewDict = responseObject[@"data"][@"list"];
            if (bottomShortReviewDict == NULL) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                for (NSDictionary *dicModel in bottomShortReviewDict) {
                    _bottomShortReviewModel = [ReviewInfoModel new];
                    [_bottomShortReviewModel setValuesForKeysWithDictionary:dicModel];
                    [self.reviewArr addObject:_bottomShortReviewModel];
                }
                [_sinceIDArray removeAllObjects];
                NSString *next_since_id = responseObject[@"data"][@"next_since_id"];
                if (![next_since_id isEqualToString:@""]) {
                    [_sinceIDArray addObject:next_since_id];
                }
                
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            _page -= 1;
            [self.tableView.mj_footer endRefreshing];
        }];

    }
}

- (void)requestPic{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_PHOTOS];
    //循环请求数据,直到最后一组数据请求下来
    for (int i = 1; i <= self.maxPage; i++) {
        
        NSMutableDictionary *dict = @{}.mutableCopy;
        dict[@"count"] = @"15";
        dict[@"page"] = [NSString stringWithFormat:@"%d",i];
        dict[@"film_id"] = self.filmId;
        
        
        [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSArray * film_photoArr = responseObject[@"data"][@"list"];
            NSArray * filmPhotosModelArr = [FilmPhotosModel mj_objectArrayWithKeyValuesArray:film_photoArr];
            for (FilmPhotosModel * model in filmPhotosModelArr) {
                [self.filmPhotosArr addObject:model];
            }
            
            if (_allCount == self.filmPhotosArr.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //一个section刷新
//                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
//                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView reloadData];
            });
            }
            
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
   }
}



#pragma mark - ClickCreatorCellDelegate
- (void)choseCreatorTerm:(NSInteger)num
{
    // 取出对应的模型数据
    CreatorInfoModel * model = self.creatorArr[num];
    CreatorInfoViewController * creatorVC = [[CreatorInfoViewController alloc]init];
    creatorVC.creatorID = model.artist_id;
    [self.navigationController pushViewController:creatorVC animated:YES];
}

#pragma mark - ClickFilmPhotosCellDelegate
- (void)choseFilmPhotosTerm:(NSInteger)num
{
    if (num == 990) {
        AllPhotosViewController * allPhotosVC = [[AllPhotosViewController alloc]init];
        allPhotosVC.dataArray = self.filmPhotosArr;
        [self.navigationController pushViewController:allPhotosVC animated:YES];
    }else{
    // 取出对应的模型数据
    //FilmPhotosModel * model = self.filmPhotosArr[num];
    BigPictureViewController * bpvc = [[BigPictureViewController alloc] init];
    bpvc.photos = self.filmPhotosArr;
    bpvc.selectedIndex = num;
    bpvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //    UIModalTransitionStyleCoverVertical = 0,
    //    UIModalTransitionStyleFlipHorizontal __TVOS_PROHIBITED,
    //    UIModalTransitionStyleCrossDissolve,
    //    UIModalTransitionStylePartialCurl
    [self presentViewController:bpvc animated:YES completion:nil];
    }
}

#pragma mark - ClickRelationrCellDelegate
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
