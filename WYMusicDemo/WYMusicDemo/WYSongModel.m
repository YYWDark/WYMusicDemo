//
//  WYSongModel.m
//  WYMusicDemo
//
//  Created by wyy on 2017/1/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "WYSongModel.h"
#import <YYKit/YYKit.h>
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
    self.mp3Url = dictionary[@"mp3Url"];
    
    NSArray *arr =dictionary[@"artists"];
    //封面与专辑字典
    NSDictionary *imageAddTheAlbum = dictionary[@"album"];
    
    [self setValuesForKeysWithDictionary:dictionary];
    //歌手名
    NSDictionary *singerDic =arr[0];
    self.singer = singerDic[@"name"];
    
    //封面
    self.picUrl = imageAddTheAlbum[@"picUrl"];
    
    //专辑名
    self.theAlbumName = imageAddTheAlbum[@"name"];
    
    //歌曲简介
    NSArray *array2 = dictionary[@"alias"];
    if (array2.count >0) {
        self.musicIntroduce =array2[0];
    }
    //歌曲下载ID
    NSDictionary *musicIDDic =  dictionary[@"bMusic"];
    self.musicDownloadID = musicIDDic[@"dfsId"];
    
    //歌单封面url
    self.listTheCoverUrl = dictionary[@"coverImgUrl"];
    
    //歌单名称
    self.listName = dictionary[@"name"];
    
    //歌单内歌曲个数
//    self.musicListCount =[NSString stringWithFormat:@"%ld",array.count];
}
@end
