//
//  PlayViewController.m
//  CD1505VideoDemo
//
//  Created by hy on 16/1/14.
//  Copyright (c) 2016年 hy. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ASValueTrackingSlider.h>
#import <ASProgressPopUpView.h>
#import <SVProgressHUD.h>

@interface PlayViewController () <ASProgressPopUpViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *progressSlider;

@property (weak, nonatomic) IBOutlet UIView *maskView;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (nonatomic, strong) AVPlayerLayer *layer;

@property (nonatomic, strong) AVPlayer *avPlayer;

@property (nonatomic, strong) CADisplayLink *dpLink;
@property (weak, nonatomic) IBOutlet ASProgressPopUpView *bufferProgress;

@end

@implementation PlayViewController

- (CADisplayLink *)dpLink
{
    if (_dpLink == nil) {
        _dpLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgresss:)];
    }
    return _dpLink;
}


- (AVPlayer *)avPlayer
{
    if (_avPlayer == nil) {
        
        // 创建一个播放对象
        AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.movieUrl]];
        // 通过播放对象创建播放器
        _avPlayer = [AVPlayer playerWithPlayerItem:playItem];
        
        // 添加自己为观察者，监听当天播放对象的状态的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayer.currentItem];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlaybackStalled:) name:AVPlayerItemPlaybackStalledNotification object:_avPlayer.currentItem];
        
        
        // 监听播放对象的缓存的改变
        [self addObserverToPlayerItem:playItem];
    }
    return _avPlayer;
}

- (void)addObserverToPlayerItem:(AVPlayerItem *)item
{
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverFromPlayItem:(AVPlayerItem *)item
{
    [item removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (void)dealloc
{
    // 移除playItem的观察对象
    [self removeObserverFromPlayItem:self.avPlayer.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // abcdlkjlkajsldkjflak
    
    // 更新缓存progress的值
    // 1.获取一共缓存多少  0-2, 2-4 ,6 - 1,7-5,12-12
    AVPlayerItem *item = (AVPlayerItem *) object;
    NSArray *arr = item.loadedTimeRanges;
    NSValue *value = arr.lastObject;
    
    CMTimeRange range = [value  CMTimeRangeValue];
    
    // 1.1 获取最近的一次缓存的开始位置 和缓存的长度
    NSTimeInterval bufferBegin = CMTimeGetSeconds(range.start);
    NSTimeInterval bufferLength = CMTimeGetSeconds(range.duration);
    // 1.2 所有缓存的总长度
    CGFloat totalBuffer = bufferBegin + bufferLength;
    
    // 2.取得当前播放对象的总长度
    CGFloat totalDuring = CMTimeGetSeconds(item.duration);
    CGFloat progress = totalBuffer/totalDuring;
    
    // 3.设置缓存进度的显示
    [self.bufferProgress setProgress:progress animated:YES];
    
}

// 当前视图控制器是否支持旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持往哪些方向旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}


// 优先选择旋转的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化播放器页面
    [self setupPlayerView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setupPlayerView
{
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
    
    
    // 设置Slider的显示
    // 0.1
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    self.progressSlider.numberFormatter = numFormatter;
    
    // 设置缓存progress的显示
    [self.bufferProgress showPopUpViewAnimated:YES];
    
    self.bufferProgress.progress = 0;
    self.bufferProgress.dataSource = self;
    
}

- (void)viewWillLayoutSubviews
{
    self.layer.frame = self.view.bounds;
    
}


#pragma mark - 操作事件

- (IBAction)backBtnPressed:(UIButton *)sender {
    
    [self.avPlayer  pause];
    [self.dpLink invalidate];
    self.dpLink = nil;
    [self removeObserverFromPlayItem:self.avPlayer.currentItem];
    [self dismissViewControllerAnimated:YES completion:^{
        self.avPlayer = nil;
    }];

    
}

- (IBAction)playOrPause:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected ) { //按钮显示的是暂停
        [self.avPlayer play];
        [self.dpLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
    }else {
        [self.avPlayer pause];
//        // 让定时器失效
//        [self.dpLink invalidate];
//        self.dpLink = nil;
    }
}

/** 跳转进度*/
- (IBAction)progerssSliderValueChanged:(UISlider *)sender {
    
    if (self.avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        
        CGFloat value = sender.value;
        CMTime dur = self.avPlayer.currentItem.duration;
        CGFloat durTime = CMTimeGetSeconds(dur);
        int64_t seekingTime = value * durTime;
        [self.avPlayer pause];
        self.playBtn.selected = NO;
        
        [self.avPlayer seekToTime:CMTimeMake(seekingTime, 1.0) completionHandler:^(BOOL finished) {
            if (finished) {
                [self.avPlayer play];
                self.playBtn.selected = YES;
            }
        }];

    }else {
        
//#warning 这里slider变化了，但是应该让它不能响应拖动
        return;
    }
    
}

/** 更新播放进度*/
- (void)updateProgresss:(CADisplayLink *)link
{
    // 获取当前播放的视频的长度(时间)
    CMTime dur = self.avPlayer.currentItem.duration;
    CGFloat durTime = CMTimeGetSeconds(dur);
    
    // 获取当前已经播放的长度，(或进度)
    CMTime cur = self.avPlayer.currentItem.currentTime;
    CGFloat curTime = CMTimeGetSeconds(cur);
    
    CGFloat value = curTime/durTime;
    
    self.progressSlider.value = value;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    self.maskView.hidden = !self.maskView.hidden;
    
    if (self.maskView.hidden) {
        self.maskView.hidden = NO;
        self.maskView.alpha = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.maskView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.maskView.alpha = 0;
        } completion:^(BOOL finished) {
            self.maskView.hidden = YES;
        }];
    }
    
}


#pragma mark - 播放状态的变更通知
- (void)playbackFinished:(NSNotification *)notic
{
    NSLog(@"播放完毕");
}

- (void)PlaybackStalled:(NSNotification *)notic
{
    [SVProgressHUD showWithStatus:@"不要急，休息一会儿！"];
     NSLog(@"阻塞住了");
}

#pragma mark - ASProgressPopViewDataSource

- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s = nil;
    if (progress>0 && progress < 0.1) {
        s = @"开始缓存";
    }else if (progress>0.4&&progress<0.5) {
        s = @"快到一半了";
    }else if (progress > 0.9) {
        s = @"快要完成了";
        if (progress > 0.99) {
            s = @"完成缓存";
//           [progressView hidePopUpViewAnimated:YES];
        }
    }
    return s;
}

- (NSArray *)allStringsForProgressView:(ASProgressPopUpView *)progressView {
    NSArray *arr = [NSArray arrayWithObjects:@"开始缓存","缓存完成", nil];
    return arr;
}

@end
