//
//  CreatorTableViewHeader.m
//  MovieFans
//
//  Created by hy on 16/1/14.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "CreatorTableViewHeader.h"

@implementation CreatorTableViewHeader
{
    CGRect  _initFrame;
    CGFloat _defaultViewHeight;
    CGRect   _subViewsFrame;
}

-(void)layoutWithTableView:(UITableView*)tableView andBackGroundView:(UIView*)view andIconImageView:(UIImageView *)iconImageView{
    
    _tableView=tableView;
    _bigImageView=view;
    _iconImageView=iconImageView;
    _initFrame=_bigImageView.frame;
    _defaultViewHeight  = _initFrame.size.height;
    _subViewsFrame=_iconImageView.frame;
    
    //_playButton.layer.cornerRadius=_playButton.frame.size.width/2;
    UIView* heardView=[[UIView alloc]initWithFrame:_initFrame];
    self.tableView.tableHeaderView=heardView;
    [_tableView addSubview:_bigImageView];
    [_tableView addSubview:_iconImageView];

    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect f     = _bigImageView.frame;
    f.size.width = _tableView.frame.size.width;
    _bigImageView.frame  = f;
    
    if (scrollView.contentOffset.y<0) {
        CGFloat offset = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        
        _initFrame.origin.x= - offset /2;
        _initFrame.origin.y= - offset;
        _initFrame.size.width=_tableView.frame.size.width+offset;
        _initFrame.size.height=_defaultViewHeight+offset;
        _bigImageView.frame=_initFrame;
        
        [self viewDidLayoutSubviews:offset/2];
        
        
    }
    
    
}
- (void)viewDidLayoutSubviews:(CGFloat)offset
{
    _iconImageView.frame=CGRectMake(0, 0, 80+offset, 80+offset);
    _iconImageView.center=CGPointMake(_bigImageView.center.x, _bigImageView.center.y);
    _iconImageView.layer.cornerRadius=_iconImageView.frame.size.width/2;
    
    
}
- (void)resizeView
{
    _initFrame.size.width = _tableView.frame.size.width;
    _bigImageView.frame = _initFrame;
    
}

@end
