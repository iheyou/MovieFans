//
//  CollectionViewController.m
//  MovieFans
//
//  Created by hy on 16/2/13.
//  Copyright © 2016年 joker. All rights reserved.
//

#import "CollectionViewController.h"
#import "DatabaseManager.h"
#import "CollectionCell.h"
#import "UIImageView+WebCache.h"
#import "MovieDetailViewController.h"


// 删除按钮开始的标记值
#define DELETE_BUTTON_BEGIN_TAG 100

@interface CollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) BOOL isEditing; // 记录当前是否处于编辑状态

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
    [self createUI];
    
    // GCD
    // __weak typeof(*self) * weakSelf = self
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        weakSelf.dataArray = [NSMutableArray arrayWithArray:[[DatabaseManager sharedManager] getAllCollection]];
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 重新加载数据
            [weakSelf.collectionView reloadData];
        });
    });
    
    // 自定义导航项
    [self customNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 自定义导航项
- (void)customNavigationItem
{
    // 设置标题
    self.title = @"我的收藏";
    
    UINavigationItem * naviItem = self.navigationItem;
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    rightBarItem.tintColor = [UIColor whiteColor];
    naviItem.rightBarButtonItem = rightBarItem;
    
    UIImage * leftImage = [UIImage imageNamed:@"navigationbar_icon_back"];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    naviItem.leftBarButtonItem = leftBarItem;
    
}

- (void)leftBarButtonItemClicked:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightBarButtonItemClicked:(UIBarButtonItem *)sender{
    
    if (self.isEditing) {
        [sender setTitle:@"编辑"];
        self.isEditing = NO;
    }
    else {
        [sender setTitle:@"完成"];
        self.isEditing = YES;
    }
    // 重新刷新UIColletionView，显示或者隐藏删除按钮以及动画
    [self.collectionView reloadData];

}

// 创建视图
- (void)createUI
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 设置数据源和代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-20)/3, 150);
    // 设置间隙
//    // 设置行间距
//    flowLayout.minimumLineSpacing = 20;
//    // 设置单元格间距
//    flowLayout.minimumInteritemSpacing = 20;
//    // 设置内间距
//    flowLayout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30);
    // 注册单元格
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

// 单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 复用
    CollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    // 取出对应的模型
    CollectionTableModel * model = self.dataArray[indexPath.row];
    cell.appNameLabel.text = model.appName;
    [cell.appImageView sd_setImageWithURL:[NSURL URLWithString:model.appImage] placeholderImage:[UIImage imageNamed:@"page_second_actorfilms_more"]];
    
    // 判断当前是否处于编辑状态
    if (self.isEditing) {
        cell.deleteButton.hidden = NO;
        // 动画
        cell.transform = CGAffineTransformMakeRotation(-0.05);
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.transform = CGAffineTransformMakeRotation(0.05);
        } completion:nil];
        
    }
    else {
        cell.deleteButton.hidden = YES;
        // 恢复原状
        cell.transform = CGAffineTransformIdentity;
        [cell.layer removeAllAnimations];
    }
    
    // 添加删除按钮点击事件
    [cell.deleteButton addTarget:self action:@selector(deleteCellClicked:) forControlEvents:UIControlEventTouchDown];
    // 设置删除按钮的tag值
    cell.deleteButton.tag = DELETE_BUTTON_BEGIN_TAG + indexPath.row;
    
    return cell;
}

- (void)deleteCellClicked:(UIButton *) sender
{
    // 获取点击删除按钮对应的单元格位置
    NSInteger selectedIndex = sender.tag - DELETE_BUTTON_BEGIN_TAG;
    // 删除数据
    // 找到对应的模型数据
    CollectionTableModel * model = self.dataArray[selectedIndex];
    // 删除数据库数据
    BOOL isSuccess = [[DatabaseManager sharedManager] deleteColletionTableModel:model];
    if (isSuccess) {
        [self.dataArray removeObjectAtIndex:selectedIndex];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
        // 重新刷新UICollectionView，重新计算删除按钮的tag值
        // 延迟执行刷新
        // 参数1：延迟执行的时间
        // dispatch_time创建时间，DISPATCH_TIME_NOW当前时间，delta时间间隔
        // 参数2：执行的队列，参数3：执行block
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.35*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
    else {
        [KVNProgress showErrorWithStatus:@"删除收藏失败"];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditing) {
        
    }else{

    CollectionTableModel * model = self.dataArray[indexPath.row];
    MovieDetailViewController * MVDC = [[MovieDetailViewController alloc] init];
    MVDC.filmId = model.appId;
    [self.navigationController pushViewController:MVDC animated:YES];
    }
        
    
}

@end
