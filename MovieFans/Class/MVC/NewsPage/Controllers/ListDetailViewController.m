//
//  ListDetailViewController.m
//  MovieFans
//
//  Created by hy on 16/2/3.
//  Copyright © 2016年 hy. All rights reserved.
//
#define TAG 99

#import "ListDetailViewController.h"
#import "RGCollectionViewCell.h"
#import "AFHTTPSessionManager+Util.h"
#import "UIImageView+WebCache.h"
#import "RelationInfoModel.h"
//#import "RGCollectionViewCell.h"
#import "MovieDetailViewController.h"

@interface ListDetailViewController ()<UICollectionViewDataSource,ClickMovieDetailCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ListDetailViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationItem];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];
    self.tabBarController.tabBar.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavigationItem{
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.title = self.titleName;
    
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RGCollectionViewCell *cell = (RGCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];

    [self configureCell:cell withIndexPath:indexPath];
    //[self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(RGCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    UIView  *subview = [cell.contentView viewWithTag:TAG];
    [subview removeFromSuperview];
    
    RelationInfoModel * model = self.dataArray[indexPath.section];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.poster_url]];
    NSString * dirctorString = [[model.directors firstObject] valueForKey:@"name"];
    cell.dirctor.text = [NSString stringWithFormat:@"导演:%@",dirctorString];
    if (model.type.length != 0) {
        cell.typeLabel.text = [NSString stringWithFormat:@"类型:%@", model.type];
    }
    cell.introView.text = model.intro;
    cell.delegate = self;
    cell.mainLabel.text = model.name;
    cell.cellNumber = indexPath.section;

}


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    RelationInfoModel * model = self.dataArray[indexPath.section];
//    MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
//    MDVC.filmId = model.film_id;
//    [self.navigationController pushViewController:MDVC animated:YES];
//}

//- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition{
//    
//    RelationInfoModel * model = self.dataArray[indexPath.section];
//    MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
//    MDVC.filmId = model.film_id;
//    [self.navigationController pushViewController:MDVC animated:YES];
//
//}

- (void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MV_HEADER,MV_LIST_EVERYPATH];
    for (NSInteger i = 1; i <= self.maxPage; i++) {
        
        NSMutableDictionary *dict = @{}.mutableCopy;
        dict[@"id"] = self.urlID;
        dict[@"count"] = @"20";
        dict[@"type"] = @"page";
        dict[@"page"] = [NSString stringWithFormat:@"%ld",(long)i];
        
        [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:urlStr parmaeters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSArray * listArr = responseObject[@"data"][@"list"];
            NSArray * listArrModel = [RelationInfoModel mj_objectArrayWithKeyValuesArray:listArr];
            
            for (RelationInfoModel * model in listArrModel) {
                [self.dataArray addObject:model];
            }

            if (self.dataArray.count == self.listCount) {
                [SVProgressHUD showSuccessWithStatus:@"加载完成"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.myCollectionView reloadData];
                });
                
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        }];
    }
    
}

#pragma mark - ClickRelationrCellDelegate
-(void)choseMovieDetailTerm:(NSInteger)num
{
    // 取出对应的模型数据
    RelationInfoModel * model = self.dataArray[num];
    MovieDetailViewController * MDVC = [[MovieDetailViewController alloc]init];
    MDVC.filmId = model.film_id;
    [self.navigationController pushViewController:MDVC animated:YES];
}



@end
