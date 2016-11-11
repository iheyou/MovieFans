//
//  TimeSwitch.m
//  jiemianDemo
//
//  Created by hy on 15/12/18.
//  Copyright © 2015年 hy. All rights reserved.
//

#import "TimeSwitch.h"

@implementation TimeSwitch

+ (NSString *)timeSwitch:(NSString *)time{
    
    NSDate * SwitchDate = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
    
    NSDate * date = [NSDate date];
    //时间管理对象
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    
    //设置时区
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    //HH是24小时制度  hh是12小时制度
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
   // NSString * timeNow = [formatter stringFromDate:date];
    
    NSTimeInterval nowTime = [date timeIntervalSince1970];
    
    int timeInterval = nowTime - [time intValue];
    
    NSString * timeString;
    if (timeInterval/60 < 60) {
        timeString = [NSString stringWithFormat:@"%d分钟前",(int)timeInterval/60];
    }
    else if (timeInterval/60 >= 60 && timeInterval/60/60 < 24){
        timeString = [NSString stringWithFormat:@"%d小时前",(int)timeInterval/60/60];
    }
    else{
//        if ((int)timeInterval/60/60/24 > 3) {
//            timeString = [NSString ]
//        }else
        if ((int)timeInterval/60/60/24 > 5) {
            timeString = [formatter stringFromDate:SwitchDate];
        }else
        timeString = [NSString stringWithFormat:@"%d天前",(int)timeInterval/60/60/24];
    }
    return timeString;
}




+ (NSString *)timeSwitchWith:(NSString*)create_at{
    // 将字符串转换成时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[create_at integerValue]];
    
    //时间显示格式
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    dataFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"CN"];
    
    //现在的时间
     NSDate *nowTime = [NSDate date];
    // 日历
    NSCalendar * calender = [NSCalendar currentCalendar];
    NSInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 获取两个时间的差。
    NSDateComponents * components = [calender components:unit fromDate:date toDate:nowTime options:NSCalendarWrapComponents];
    
    
    NSString *timeShowStr = nil;
    //是否是今年
    if (components.year < 1) {
        // 就是今年
        if ([calender isDateInToday:date]) {
            
            if (components.hour >= 1) {
                // 一小时前
                [dataFormatter setDateFormat:@"今天 HH时mm分ss秒"];
            }else {
                if (components.minute >=1) {
                    // 一分钟前
                    NSString *mstr = [NSString stringWithFormat:@"%ld分钟前",(long)components.minute];
                    
                    [dataFormatter setDateFormat:mstr];
                }else {
                    // 一分之内
                    if (components.second >=10) {
                        // 10秒前
                        NSString *sStr = [NSString stringWithFormat:@"%ld秒前",(long)components.second];
                        [dataFormatter setDateFormat:sStr];
                    }else {
                        // 10秒内
                        [dataFormatter setDateFormat:@"刚刚"];
                    }
                }
            }
            
        }else if ([calender isDateInYesterday:date]) {
            // 昨天
            [dataFormatter setDateFormat:@"昨天 HH时mm分"];
        }else {
            [dataFormatter setDateFormat:@"MM月dd日"];
        }
        
    }else {
        // 如果不是今年
        
        [dataFormatter setDateFormat:@"yyyy年MM月dd日"];
    }
    timeShowStr = [dataFormatter stringFromDate:date];
    
    
    return  timeShowStr;
}





@end
