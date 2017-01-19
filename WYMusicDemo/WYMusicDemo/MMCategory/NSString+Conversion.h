//
//  NSString+Conversion.h
//  WYMusicDemo
//
//  Created by wyy on 2017/1/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Conversion)
+ (NSString *)stringConversionWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSArray *)analysisLyricFileWithFileName:(NSString *)fileName;
@end
