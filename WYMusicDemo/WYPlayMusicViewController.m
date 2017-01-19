//
//  WYPlayMusicViewController.m
//  WYMusicDemo
//
//  Created by wyy on 2017/1/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "WYPlayMusicViewController.h"
#import "WYHeader.h"
#import "WYPlayManager.h"
#import "WYLyricLabel.h"
#import "WYSongModel.h"
#import <MediaPlayer/MediaPlayer.h>
#define KUpdateLockedUINotification @"KUpdateLockedUINotification"
@interface WYPlayMusicViewController () <WYPlayManagerDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) UIVisualEffectView *visualeffectview;
@property (nonatomic, strong) UIImageView *coverPlayImageView;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UISlider *sliderView;
@property (nonatomic, strong) WYLyricLabel *lyricLabel;
@property (nonatomic, strong) UIButton *lastSongButton;
@property (nonatomic, strong) UIButton *nextSongButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, assign) NSInteger lrcIndex;
@end

@implementation WYPlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    //读数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary *dic in arr) {
        WYSongModel *model = [WYSongModel modelWithPackageDataFromDictionary:dic];
        [self.dataArr addObject:model];
    }
    
    [self.view addSubview:self.bottomImageView];
    [self.view addSubview:self.visualeffectview];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.coverPlayImageView];
    [self.view addSubview:self.lyricLabel];
    [self.view addSubview:self.currentTimeLabel];
    [self.view addSubview:self.sliderView];
    [self.view addSubview:self.endTimeLabel];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.lastSongButton];
    [self.view addSubview:self.nextSongButton];
    
    [self _updateSongInformation];
    WYPlayManager *manager = [WYPlayManager sharedManager];
    manager.delegate = self;
    [self _layout];
    [self _notificationForLockSCreen];
}

#pragma mark - PrivateMethod
+ (void)checkoutIfSetLrc {
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateLockedUINotification object:nil];
}

- (void)_updateLockedUI {
    WYSongModel *song = self.dataArr[self.index];
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    MPMediaItemArtwork *artworkImage = [[MPMediaItemArtwork alloc]initWithImage:[UIImage imageNamed:[self _findPicWith:self.index]]];
    center.nowPlayingInfo = @{
//                            MPMediaItemPropertyAlbumTitle:music.album,
                              MPMediaItemPropertyArtist:song.singer,
                              MPMediaItemPropertyArtwork:artworkImage,
                              MPMediaItemPropertyPlaybackDuration:@([WYPlayManager sharedManager].totalTime),
                              MPMediaItemPropertyTitle:song.name,
                              MPNowPlayingInfoPropertyElapsedPlaybackTime:@([WYPlayManager sharedManager].currentTime)
                              };
}

- (void)_notificationForLockSCreen {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                    NULL, // observer
                                    displayStatusChanged, // callback
                                    CFSTR("com.apple.springboard.lockcomplete"), // event name
                                    NULL, // object
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                    NULL, // observer
                                    displayStatusChanged, // callback
                                    CFSTR("com.apple.springboard.lockstate"), // event name
                                    NULL, // object
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateLockedUI) name:KUpdateLockedUINotification object:nil];
}

- (NSString *)_findMp3With:(NSUInteger)index {
    return [self.dataArr[index] mp3Url];
}

- (NSString *)_findPicWith:(NSUInteger)index {
    return [self.dataArr[index] picUrl];
}

- (void)_updateSongInformation {
    self.bottomImageView.image = [UIImage imageNamed:[self _findPicWith:self.index]];
    self.coverPlayImageView.image = [UIImage imageNamed:[self _findPicWith:self.index]];
     self.titleLabel.text = [NSString stringWithFormat:@"%@--%@",[self.dataArr[self.index] singer],[self.dataArr[self.index] name]];
}

- (void)_rotationImageView {
  self.coverPlayImageView.transform = CGAffineTransformRotate(self.coverPlayImageView.transform, M_PI_2* 0.02);
}

