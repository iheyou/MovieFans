//
//  BaseViewController.m
//  MovieFans
//
//  Created by hy on 16/2/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchPageViewController.h"
#import "WZYCustomMenu.h"
#import "ClassifyViewController.h"
#import "ShakeViewController.h"

@interface BaseViewController ()<WZYCustomMenuDelegate>

@property (nonatomic, strong) WZYCustomMenu *menu;

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationItem];
}

- (void)customNavigationItem{
    
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


@end
