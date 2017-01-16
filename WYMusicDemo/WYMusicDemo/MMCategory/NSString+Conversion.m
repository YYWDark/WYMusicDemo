//
//  NSString+Conversion.m
//  WYMusicDemo
//
//  Created by wyy on 2017/1/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "NSString+Conversion.h"

@implementation NSString (Conversion)
+ (NSString *)stringConversionWithTimeInterval:(NSTimeInterval)timeInterval {
    NSUInteger time = (NSUInteger)timeInterval;
    NSInteger min =time/60;
    NSInteger seconds =time % 60;
    return [NSString stringWithFormat:@"%.2ld:%.2ld",min,seconds];
}
@end
