//
//  TimeSwitch.h
//  jiemianDemo
//
//  Created by hy on 15/12/18.
//  Copyright © 2015年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeSwitch : NSObject

//10为时间戳转为为xx前
+ (NSString *)timeSwitch:(NSString *)time;

//6位
+ (NSString *)timeSwitchWith:(NSString*)create_at;

//+(NSString *)timeSwitchToDate:(NSInteger)time;

@end
