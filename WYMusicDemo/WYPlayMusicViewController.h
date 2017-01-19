//
//  WYPlayMusicViewController.h
//  WYMusicDemo
//
//  Created by wyy on 2017/1/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYSongModel.h"

@interface WYPlayMusicViewController : UIViewController
@property (nonatomic, strong)WYSongModel *model;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)NSUInteger index;
@end
