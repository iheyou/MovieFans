//
//  RankPageViewController.m
//  MovieFan
//
//  Created by hy on 16/1/7.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "MePageViewController.h"
#import "FirstCell.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "UserInfoViewController.h"
#import "MySettingViewController.h"
#import "JokerViewController.h"
#import "FeedBackViewController.h"
#import "CollectionViewController.h"
#import "HYUserModel.h"
#import "HYOAuthTool.h"
#import "HYOAuthModel.h"
#import "AppDelegate.h"

#define REDIRECT_URI @"https://api.weibo.com/oauth2/default.html"

@interface MePageViewController () <UITableViewDataSource,UITableViewDelegate,getUsersProfileProtocol>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    FirstCell *_firstCell;
    NSString * _nameString;
    NSString * _urlString;
    BOOL _isLogin;
    HYOAuthModel *_outhModel;
    HYUserModel *_userModel;
}


@end

@implementation MePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTitle];
    _dataArray=@[@[@"Image_focus.png",@"我的收藏"],@[@"Image_set.png",@"系统设置"],@[@"Image_recommend.png",@"开发者信息"],@[@"给应用评分",@"版本信息"]];
    [self initTableView];
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    myDelegate.usersDelegate = self;
    _outhModel = [HYOAuthTool fetch];
    if (_outhModel) {
        [self getUsersInfo];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRefresh:) name:USER_REFRESH_NOTICE object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];
    [self userRefresh:nil];
}

- (void)customTitle{
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"我";
}

-(void)initTableView;
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if(section == 1){
        return 3;
    }else
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        return 85*KWidth_Scale;
    }
    
    return 50*KWidth_Scale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35*KWidth_Scale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        _firstCell=[FirstCell GetCellWithTableView:tableView];
        if (_outhModel) {
            _firstCell.promtString = _userModel.name;
            [_firstCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.profileImageUrl] placeholderImage:[UIImage imageNamed:@"Image_head"]];
            return _firstCell;
        }else{
        _firstCell.promtString = @"点击登录";
        return _firstCell;
        }
        
    }else if(indexPath.section==1)  {
        static NSString *Wcell=@"Wcell";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Wcell];
        
        if (!cell) {
            
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Wcell];
            
        }
        
        NSArray *array=_dataArray[indexPath.row];
        cell.imageView.image=[UIImage imageNamed:array[0]];
        cell.textLabel.text=array[1];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }else if(indexPath.section==2){
        static NSString *Tcell=@"3cell";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Tcell];
        
        if (!cell) {
            
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Tcell];
            
        }
        
        NSArray *array=_dataArray.lastObject;
        //cell.imageView.image=[UIImage imageNamed:array[0]];
        cell.textLabel.text=array[indexPath.row];
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = @"1.0.0";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (_outhModel) {
            
        }else {
            // 登录
            [self loginWeibo];
        }
    }else if (indexPath.section==1){
        
        if (indexPath.row==0) {
            
            CollectionViewController * collectionVC = [[CollectionViewController alloc]init];
            [self.navigationController pushViewController:collectionVC animated:YES];
            
        }else if (indexPath.row==1)
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Setting" bundle:[NSBundle mainBundle]];
            //UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"myView"];
            MySettingViewController * MSVC = [story instantiateViewControllerWithIdentifier:@"MySettingViewController"];
            [self.navigationController pushViewController:MSVC animated:YES];
            
        }else if (indexPath.row==2)
        {
            JokerViewController * jokerVC = [[JokerViewController alloc]init];
            [self.navigationController pushViewController:jokerVC animated:YES];

        }
        
    }else if (indexPath.section==2){
        if (indexPath.row == 0) {
//            FeedBackViewController * FBVC = [[FeedBackViewController alloc]init];
//            [self.navigationController pushViewController:FBVC animated:YES];
        }
        
    }
    
}

/** 刷新用户信息*/
- (void)userRefresh:(NSNotification *)notice
{
    // 获取到用户的用户名
    BmobUser *user = [BmobUser getCurrentUser];
    
    if (user) {
        _nameString = user.username;
        NSString *urlStr = [user objectForKey:@"userIconUrl"];
        if (urlStr == nil) {
           //_firstCell.imageView.image = [UIImage imageNamed:@"Image_head"];
           //[_tableView reloadData];
           //return;
        }
        
        [BmobImage cutImageBySpecifiesTheWidth:100 height:100 quality:50 sourceImageUrl:urlStr outputType:kBmobImageOutputBmobFile resultBlock:^(id object, NSError *error) {
            BmobFile *resfile = object;
            NSString *resUrl = resfile.url;
            
            _urlString = resUrl;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }];
        
    }else {
        [_tableView reloadData];
    }
}

- (void)loginWeibo {
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = REDIRECT_URI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

- (void)getUsersInfo {
    HYOAuthModel *authModel = [HYOAuthTool fetch];
    
    [WBHttpRequest requestForUserProfile:authModel.uid withAccessToken:authModel.access_token andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        if (error) {
            _outhModel = nil;
            [_tableView reloadData];
        } else {
            _outhModel = [HYOAuthTool fetch];
            _userModel = [HYUserModel new];
            _userModel = result;
            [_tableView reloadData];
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:USER_REFRESH_NOTICE];
}

@end
