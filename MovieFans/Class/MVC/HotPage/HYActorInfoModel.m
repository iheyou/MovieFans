//
//  HYActorInfoModel.m
//  MovieFans
//
//  Created by hy on 2016/10/10.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "HYActorInfoModel.h"
#import <UIKit/UIKit.h>

extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;

@implementation HYActorInfoModel {
    CGFloat _lastContentWidth;
}

@synthesize desc = _desc;

- (void)setDesc:(NSString *)desc {
    _desc = desc;
}

- (NSString *)desc {
    CGFloat contentW = SCREEN_WIDTH - 10;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect descRect = [_desc boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (descRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }
    return _desc;
}

- (void)setIsOpening:(BOOL)isOpening {
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

@end
