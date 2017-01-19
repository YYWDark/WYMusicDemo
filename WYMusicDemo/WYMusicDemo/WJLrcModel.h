//
//  WJLrcModel.h
//  WYMusicDemo
//
//  Created by wyy on 2017/1/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJLrcModel : NSObject
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, copy) NSString *title;

+ (instancetype)modelWithTime:(NSTimeInterval)time title:(NSString *)title;
@end
