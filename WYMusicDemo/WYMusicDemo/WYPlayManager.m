//
//  WYPlayManager.m
//  WYMusicDemo
//
//  Created by wyy on 2017/1/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "WYPlayManager.h"
#import <AVFoundation/AVFoundation.h>

@interface WYPlayManager ()
@property (nonatomic,strong) AVAudioPlayer *locationPlayer; //本地
@property (nonatomic,strong) AVPlayer *audioPlayer;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) NSString *urlString;
@end

@implementation WYPlayManager

static WYPlayManager *manger = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[self alloc] init];
    });
    return manger;
}
#pragma mark - Public Method
- (void)playMusicWithUrl:(NSString *)urlString {
    if (urlString.length == 0) return;
    if ([urlString rangeOfString:@"http"].location == NSNotFound) {
       NSLog(@"本地");
        [self _playLocationSong:urlString];
    } else {
       NSLog(@"url");
        [self _playRemoteSong:urlString];
    }
}

- (void)pause {
    if ([self.locationPlayer isPlaying]) {
        [self.locationPlayer pause];
        self.timer.fireDate=[NSDate distantFuture];
    }
   
}

- (void)updateProgressForTheSongByCurrentTime:(CGFloat)progress {
   self.locationPlayer.currentTime = progress*self.locationPlayer.duration;
}
#pragma mark - Private Method
- (void)_playLocationSong:(NSString *)urlString {
    if ([self.urlString isEqualToString:urlString]) {
        [self _play:urlString];
        return;
    }
    
    NSError *error = nil;
    NSURL *url = [[NSURL alloc] initFileURLWithPath:urlString];
    self.locationPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.locationPlayer.numberOfLoops = 0;
    if (error.code != 0) return;
    // 分配播放所需的资源，并将其加入内部播放队列
    [self.locationPlayer prepareToPlay];
    self.totalTime = self.locationPlayer.duration;
    
    // 播放
    [self _play:urlString];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)_play:(NSString *)urlString{
    if (![self.locationPlayer isPlaying]) {
        [self.locationPlayer play];
        self.timer.fireDate=[NSDate distantPast];
        self.urlString = urlString;
    }
}

- (void)_playRemoteSong:(NSString *)urlString {
    //     NSURL *url = [NSURL URLWithString:urlString];
    //     AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    //     AVPlayerItem *item =[AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
    //     AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    //     self.audioPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    //     [self.audioPlayer play];
}

#pragma mark - Action
- (void)audioSessionRouteChange:(NSNotification *)notification {
   NSDictionary *dic=notification.userInfo;
   int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
    AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
   if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
      
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self pause];
        }
   }else if (changeReason==AVAudioSessionRouteChangeReasonNewDeviceAvailable ){
       //原设备为耳机则暂停
       if ([portDescription.portType isEqualToString:@"Headphones"]) {
           [self _playLocationSong:self.urlString];
       }
   }
}
- (void)updateProgress:(NSTimer *)timer {
   CGFloat progress= self.locationPlayer.currentTime /self.locationPlayer.duration;
    if ([self.delegate respondsToSelector:@selector(manager:perProgress:currentTime:)]) {
        [self.delegate manager:self perProgress:progress currentTime:self.locationPlayer.currentTime];
    }
}
#pragma mark - Get
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress:) userInfo:nil repeats:true];
    }
    return _timer;
}
@end
