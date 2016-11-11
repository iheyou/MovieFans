//
//  RootTabBarController.m
//  movies
//
//  Created by hy on 16/1/7.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "RootTabBarController.h"
#import "HotPageViewController.h"
#import "ReviewPageViewController.h"
#import "FilmListPageViewController.h"
#import "MePageViewController.h"
//#import "SearchPageViewController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addViewControlers];
    
    [self customNavigationBar];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 添加视图控制器*/
- (void)addViewControlers
{
    HotPageViewController * vc1 = [[HotPageViewController alloc]init];
    ReviewPageViewController * vc2 = [[ReviewPageViewController alloc]init];
    FilmListPageViewController * vc3 = [[FilmListPageViewController alloc]init];
    MePageViewController * vc4 = [[MePageViewController alloc]init];
    
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController *nc2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    UINavigationController *nc3 = [[UINavigationController alloc]initWithRootViewController:vc3];
    UINavigationController *nc4 = [[UINavigationController alloc]initWithRootViewController:vc4];
    
    NSArray *pageArr = @[nc1,nc2,nc3,nc4];
    self.viewControllers = pageArr;
    
    NSArray *titleArr = @[@"首页",@"影评",@"影单",@"我"];
    NSArray *unSelectImageArr = @[@"label_bar_movie_normal@2x",@"label_bar_film_critic_normal@2x",@"label_bar_film_list_normal@2x",@"label_bar_my_normal@2x"];
    NSArray *selectImageArr = @[@"despicable-me-2-minion-icon-7",@"despicable-me-2-minion-icon-5",@"shy-minion-icon",@"angry-minion-icon"];
    //NSArray *selectImageArr = @[@"label_bar_movie_selected@2x",@"label_bar_film_critic_selected@2x",@"label_bar_film_list_selected@2x",@"label_bar_news_selected@2x"];
    for (int i = 0; i < pageArr.count; i++) {
        UITabBarItem * tabBar =(UITabBarItem*)self.tabBar.items[i];
        tabBar.image = [[UIImage imageNamed:unSelectImageArr[i]]imageWithRenderingMode:1]  ;
        tabBar.selectedImage=[[UIImage imageNamed:selectImageArr[i]]imageWithRenderingMode:1];
        tabBar.title = titleArr[i];
    }
    UIColor *titleHighlightedColor = [UIColor blackColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleHighlightedColor, NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor clearColor], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
//    UITabBar * tabbar = (id)self.tabBar;
//    tabbar.backgroundColor = [UIColor clearColor];
}

// 自定义UINavigationBar
- (void)customNavigationBar
{
    // 获取所有的视图控制器
    //self.navigationController.navigationBar.translucent = YES;
    NSArray * viewControllers = self.viewControllers;
    
    for (UINavigationController * navi in viewControllers) {
        // 获取UINavigationBar
        UINavigationBar * navigationBar = navi.navigationBar;
        // 设置背景图片
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];
        
    }
}



@end
