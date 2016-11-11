//
//  AppDelegate.h
//  MovieFans
//
//  Created by hy on 16/1/7.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getUsersProfileProtocol <NSObject>

- (void)getUsersInfo;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

@property (nonatomic, assign) id<getUsersProfileProtocol>usersDelegate;

@end

