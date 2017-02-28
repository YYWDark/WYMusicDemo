//
//  NSString+Conversion.m
//  WYMusicDemo
//
//  Created by wyy on 2017/1/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "NSString+Conversion.h"
#import "WJLrcModel.h"

@implementation NSString (Conversion)
+ (NSString *)stringConversionWithTimeInterval:(NSTimeInterval)timeInterval {
    NSUInteger time = (NSUInteger)timeInterval;
    NSInteger min =time/60;
    NSInteger seconds =time % 60;
    return [NSString stringWithFormat:@"%.2ld:%.2ld",min,seconds];
}

+ (NSArray *)analysisLyricFileWithFileName:(NSString *)fileName {
    NSMutableArray *array = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSError *error = nil;
    NSString *lyricStr = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error.code != 0 ) {//解析失败
        return nil;
    }
    NSArray *lineStrs = [lyricStr componentsSeparatedByString:@"\n"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    for (NSString *eachStr in lineStrs) {
         if (eachStr.length < 11) {continue;}
         NSString *time = [eachStr substringWithRange:NSMakeRange(0, 11)];
         formatter.dateFormat = @"[mm:ss.SS]";
         NSDate *timeDate = [formatter dateFromString:time];
         NSDate *initDate = [formatter dateFromString:@"[00:00.00]"];
         [array addObject:[WJLrcModel modelWithTime:[timeDate timeIntervalSinceDate:initDate] title:[eachStr substringFromIndex:11]]]; 
    }
    
    return [array copy];
}

- (float)valueByString:(NSString *)String {
    
    return 1;
}
@end
