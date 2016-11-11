//
//  BigPictureViewController.m
//  LimitFreeDemo
//
//  Created by hy on 15/12/18.
//  Copyright © 2015年 hy. All rights reserved.
//

#import "BigPictureViewController.h"
#import "UIImageView+WebCache.h"
#import "KVNProgress.h"
#import "FilmPhotosModel.h"

@interface BigPictureViewController ()<UIScrollViewDelegate>
{
    UIImageView * _topImageView; // 顶部的图片
    UIScrollView * _bigPictureScrollView; // 中间部分的滚动视图
    UIImageView * _bottomImageView; // 底部的图片
    
    UILabel * _titleLabel;
    UIButton * _doneButton;
    UIButton * _saveButton;
    CGFloat _lastScale;
}

@end

@implementation BigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self createUI];
    // 填充视图
    [self fillUI];
    
    // 通过KVO方式监听selectedIndex值变化
    [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 修改状态栏的样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    UIStatusBarStyleDefault
//    UIStatusBarStyleLightContent
    // 在plist文件中添加使视图控制器能够修改状态栏【View controller-based status bar appearance】设置为NO
}


- (void)dealloc
{
    // 移除观察者
    [self removeObserver:self forKeyPath:@"selectedIndex"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 创建视图
- (void)createUI
{
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [self.view addSubview:_topImageView];
    _topImageView.image = [UIImage imageNamed:@"tabbar_bg"];
    _topImageView.userInteractionEnabled = YES;
    
    _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    [self.view addSubview:_bottomImageView];
    _bottomImageView.image = [UIImage imageNamed:@"tabbar_bg"];
    _bottomImageView.userInteractionEnabled = YES;
    
    _bigPictureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topImageView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_topImageView.frame) - CGRectGetHeight(_bottomImageView.frame))];
    [self.view addSubview:_bigPictureScrollView];
    _bigPictureScrollView.backgroundColor = [UIColor blackColor];
    _bigPictureScrollView.delegate = self;
    // 添加手势识别器
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBigPicTap:)];
    [_bigPictureScrollView addGestureRecognizer:tapGesture];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_topImageView.frame)/2 - 100, 0, 200, CGRectGetHeight(_topImageView.frame))];
    [_topImageView addSubview:_titleLabel];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:20];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_topImageView addSubview:_doneButton];
    _doneButton.frame = CGRectMake(CGRectGetWidth(_topImageView.frame) - 60, 7, 50, 30);
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    _doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_bottomImageView addSubview:_saveButton];
    _saveButton.frame = _doneButton.frame;
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    _saveButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

// 手势点击方法
- (void)onBigPicTap:(UITapGestureRecognizer *) sender
{
    // 判断视图是否隐藏
    if ([_topImageView isHidden]) {
        _topImageView.hidden = NO;
        _bottomImageView.hidden =NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    else {
        _topImageView.hidden = YES;
        _bottomImageView.hidden = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
}



- (void)doneButtonClicked:(UIButton *) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonClicked:(UIButton *) sender
{
    [KVNProgress showWithStatus:@"保存图片到相册中..."];
    
    // 获取当前UIScrollView显示的UIImageView
    UIImageView * imageView = _bigPictureScrollView.subviews[self.selectedIndex];
    // 保存UIImageView上图片到相册中
    // 参数2和参数3：target-action 保存图片完成后的回调
    // 参数4：上下文
    UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(saveImage:didFinishSavingWithError:contextInfo:), nil);
}

- (void)saveImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"保存失败");
        [KVNProgress showErrorWithStatus:@"保存图片失败，请重新保存"];
    }
    else {
        NSLog(@"保存成功");
        [KVNProgress showSuccessWithStatus:@"保存成功"];
    }
    
}

// 填充UI
- (void)fillUI
{
    _titleLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.selectedIndex+1, self.photos.count];
    
    CGSize scrollViewSize = _bigPictureScrollView.frame.size;
    
    //CGFloat imageViewHeight = scrollViewSize.width / 1.8;
    
    for (int index = 0; index < self.photos.count; index++) {
        // 获取对应的模型数据
        FilmPhotosModel * model = self.photos[index];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index*scrollViewSize.width,0, scrollViewSize.width,scrollViewSize.height )];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //CGRectMake(index*scrollViewSize.width, scrollViewSize.height/2 - imageViewHeight/2-20, scrollViewSize.width, imageViewHeight+40)
        imageView.tag = 100 + index;
        [_bigPictureScrollView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.photo_url] placeholderImage:[UIImage imageNamed:@"weibo movie_yingping_pic_placeholder"]];
        imageView.userInteractionEnabled = YES;

        //创建捏合手势
        UIPinchGestureRecognizer * pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(onPinch:)];
        [imageView addGestureRecognizer:pinchGesture];
    }
    // 设置内容尺寸
    _bigPictureScrollView.contentSize = CGSizeMake(self.photos.count*scrollViewSize.width, scrollViewSize.height);
    // 设置按页显示
    _bigPictureScrollView.pagingEnabled = YES;
    // 关闭弹簧效果
    _bigPictureScrollView.bounces = NO;
    // 让滚动视图跳转到相对应的位置
    _bigPictureScrollView.contentOffset = CGPointMake(self.selectedIndex*scrollViewSize.width, 0);
}

//实现捏合手势方法
- (void)onPinch:(UIPinchGestureRecognizer *)sender{
    
    UIImageView * imageView = [self.view viewWithTag:self.selectedIndex + 100];
    //捏合手势放大或缩小手势
    imageView.transform = CGAffineTransformMakeScale(sender.scale, sender.scale);
    //判断当前手势的状态，若手势取消则图片恢复原状
    if (sender.state == UIGestureRecognizerStateEnded) {
        imageView.transform = CGAffineTransformIdentity;
    }
    
//    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
//        _lastScale = 1.0;
//    }
//    
//    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
//    
//    CGAffineTransform currentTransform = imageView.transform;
//    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
//    
//    [imageView setTransform:newTransform];
//    
//    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
//    if ([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
//        if (_lastScale > scale) {
//            [imageView setTransform:currentTransform];
//        }
//    }
    
}


#pragma mark - UIScrollViewDelegate

// 减速结束回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _titleLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.selectedIndex+1, self.photos.count];
}


@end
