//
//  FeedBackViewController.m
//  MovieFans
//
//  Created by hy on 16/2/13.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "FeedBackViewController.h"
#import "PlaceholderTextView.h"


@interface FeedBackViewController ()

@property (nonatomic, strong) PlaceholderTextView *feedbackTextView;
@property (nonatomic, strong) MBProgressHUD       *HUD;

@end

@implementation FeedBackViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [_HUD hideAnimated:YES];
    [super viewWillDisappear:animated];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"意见反馈";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
//                                                                              style:UIBarButtonItemStylePlain
//                                                                             target:self
//                                                                             action:@selector(sendFeedback)];
//    
//    [self setLayout];
////    RAC(self.navigationItem.rightBarButtonItem, enabled) = [_feedbackTextView.rac_textSignal map:^(NSString *feedback) {
////        return @(feedback.length > 0);
////    }];
//    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLayout
{
    _feedbackTextView = [PlaceholderTextView new];
    _feedbackTextView.placeholder = @"感谢您的反馈，请提出您的意见与建议";
    //[_feedbackTextView setCornerRadius:3.0];
    _feedbackTextView.font = [UIFont systemFontOfSize:17];
    _feedbackTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [_feedbackTextView becomeFirstResponder];
    [self.view addSubview:_feedbackTextView];
    
//    ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [Config getMode];
//    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
//        _feedbackTextView.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1.0];
//        _feedbackTextView.textColor = [UIColor titleColor];
//    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_feedbackTextView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_feedbackTextView]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_feedbackTextView]-8-|"    options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view         attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                             toItem:_feedbackTextView attribute:NSLayoutAttributeBottom  multiplier:1.0 constant:50.0]];
}

//
//- (void)sendFeedback
//{
//    _HUD = [Utils createHUD];
//    _HUD.labelText = @"正在发送反馈";
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
//    
//    [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_PREFIX, OSCAPI_USER_REPORT_TO_ADMIN]
//       parameters:@{
//                    @"app": @(2),
//                    @"report": @(2),
//                    @"msg": _feedbackTextView.text
//                    }
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              [_HUD hide:YES];
//              MBProgressHUD *HUD = [Utils createHUD];
//              
//              HUD.mode = MBProgressHUDModeCustomView;
//              HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
//              HUD.labelText = @"发送成功，感谢您的反馈";
//              [HUD hide:YES afterDelay:2];
//              
//              [self.navigationController popViewControllerAnimated:YES];
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              _HUD.mode = MBProgressHUDModeCustomView;
//              _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
//              _HUD.labelText = @"网络异常，发送失败";
//              [_HUD hide:YES afterDelay:1.0];
//          }];
//    
//}


@end
