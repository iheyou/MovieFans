//
//  DetailTableViewHeader.m
//  MovieFans
//
//  Created by hy on 16/1/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "DetailTableViewHeader.h"

@implementation DetailTableViewHeader

{
    CGRect  initFrame;
    CGFloat defaultViewHeight;
    CGRect   subViewsFrame;
}

-(void)layoutWithTableView:(UITableView*)tableView andBackGroundView:(UIView*)view andSubviews:(FXBlurView *)subviews
{
    
    _tableView=tableView;
    _bigImageView=view;
    _fxView=subviews;
    initFrame=_bigImageView.frame;
    defaultViewHeight  = initFrame.size.height;
    subViewsFrame=_fxView.frame;
    
    //_playButton.layer.cornerRadius=_playButton.frame.size.width/2;
    UIView* heardView=[[UIView alloc]initWithFrame:initFrame];
    self.tableView.tableHeaderView=heardView;
    [_tableView addSubview:_bigImageView];
    [_tableView addSubview:_fxView];
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGRect f     = _bigImageView.frame;
    f.size.width = _tableView.frame.size.width;
    _bigImageView.frame  = f;
    
    if (scrollView.contentOffset.y<0 ) {
        CGFloat offset = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        
        initFrame.origin.x= - offset /2;
        initFrame.origin.y= - offset;


        initFrame.size.width=_tableView.frame.size.width+offset;
        initFrame.size.height=defaultViewHeight+offset;
        _bigImageView.frame=initFrame;
        
        [self viewDidLayoutSubviews:offset/2];
    }
//    if (scrollView.contentOffset.y < -100) {
//        initFrame.size.width=_tableView.frame.size.width+(-100 + scrollView.contentInset.top) * -1;
//        initFrame.size.height=defaultViewHeight+(-100 + scrollView.contentInset.top) * -1;
//        _bigImageView.frame=initFrame;
//        
//    }
    
}
- (void)viewDidLayoutSubviews:(CGFloat)offset
{ 
    _fxView.frame=CGRectMake(0, BIGIMAGEVIEW_HEIGHT-150*KWidth_Scale, SCREEN_WIDTH+offset, 150*KWidth_Scale);
   // _fxView.center=CGPointMake(_bigImageView.center.x, _bigImageView.center.y);
    
}

- (void)resizeView
{
    initFrame.size.width = _tableView.frame.size.width;
    _bigImageView.frame = initFrame;
    
}


@end
