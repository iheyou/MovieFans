//
//  HYWeiBoLoginViewController.m
//  MovieFans
//
//  Created by hy on 2016/10/18.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYWeiBoLoginViewController.h"
#import <WeiboSDK.h>
#import "HYOAuthModel.h"
#import "HYOAuthTool.h"
#import "MePageViewController.h"

#define OA_Authorize_URL @"https://api.weibo.com/oauth2/authorize"

#define GET_ACCESSTOKEN_URL @"https://api.weibo.com/oauth2/access_token"

#define APP_SECRET @"6c34624e95c2a12cbd498636f5e04d69"

#define REDIRECT_URI @"https://api.weibo.com/oauth2/default.html"

@interface HYWeiBoLoginViewController () <UIWebViewDelegate,WeiboSDKDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation HYWeiBoLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    NSString *urlStr = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",OA_Authorize_URL,APP_KEY,REDIRECT_URI];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
}

/**是否能够去加载某个url的页面*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"url = %@",request.URL.absoluteString);
    
    NSString *urlStr = request.URL.absoluteString;
    
    NSString *codeEqual = @"code=";
    
    if ([urlStr containsString:REDIRECT_URI] && [urlStr containsString:codeEqual]) {
        
        NSArray *arr = [urlStr componentsSeparatedByString:codeEqual];
        NSString *code = arr.lastObject;
        
        // 做第二次请求，去获取 access_token (授权后的令牌)
        [self getAccessTokenWithCode:code];
        
        return NO;
    }
    return YES;
}



/**已经开始加载页面*/
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

/**加载页面完成*/
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
}

/**加载页面出错*/
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

/**获取 access_token (授权后的令牌)*/
- (void)getAccessTokenWithCode:(NSString *) code
{
    
    NSMutableDictionary *parameters = @{}.mutableCopy;
    
    parameters[@"client_id"] = APP_KEY;
    parameters[@"client_secret"] = APP_SECRET;
    parameters[@"grant_type"] = @"authorization_code";
    parameters[@"code"] = code;
    parameters[@"redirect_uri"] = REDIRECT_URI;
    
    [AFHTTPSessionManager requestWithType:AFHTTPSessionManagerRequestTypePOST URLString:GET_ACCESSTOKEN_URL parmaeters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        HYOAuthModel *model = [HYOAuthModel yy_modelWithDictionary:responseObject];
        
        BOOL isSuc = [HYOAuthTool saveWith:model];
        
        if (isSuc) {
            // 跳转到首页 或者 新特新页面
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            NSLog(@"存储授权信息失败");
        }
        
        //        OAuthModel *model1 = [OAuthModel mj_objectWithKeyValues:responseObject];
        
        
        NSLog(@"responseObj  =%@",responseObject);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@", [error localizedDescription]);
    }];
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        HYOAuthModel *model = [HYOAuthModel new];
        model.access_token = [(WBAuthorizeResponse *)response accessToken];
        model.uid = [(WBAuthorizeResponse *)response userID];
        
        BOOL isSuccess = [HYOAuthTool saveWith:model];
        if (isSuccess) {
            
        }
    }
}

@end
