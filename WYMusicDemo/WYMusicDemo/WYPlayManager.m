//
//  WYPlayManager.m
//  WYMusicDemo
//
//  Created by wyy on 2017/1/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "WYPlayManager.h"
#import <AVFoundation/AVFoundation.h>

@interface WYPlayManager () <AVAudioPlayerDelegate>
@property (nonatomic,strong) AVAudioPlayer *locationPlayer;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy)   NSString *urlString;
@end

@implementation WYPlayManager

static WYPlayManager *manger = nil;
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
        //中断
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:nil];
    }
    return self;
}

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
        [self _playLocationSong:urlString];
    } else {
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
    self.locationPlayer.delegate = self;
    self.locationPlayer.numberOfLoops = 0;
    if (error.code != 0) return;
    [self.locationPlayer prepareToPlay];
    self.totalTime = self.locationPlayer.duration;
    
    // 播放
    [self _play:urlString];
   
}

- (void)_play:(NSString *)urlString{
    if (![self.locationPlayer isPlaying]) {
        [self.locationPlayer play];
        self.timer.fireDate=[NSDate distantPast];
        self.urlString = urlString;
    }
}

#pragma mark - Action
- (void)handleRouteChange:(NSNotification *)notification {
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
           [self _playLocationSong:self.urlString];
   }
}

- (void)audioSessionInterruptionNotification:(NSNotification *)notification {
    AVAudioSessionInterruptionType type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] integerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self.locationPlayer pause];
    }else if(type == AVAudioSessionInterruptionTypeEnded){
        [self.locationPlayer play];
    }
}

- (void)updateProgress:(NSTimer *)timer {
   CGFloat progress= self.locationPlayer.currentTime /self.locationPlayer.duration;
    if ([self.delegate respondsToSelector:@selector(manager:perProgress:currentTime:)]) {
        [self.delegate manager:self perProgress:progress currentTime:self.locationPlayer.currentTime];
    }
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([self.delegate respondsToSelector:@selector(manager:successfully:)]) {
        [self.delegate manager:manger successfully:flag];
    }
}

#pragma mark - Get
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(updateProgress:) userInfo:nil repeats:true];
    }
    return _timer;
}

- (NSTimeInterval)currentTime {
    return self.locationPlayer.currentTime;
}

@end