- (void)_changeSong {
    self.lrcIndex = 0;
    [self _updateSongInformation];
     WYPlayManager *manager = [WYPlayManager sharedManager];
    [manager playMusicWithUrl:[[NSBundle mainBundle] pathForResource:[self _findMp3With:self.index] ofType:nil]];
    [self _updateendTime];
}

- (void)_updateendTime {
     WYPlayManager *manager = [WYPlayManager sharedManager];
    self.endTimeLabel.text = [NSString stringConversionWithTimeInterval:manager.totalTime];
}

- (void)_layout {
    self.titleLabel.frame = CGRectMake(0, 20, self.view.width, 44);
    self.bottomImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.visualeffectview.frame = CGRectMake(0, 0,self.view.width,self.view.height);
    self.coverPlayImageView.frame = CGRectMake(0, 0, WYImageSide, WYImageSide);
    self.coverPlayImageView.center = self.view.center;
    self.lyricLabel.frame = CGRectMake(0, self.view.height - 160, self.view.width, 44);
    self.currentTimeLabel.frame = CGRectMake(WYLeftRightHorizontalMargin, self.lyricLabel.bottom + 5, WYTimeLabelWidth,WYTimeLabelheight);
    self.sliderView.frame = CGRectMake(self.currentTimeLabel.right + WYLeftRightHorizontalMargin,  self.currentTimeLabel.top, self.view.width - 2*WYTimeLabelWidth - 4*WYLeftRightHorizontalMargin, WYTimeLabelheight);
    self.endTimeLabel.frame = CGRectMake(self.view.width - WYLeftRightHorizontalMargin - WYTimeLabelWidth, self.currentTimeLabel.top, WYTimeLabelWidth, WYTimeLabelheight);
    self.playButton.frame = CGRectMake((self.view.width - WYPlayButtonSide)/2, self.currentTimeLabel.bottom +5, WYPlayButtonSide, WYPlayButtonSide);
    self.lastSongButton.frame = CGRectMake(self.playButton.left  - WYButtonDistance - WYPlayButtonSide, self.playButton.top, WYPlayButtonSide, WYPlayButtonSide);
    self.nextSongButton.frame = CGRectMake(self.playButton.right + WYButtonDistance, self.playButton.top, WYPlayButtonSide, WYPlayButtonSide);
}

- (void)_updateLrcLabelWithTime:(NSTimeInterval)currentTime {
    WYPlayManager *pm = [WYPlayManager sharedManager];
    WYSongModel *model1 = self.dataArr[self.index];
    WJLrcModel *lyric = model1.lrcArray[self.lrcIndex];
    WJLrcModel *nextLyric = nil;
    if (self.lrcIndex >= model1.lrcArray.count - 1) {
        nextLyric = [[WJLrcModel alloc] init];
        nextLyric.time = pm.totalTime;
    }else{
        nextLyric = model1.lrcArray[self.lrcIndex + 1];;
    }
    
    if (currentTime < lyric.time && self.lrcIndex > 0) {
        self.lrcIndex --;
        [self _updateLrcLabelWithTime:currentTime];
    }else if(currentTime >= nextLyric.time && self.lrcIndex < model1.lrcArray.count - 1){
        self.lrcIndex ++;
        [self _updateLrcLabelWithTime:currentTime];
    }
    // 设置歌词内容
    [self.lyricLabel setValue:lyric.title forKey:@"text"];
}

