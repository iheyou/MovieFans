//
//  CatAnimationLogin.h
//  MovieFans
//
//  Created by hy on 16/2/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ClickType){
    clicktypeNone,
    clicktypeUser,
    clicktypePass
};

@interface CatAnimationLogin : UIView

@property (strong, nonatomic)UITextField *userNameTextField;
@property (strong, nonatomic)UITextField *PassWordTextField;
@property (assign,nonatomic) ClickType clicktype;

@end
