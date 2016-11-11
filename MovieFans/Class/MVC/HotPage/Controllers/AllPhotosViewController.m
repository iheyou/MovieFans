//
//  AllPhotosViewController.m
//  MovieFans
//
//  Created by hy on 16/1/18.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "AllPhotosViewController.h"
#import "CollectionViewCell.h"
#import "FilmPhotosModel.h"
#import "BigPictureViewController.h"

@interface AllPhotosViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation AllPhotosViewController

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-20)/3, (SCREEN_WIDTH-20)/3);
        // 设置间隙
        // 设置行间距
        flowLayout.minimumLineSpacing = 5;
        // 设置单元格间距
        flowLayout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10, [UIScreen mainScreen].bounds.size.height-10) collectionViewLayout:flowLayout];
        // 设置数据源和代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    // 设置背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self customNavigationItem];

    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
   
    [self.collectionView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavigationItem{
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"剧照";

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


#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 复用
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    FilmPhotosModel * model = _dataArray[indexPath.row];
    cell.imageUrl = model.photo_url_mid;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BigPictureViewController * bpvc = [[BigPictureViewController alloc] init];
    bpvc.photos = _dataArray;
    bpvc.selectedIndex = indexPath.row;
    bpvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    UIModalTransitionStyleCoverVertical = 0,
    //    UIModalTransitionStyleFlipHorizontal __TVOS_PROHIBITED,
    //    UIModalTransitionStyleCrossDissolve,
    //    UIModalTransitionStylePartialCurl
    [self presentViewController:bpvc animated:YES completion:nil];

    
}



@end
