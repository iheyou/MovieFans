//
//  WZYCustomMenu.h
//  MovieFans
//
//  Created by hy on 16/2/11.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WZYCustomMenuDelegate <NSObject>

- (void)CustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

typedef void(^Dismiss)(void);

@interface WZYCustomMenu : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<WZYCustomMenuDelegate> delegate;
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) NSArray *arrImgName;
@property (nonatomic, copy) Dismiss dismiss;

- (instancetype)initWithDataArr:(NSArray *)dataArr origin:(CGPoint)origin width:(CGFloat)width rowHeight:(CGFloat)rowHeight;

- (void)dismissWithCompletion:(void (^)(WZYCustomMenu *object))completion;


@end
