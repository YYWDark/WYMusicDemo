//
//  WYSongModel.h
//  WYMusicDemo
//
//  Created by wyy on 2017/1/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJLrcModel.h"
@interface WYSongModel : NSObject

@property (nonatomic, strong) NSString *mp3Url;  //歌曲网址
@property (nonatomic, strong) NSString *picUrl;  //图片网址
@property (nonatomic, strong) NSString *name;    //歌名
@property (nonatomic, strong) NSString *singer;  //歌手
@property (nonatomic, strong) NSString *lyricUrl;   //歌词
@property (nonatomic, strong) NSString *musicID;//歌曲ID
@property (nonatomic, strong) NSArray <WJLrcModel*>* lrcArray;

+ (instancetype)modelWithPackageDataFromDictionary:(NSDictionary *)dictionary;
@end
