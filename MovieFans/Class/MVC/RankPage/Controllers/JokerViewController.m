//
//  JokerViewController.m
//  MovieFans
//
//  Created by hy on 16/2/13.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "JokerViewController.h"
#import "FadeStringView.h"
#import "CopyiPhoneFadeView.h"
#import "UIView+Twinkle.h"

@interface JokerViewController ()
{
    UIButton * twinkleButton;
}
@end

@implementation JokerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"开发者信息";
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    
    FadeStringView *fadeStringView = [[FadeStringView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT/2-80, SCREEN_WIDTH-40, 40)];
    fadeStringView.text = @"Create By";
    fadeStringView.foreColor = [UIColor whiteColor];
    fadeStringView.backColor = [UIColor redColor];
    fadeStringView.font = [UIFont systemFontOfSize:40];
    fadeStringView.alignment = NSTextAlignmentCenter;
    //fadeStringView.center = self.view.center;
    [self.view addSubview:fadeStringView];
    [fadeStringView fadeRightWithDuration:2];
    
    twinkleButton = [[UIButton alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT-50, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:twinkleButton];
    [twinkleButton setTitle:@"Why So Serious" forState:UIControlStateNormal];
    twinkleButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:30];
    twinkleButton.titleLabel.textColor = [UIColor whiteColor];
    [twinkleButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CopyiPhoneFadeView *iphoneFade = [[CopyiPhoneFadeView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT/2-20, SCREEN_WIDTH-40, 40)];
    iphoneFade.text = @"何优";
    iphoneFade.foreColor = [UIColor whiteColor];
    iphoneFade.backColor = [UIColor redColor];
    iphoneFade.font = [UIFont systemFontOfSize:40];
    iphoneFade.alignment = NSTextAlignmentCenter;
    //iphoneFade.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0+50);
    [self.view addSubview:iphoneFade];
    
    [iphoneFade iPhoneFadeWithDuration:2];

}

- (void)buttonClicked:(UIButton *)sender{
    
    //UIButton *btn = (UIButton *)sender;
    // 动画开始
    [twinkleButton twinkle];
}

@end
