//
//  NSString+ZLStringSize.h
//  ZLDropDownMenuDemo
//
//  Created by hy on 16/1/27.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface NSString (ZLStringSize)

- (CGSize)zl_stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;
- (CGSize)zl_stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
- (CGSize)zl_stringSizeWithFont:(UIFont *)font;

@end
