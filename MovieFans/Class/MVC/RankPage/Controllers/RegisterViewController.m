//
//  RegisterViewController.m
//  MovieFans
//
//  Created by hy on 16/2/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "RegisterViewController.h"
#import "Tool.h"

@interface RegisterViewController ()<JSAnimatedImagesViewDataSource,UITextFieldDelegate>
{
    UIView * _textfieldBackgroundView;
    UITextField * _pwd;
    UITextField * _user;
    UITextField * _confirmPwd;
    UIButton * _registerButton;
}

@property (nonatomic, strong) JSAnimatedImagesView *bgView;
@property (nonatomic, strong) NSMutableArray *imgs;

@end

@implementation RegisterViewController

- (NSMutableArray *)imgs
{
    if (_imgs == nil) {
        _imgs = @[].mutableCopy;
        for (int i= 0; i < 5; i++) {
            NSString *imgName = [NSString stringWithFormat:@"%d.jpg",i+4];
            UIImage *img = [UIImage imageNamed:imgName];
            [_imgs addObject:img];
        }
    }
    return _imgs;
}

- (JSAnimatedImagesView *)bgView{
    if (_bgView == nil) {
        _bgView = [[JSAnimatedImagesView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _bgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTextField) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.view addSubview:self.bgView];
    self.bgView.dataSource = self;
    [_bgView startAnimating];
    
    [self createTextFields];
}



#pragma mark -- JSAnimationDataSource
- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView
{
    return self.imgs.count;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index
{
    return self.imgs[index];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//}

-(void)createTextFields
{
    CGRect frame=[UIScreen mainScreen].bounds;
    _textfieldBackgroundView=[[UIView alloc]initWithFrame:CGRectMake(10, 90, frame.size.width-20, 150)];
    _textfieldBackgroundView.layer.cornerRadius=3.0;
    _textfieldBackgroundView.alpha=0.8;
    _textfieldBackgroundView.backgroundColor=[UIColor whiteColor];
    [self.bgView addSubview:_textfieldBackgroundView];
    
    _user=[self createTextFielfFrame:CGRectMake(60, 10, SCREEN_WIDTH-30, 30) font:[UIFont systemFontOfSize:14] placeholder:@"账号"];
    _user.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _pwd=[self createTextFielfFrame:CGRectMake(60, 60, SCREEN_WIDTH-30, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"6-16位,建议数字、符号、字符组成" ];
    _pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密文样式
    _pwd.secureTextEntry=YES;
    //pwd.keyboardType=UIKeyboardTypeNumberPad;
    _confirmPwd=[self createTextFielfFrame:CGRectMake(60, 110, SCREEN_WIDTH-30, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"确认密码" ];
    _confirmPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密文样式
    _confirmPwd.secureTextEntry=YES;
    
    UIImageView *userImageView=[self createImageViewFrame:CGRectMake(20, 10, 25, 25) imageName:@"ic_landing_nickname" color:nil];
    UIImageView *pwdImageView=[self createImageViewFrame:CGRectMake(20, 60, 25, 25) imageName:@"mm_normal" color:nil];
    UIImageView *pwdImageView2=[self createImageViewFrame:CGRectMake(20, 110, 25, 25) imageName:@"mm_normal" color:nil];
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, _textfieldBackgroundView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    UIImageView *line2=[self createImageViewFrame:CGRectMake(20, 100, _textfieldBackgroundView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    [_textfieldBackgroundView addSubview:_user];
    [_textfieldBackgroundView addSubview:_pwd];
    [_textfieldBackgroundView addSubview:_confirmPwd];
    
    [_textfieldBackgroundView addSubview:userImageView];
    [_textfieldBackgroundView addSubview:pwdImageView];
    [_textfieldBackgroundView addSubview:pwdImageView2];
    [_textfieldBackgroundView addSubview:line1];
    [_textfieldBackgroundView addSubview:line2];
    
    _registerButton=[[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_textfieldBackgroundView.frame)+20, SCREEN_WIDTH-20, 40)];
    _registerButton.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    _registerButton.layer.cornerRadius=5.0f;
    [self.bgView addSubview:_registerButton];
    [_registerButton setTitle:@"注  册" forState:UIControlStateNormal];
    _registerButton.alpha = 0.5;
    _registerButton.enabled = NO;
    [_registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)registerButtonClicked:(UIButton *)sender{
    
    // 创建一个用户对象
    BmobUser *user = [[BmobUser alloc] init];
    // 设置用户的账号密码
    user.username = _user.text;
   // user.nickname = _user.text;
    
    if (_pwd.text.length < 6 || _confirmPwd.text.length < 6) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码建议6-16位,建议数字、符号、字符组成" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        if ([_pwd.text isEqualToString:_confirmPwd.text]) {
            
            NSString *pwdMD5Str = [Tool MD5StringFromString:_pwd.text];
            user.password = pwdMD5Str;
            
            // 如果填写有邮箱，会自动给邮箱发送一条验证邮件
            [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }else {
                    if ([[error localizedDescription] isEqualToString:@"The operation couldn’t be completed. (cn.bmob.www error 202.)"]) {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"该用户名已被注册，请重新注册" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                        [alertController addAction:cancelAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }else{
                        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];

                    }
                    
                }
                
                
            }];

        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入两次密码不相同" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];

        }
        
    }
    
   
}

//判断当前文本输入框是否为空，若为空将按钮禁用
- (void)checkTextField{
    
    //判断是否为空
    if (_user.text.length != 0 && _pwd.text.length != 0 && _confirmPwd.text.length != 0) {
        _registerButton.enabled = YES;
        _registerButton.alpha = 0.8;
    }
    else {
        _registerButton.enabled = NO;
        _registerButton.alpha = 0.5;
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


-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [_user resignFirstResponder];
    [_pwd resignFirstResponder];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_user resignFirstResponder];
    [_pwd resignFirstResponder];
}

-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    textField.delegate = self;
    
    //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return textField;
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}


@end
