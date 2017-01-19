//
//  WYSongModel.m
//  WYMusicDemo
//
//  Created by wyy on 2017/1/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "WYSongModel.h"
#import "NSString+Conversion.h"

@implementation WYSongModel
+ (instancetype)modelWithPackageDataFromDictionary:(NSDictionary *)dictionary {
    WYSongModel *model = [[WYSongModel alloc] init];
    [model packageDataFromDictionary:dictionary];
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString: @"id"]) {
        self.musicID = value;
    }
}
- (void)packageDataFromDictionary:(NSDictionary *)dictionary {
    self.lyricUrl = dictionary[@"lyricUrl"];
    self.mp3Url = dictionary[@"mp3Url"];
    self.musicID = dictionary[@"musicID"];
    self.name = dictionary[@"name"];
    self.picUrl = dictionary[@"picUrl"];
    self.singer = dictionary[@"singer"];
    self.lrcArray = [NSString analysisLyricFileWithFileName:dictionary[@"lyricUrl"]];
}
@end
