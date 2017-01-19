//
//  WJLrcModel.m
//  WYMusicDemo
//
//  Created by wyy on 2017/1/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "WJLrcModel.h"

@implementation WJLrcModel
+ (instancetype)modelWithTime:(NSTimeInterval)time title:(NSString *)title {
    WJLrcModel *model = [[WJLrcModel alloc] init];
    model.time = time;
    model.title = title;
    return model;
}
@end