- (void)_playOrPause {
    WYPlayManager *manager = [WYPlayManager sharedManager];
    if (self.playButton.selected == NO) {//播放
        [self.playButton setImage:[UIImage imageNamed:@"cm2_vehicle_btn_pause_prs"] forState:UIControlStateNormal];
        [manager playMusicWithUrl:[[NSBundle mainBundle] pathForResource:[self _findMp3With:self.index] ofType:nil]];
         [self _updateendTime];
    }else {//暂停
        [self.playButton setImage:[UIImage imageNamed:@"cm2_vehicle_btn_play_prs"] forState:UIControlStateNormal];
        [manager pause];
    }
    self.playButton.selected = !self.playButton.selected;
}
#pragma mark - Lock Screen
static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    CFStringRef nameCFString = (CFStringRef)name;
    NSString *lockState = (__bridge NSString *)nameCFString;
    NSLog(@"Darwin notification NAME = %@",name);
    
    if([lockState isEqualToString:@"com.apple.springboard.lockcomplete"])
    {
        NSLog(@"DEVICE LOCKED");
        
        [WYPlayMusicViewController checkoutIfSetLrc];
    }
    else
    {
        NSLog(@"LOCK STATUS CHANGED");
        
    }
}

#pragma mark - Action
- (void)respondToSliderAction:(UISlider *)slider {
    NSLog(@"value == %lf",slider.value);
    WYPlayManager *manager = [WYPlayManager sharedManager];
    [manager pause];
    [manager updateProgressForTheSongByCurrentTime:slider.value];
    [manager playMusicWithUrl:[[NSBundle mainBundle] pathForResource:[self _findMp3With:self.index] ofType:nil]];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [self _playOrPause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:{
            self.index = (self.index == self.dataArr.count -1)?(0):(self.index + 1);
            [self _changeSong];
            [self _updateLockedUI];
            break;}
        case UIEventSubtypeRemoteControlPreviousTrack:
            self.index = (self.index == 0)?(self.dataArr.count - 1):(self.index - 1);
            [self _changeSong];
            [self _updateLockedUI];
            break;
        default:
            break;
    }
}

- (void)respondToButtonAction:(UIButton *)button {
    switch (button.tag) {
        case 0:{//上一曲
            self.index = (self.index == 0)?(self.dataArr.count - 1):(self.index - 1);
            [self _changeSong];
            break;}
        case 1:{//播放
            [self _playOrPause];
            break;}
        case 2:{//下一曲
            self.index = (self.index == self.dataArr.count -1)?(0):(self.index + 1);
            [self _changeSong];
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
    [self _updateLrcLabelWithTime:currentTime];
  
}

- (void)manager:(WYPlayManager *)manager successfully:(BOOL)flag {
    self.index = (self.index == self.dataArr.count -1)?(0):(self.index + 1);
    [self _changeSong];
    [self _updateLockedUI];
}


#pragma mark - Get
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor =[UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)bottomImageView {
    if (_bottomImageView == nil) {
        _bottomImageView = [[UIImageView alloc] init];
    }
    return _bottomImageView;
}

- (UIVisualEffectView *)visualeffectview {
    if (_visualeffectview == nil) {
        UIBlurEffect *blureffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
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

- (WYLyricLabel *)lyricLabel {
    if (_lyricLabel == nil) {
        _lyricLabel = [[WYLyricLabel alloc] init];
        _lyricLabel.font = [UIFont systemFontOfSize:16];
        _lyricLabel.textColor =[UIColor whiteColor];
        _lyricLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lyricLabel;
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


- (UIButton *)lastSongButton {
    if (_lastSongButton == nil) {
        _lastSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastSongButton.selected = NO;
        _lastSongButton.tag = 0;
        [_lastSongButton setImage:[UIImage imageNamed:@"cm2_vehicle_btn_prev_prs"] forState:UIControlStateNormal];
        [_lastSongButton addTarget:self action:@selector(respondToButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastSongButton;
}

- (UIButton *)playButton {
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.selected = NO;
        _playButton.tag = 1;
        [_playButton setImage:[UIImage imageNamed:@"cm2_vehicle_btn_play_prs"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(respondToButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)nextSongButton{
    if (_nextSongButton == nil) {
        _nextSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextSongButton.selected = NO;
        _nextSongButton.tag = 2;
        [_nextSongButton setImage:[UIImage imageNamed:@"cm2_vehicle_btn_next_prs"] forState:UIControlStateNormal];
        [_nextSongButton addTarget:self action:@selector(respondToButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextSongButton;
}

@end
