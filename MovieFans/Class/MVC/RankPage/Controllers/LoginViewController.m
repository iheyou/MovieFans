//
//  LoginViewController.m
//  MovieFans
//
//  Created by hy on 16/2/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "LoginViewController.h"
#import "CatAnimationLogin.h"
#import "RegisterViewController.h"
#import "Tool.h"

#define LOGIN_HEIGHT 320
#define LOGIN_Y (SCREEN_HEIGHT-LOGIN_HEIGHT)/2 - 20

@interface LoginViewController ()<UITextFieldDelegate>
{
    CatAnimationLogin * _login;
    UIButton * _loginButton;
}

//@property (nonatomic, strong) JSAnimatedImagesView *bgView;
//@property (nonatomic, strong) NSMutableArray *imgs;
@property (nonatomic, strong) UIImageView *bgView;

@end

@implementation LoginViewController

//- (NSMutableArray *)imgs
//{
//    if (_imgs == nil) {
//        _imgs = @[].mutableCopy;
//        for (int i= 0; i < 3; i++) {
//            NSString *imgName = [NSString stringWithFormat:@"%d.jpg",i+1];
//            UIImage *img = [UIImage imageNamed:imgName];
//            [_imgs addObject:img];
//        }
//    }
//    return _imgs;
//}

- (UIImageView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _bgView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    self.bgView.image = [UIImage imageNamed:@"3.jpg"];
    self.bgView.userInteractionEnabled = YES;
    [self customRegisterButton];


    _login=[[CatAnimationLogin alloc]initWithFrame:CGRectMake(0, LOGIN_Y,SCREEN_WIDTH, LOGIN_HEIGHT)];
    _login.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:_login];
    //_login.userNameTextField.delegate = self;
    //_login.PassWordTextField.delegate = self;
    
    _loginButton = [[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_login.frame)+10, SCREEN_WIDTH-80, 30)];
    [self.bgView addSubview:_loginButton];
    [_loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    _loginButton.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:0.8];
    _loginButton.layer.cornerRadius=5.0f;
    [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _loginButton.enabled = NO;
    _loginButton.alpha = 0.6;
    
    
    //添加键盘将要显示出来的通知回调
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    //添加键盘将要隐藏的通知回调
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTextField) name:UITextFieldTextDidChangeNotification object:nil];
    
    //self.bgView.dataSource = self;
    //[self.bgView startAnimating];

}

- (void)loginButtonClicked:(UIButton *)sender{
    
    [SVProgressHUD showWithStatus:@"登录中"];
    
    NSString *pwdMDTStr = [Tool MD5StringFromString:_login.PassWordTextField.text];
    
    [BmobUser loginWithUsernameInBackground:_login.userNameTextField.text password:pwdMDTStr block:^(BmobUser *user, NSError *error) {
        //sender.userInteractionEnabled = YES;
        if (user) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_REFRESH_NOTICE object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else {
            
            NSString *msg = nil;
            if (error.code == 101) {
                msg = @"账号或密码错误";
            }else  {
                
            }
            
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    }];

}

- (void)registerButtonClicked:(UIButton *)sender{
    
    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (void)rightBarButtonItemClicked:(UIBarButtonItem *)sender{
    
    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (void)customRegisterButton{
    
    UIButton * registerButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200, SCREEN_HEIGHT - 30, 190, 30)];
    [self.bgView addSubview:registerButton];
    registerButton.backgroundColor = [UIColor clearColor];
    [registerButton setTitle:@"没有账号?马上注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:12];
    registerButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UINavigationItem * naviItem = self.navigationItem;
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    rightBarItem.tintColor = [UIColor whiteColor];
    naviItem.rightBarButtonItem = rightBarItem;

}

#pragma mark - 添加键盘将要显示或隐藏的通知回调
- (void)showKeyboard:(NSNotification *)notif{
    //获取弹出键盘的动画事件
    CGFloat animationDuration = [notif.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    //找到要移动的试图
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect rect = _login.frame;
        rect.origin.y = 20;
        _login.frame = rect;
        
        CGRect rect1 = _loginButton.frame;
        rect1.origin.y = 350;
        _loginButton.frame = rect1;
    }];
    
}

- (void)hideKeyboard:(NSNotification *)notif{
    CGFloat animationDuration = [notif.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    //找到要移动的试图
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect rect = _login.frame;
        rect.origin.y = LOGIN_Y;
        _login.frame = rect;
        
        CGRect rect1 = _loginButton.frame;
        rect1.origin.y = CGRectGetMaxY(_login.frame)+10;
        _loginButton.frame = rect1;
    }];
}

//判断当前文本输入框是否为空，若为空将按钮禁用
- (void)checkTextField{

    //判断是否为空
    if (_login.userNameTextField.text.length != 0 && _login.PassWordTextField.text.length != 0) {
        _loginButton.enabled = YES;
        _loginButton.alpha = 0.8;
    }
    else {
        _loginButton.enabled = NO;
        _loginButton.alpha = 0.6;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //首先取出当前文本输入框的文字
    NSMutableString * oldString = [NSMutableString stringWithString:textField.text];
    //拼接获得改变后的文字
    //判断是否为删除
    if (range.length > 0) {
        [oldString deleteCharactersInRange:range];
    }
    else
        [oldString insertString:string atIndex:range.location];
    
    if (oldString.length > 16) {
        return NO;
    }
    
    
    return YES;
}


//#pragma mark -- JSAnimationDataSource
//- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView
//{
//    return self.imgs.count;
//}
//
//- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index
//{
//    return self.imgs[index];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
