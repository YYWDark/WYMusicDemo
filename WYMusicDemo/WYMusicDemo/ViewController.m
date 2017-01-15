//
//  ViewController.m
//  WYMusicDemo
//
//  Created by wyy on 17/1/15.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "ViewController.h"
#import "WYHeader.h"
#import <YTKNetwork/YTKNetwork.h>
#import <AFNetworking/AFNetworking.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager GET:kUrl parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
             
             NSArray *arr = responseObject[@"result"][@"tracks"];
             NSLog(@"%@" ,arr[0]);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@", error);
         }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
