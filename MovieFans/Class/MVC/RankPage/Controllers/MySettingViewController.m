//
//  MySettingViewController.m
//  MovieFans
//
//  Created by hy on 16/2/13.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "MySettingViewController.h"
#import "SDImageCache.h"

@interface MySettingViewController ()

@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    // 设置背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)customNavigationItem{
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"系统设置";
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



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


//清除缓存
- (void)clearWebCache
{
    //缓存的文件个数
    NSUInteger diskCount = [SDImageCache sharedImageCache].getDiskCount;
    //获取缓存的大小
    NSUInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
    
    NSString * msg = [NSString stringWithFormat:@"缓存文件数量:%lu,缓存文件大小:%.2fM",(unsigned long)diskCount,cacheSize/1024.0/1024.0];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"清除缓存" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    //添加action
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancel];
    //清除action
    UIAlertAction * clearAction = [UIAlertAction actionWithTitle:@"清除缓存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"清除成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }];
    [alertController addAction:clearAction];
    
    //显示
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //清除缓存
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self clearWebCache];
    }
    
}


@end
