//
//  WYPlayMusicViewController.m
//  WYMusicDemo
//
//  Created by wyy on 2017/1/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "WYPlayMusicViewController.h"
#import "WYHeader.h"
#import <YYKit/YYKit.h>
#import "WYPlayManager.h"

static const CGFloat WYImageSide = 200.0f;
static const CGFloat WYLeftRightHorizontalMargin = 10.0f;
static const CGFloat WYTimeLabelWidth = 40.0f;
static const CGFloat WYTimeLabelheight = 20.0f;
static const CGFloat WYPlayButtonSide = 54.0f;
@interface WYPlayMusicViewController () <WYPlayManagerDelegate>
@property (nonatomic, strong) UIImageView *bottomImageView;    //底部模糊图片
@property (nonatomic, strong) UIVisualEffectView *visualeffectview;
@property (nonatomic, strong) UIImageView *coverPlayImageView;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UISlider *sliderView;
@property (nonatomic, strong) UIButton *lastSongButton;
@property (nonatomic, strong) UIButton *SongButton;
@property (nonatomic, strong) UIButton *playButton;
@end

@implementation WYPlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bottomImageView];
    [self.view addSubview:self.visualeffectview];
    [self.view addSubview:self.coverPlayImageView];
    [self.view addSubview:self.currentTimeLabel];
    [self.view addSubview:self.sliderView];
    [self.view addSubview:self.endTimeLabel];
    [self.view addSubview:self.playButton];
    
    __weak typeof(self) weakSelf = self;
    [self.bottomImageView setImageWithURL:[NSURL URLWithString:self.model.picUrl] placeholder:nil options:YYWebImageOptionShowNetworkActivity manager:nil progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.coverPlayImageView.image = image;
    }];
    
    WYPlayManager *manager = [WYPlayManager sharedManager];
    manager.delegate = self;
    [self _layout];
}

#pragma mark - PrivateMethod
- (void)_rotationImageView {
  self.coverPlayImageView.transform = CGAffineTransformRotate(self.coverPlayImageView.transform, M_PI_2* 0.01);
}

- (void)_layout {
    self.bottomImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.visualeffectview.frame = CGRectMake(0, 0,self.view.width,self.view.height);
    self.coverPlayImageView.frame = CGRectMake(0, 0, WYImageSide, WYImageSide);
    self.coverPlayImageView.center = self.view.center;
    self.currentTimeLabel.frame = CGRectMake(WYLeftRightHorizontalMargin, self.view.height - 100, WYTimeLabelWidth,WYTimeLabelheight);
    self.sliderView.frame = CGRectMake(self.currentTimeLabel.right + WYLeftRightHorizontalMargin,  self.currentTimeLabel.top, self.view.width - 2*WYTimeLabelWidth - 3*WYTimeLabelheight, WYTimeLabelheight);
    self.endTimeLabel.frame = CGRectMake(self.view.width - WYLeftRightHorizontalMargin - WYTimeLabelWidth, self.currentTimeLabel.top, WYTimeLabelWidth, WYTimeLabelheight);
    self.playButton.frame = CGRectMake((self.view.width - WYPlayButtonSide)/2, self.currentTimeLabel.bottom +5, WYPlayButtonSide, WYPlayButtonSide);
}
#pragma mark - Action
- (void)respondToSliderAction:(UISlider *)slider {
    NSLog(@"value == %lf",slider.value);
    WYPlayManager *manager = [WYPlayManager sharedManager];
    [manager pause];
    [manager updateProgressForTheSongByCurrentTime:slider.value];
    [manager playMusicWithUrl:[[NSBundle mainBundle] pathForResource:@"徐歌阳 - 一万次悲伤 (Live).mp3" ofType:nil]];
}

- (void)respondToButtonAction:(UIButton *)button {
    WYPlayManager *manager = [WYPlayManager sharedManager];
    switch (button.tag) {
        case 0:{//上一曲
            break;}
        case 1:{//播放
            if (button.selected == NO) {//播放
            [self.playButton setImage:[UIImage imageNamed:@"cm2_mv_btn_pause_ver"] forState:UIControlStateNormal];
            [manager playMusicWithUrl:[[NSBundle mainBundle] pathForResource:@"徐歌阳 - 一万次悲伤 (Live).mp3" ofType:nil]];
            self.endTimeLabel.text = [NSString stringConversionWithTimeInterval:manager.totalTime];
            }else {//暂停
             [self.playButton setImage:[UIImage imageNamed:@"cm2_mv_btn_play_ver"] forState:UIControlStateNormal];
            [manager pause];
            }
            self.playButton.selected = !self.playButton.selected;
            break;}
        case 2:{//下一曲
            break;}
        default:
            break;
    }
}
#pragma mark - WYPlayManagerDelegate
- (void)manager:(WYPlayManager *)manager perProgress:(CGFloat)progress currentTime:(NSTimeInterval)currentTime{
    self.sliderView.value = progress;
    self.currentTimeLabel.text = [NSString stringConversionWithTimeInterval:currentTime];
    [self _rotationImageView];
}


#pragma mark - Get
- (UIImageView *)bottomImageView {
    if (_bottomImageView == nil) {
        _bottomImageView = [[UIImageView alloc] init];
    }
    return _bottomImageView;
}

- (UIVisualEffectView *)visualeffectview {
    if (_visualeffectview == nil) {
        UIBlurEffect *blureffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        //添加毛玻璃view视图
        _visualeffectview = [[UIVisualEffectView alloc]initWithEffect:blureffect];
        _visualeffectview.alpha = 1.0f;
    }
    return _visualeffectview;
}

- (UIImageView *)coverPlayImageView {
    if (_coverPlayImageView == nil) {
        _coverPlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_default_cover_play"]];
        _coverPlayImageView.layer.cornerRadius = WYImageSide/2;
        _coverPlayImageView.clipsToBounds = YES;
    }
    return _coverPlayImageView;
}

- (UILabel *)currentTimeLabel {
    if (_currentTimeLabel == nil) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.font = [UIFont systemFontOfSize:11];
        _currentTimeLabel.text =@"00:00";
        _currentTimeLabel.textColor =[UIColor whiteColor];
    }
    return _currentTimeLabel;
}

- (UISlider *)sliderView {
    if (_sliderView == nil) {
        _sliderView = [[UISlider alloc] init];
        [_sliderView setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateNormal];
        _sliderView.minimumTrackTintColor =[UIColor redColor];
        _sliderView.maximumTrackTintColor =[UIColor grayColor];
        [_sliderView addTarget:self action:@selector(respondToSliderAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _sliderView;
}

- (UILabel *)endTimeLabel {
    if (_endTimeLabel == nil) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.font = [UIFont systemFontOfSize:11];
        _endTimeLabel.textColor =[UIColor grayColor];
        _endTimeLabel.text =@"00:00";
    }
    return _endTimeLabel;
}

- (UIButton *)playButton {
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.selected = NO;
        _playButton.tag = 1;
        [_playButton setImage:[UIImage imageNamed:@"cm2_mv_btn_play_ver"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(respondToButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
@end
