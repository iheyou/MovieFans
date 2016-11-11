//
//  ShakeViewController.m
//  MovieFans
//
//  Created by hy on 16/2/11.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "ShakeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "RandomMovieViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface ShakeViewController ()

@end

@implementation ShakeViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    // 设置背景图片
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];
    self.fd_interactivePopDisabled = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self customUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customUI{
    
//    UIImageView * backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//    backgroundView.image = [UIImage imageNamed:@"shaking"];
//    [self.view addSubview:backgroundView];
//    backgroundView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImageView * backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shaking"]];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.center = self.view.center;
    [self.view addSubview:backgroundView];

    // 获取视图控制器的UINavigationItem
    UINavigationItem * naviItem = self.navigationItem;
    UIImage * leftImage = [UIImage imageNamed:@"navigationbar_icon_back"];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    naviItem.leftBarButtonItem = leftBarItem;
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.title = @"摇一摇";
    
}

- (void)leftBarButtonItemClicked:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//运动事件开始 摇一摇
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    //摇晃开始就播放音乐
    [self playMusic];
    
}

//运动事件结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    RandomMovieViewController * RMVC = [[RandomMovieViewController alloc]init];
    [self.navigationController pushViewController:RMVC animated:YES];
    
    
}
//运动事件取消
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    
    
}

//播放摇一摇音频
- (void)playMusic
{
    //获取应用程序包的路径
    //NSBundle用于管理应用程序包 通过这个类可以获取到本应用程序的路径和资源
    //NSString * bundlePath = [NSBundle mainBundle].bundlePath;
    
    
    NSString * shakeMusicPath = [[NSBundle mainBundle] pathForResource:@"yaoyiyao" ofType:@"mp3"];
    //字符串编码 中文转换URL地址
    //    shakeMusicPath = [shakeMusicPath stringByAddingPercentEncodingWithAllowedCharacters:NSUTF8StringEncoding];
    
    //播放音频
    //委托系统播放短音频
    
    //定义SystemSoundID
    SystemSoundID soundID;
    //创建SystemSoundID
    //创建URL
    NSURL * soundURL = [NSURL URLWithString:shakeMusicPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &soundID);
    AudioServicesPlaySystemSound(soundID);
    
}



@end
