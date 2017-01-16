//
//  WYPlayManager.h
//  WYMusicDemo
//
//  Created by wyy on 2017/1/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol WYPlayManagerDelegate;
@interface WYPlayManager : NSObject
@property (nonatomic, weak) id<WYPlayManagerDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval totalTime;
+ (instancetype)sharedManager;
- (void)playMusicWithUrl:(NSString *)urlString;
- (void)pause;
- (void)updateProgressForTheSongByCurrentTime:(CGFloat)progress;
@end

@protocol WYPlayManagerDelegate <NSObject>
- (void)manager:(WYPlayManager *)manager perProgress:(CGFloat)progress currentTime:(NSTimeInterval)currentTime;
@end
