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
#import "WYSongModel.h"
#import "WYPlayMusicViewController.h"
static const CGFloat kNavigationHeight = 0.0;
static NSString *cellID = @"MMCell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _fetchDataFromNetworkingOrCache];
}

#pragma mark - Private Method
- (void)_fetchDataFromNetworkingOrCache {
    self.dataArr = [NSMutableArray array];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    __weak typeof(self) weakSelf = self;
    [manager GET:kUrl parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
             __strong typeof(weakSelf) strongSelf = weakSelf;
             NSArray *arrry = responseObject[@"result"][@"tracks"];
             [arrry enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
              WYSongModel *model = [WYSongModel modelWithPackageDataFromDictionary:dic];
              [strongSelf.dataArr addObject:model];
             }];
             //回到主线程
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
                 [self.view addSubview:self.tableView];
             });
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    WYSongModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WYPlayMusicViewController *playVC = [[WYPlayMusicViewController alloc] init];
    playVC.model = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:playVC animated:YES];
}

#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, self.view.frame.size.width, self.view.frame.size.height - kNavigationHeight ) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.showsHorizontalScrollIndicator = YES;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        
    }
    return _tableView;
}

@end
