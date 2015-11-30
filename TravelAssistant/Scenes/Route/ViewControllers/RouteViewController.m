//
//  RouteViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/15.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "RouteViewController.h"
#import "RouteCell.h"
#import "RouteModel.h"
#import "RouteCityModel.h"
#import "MapHelper.h"
#import "Macros.h"
#import "DataForServer.h"
#import "MainRouteModel.h"
#import "DailyViewController.h"
#import "RouteMapViewController.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>

@interface RouteViewController ()<UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, copy) NSString *start_time; // 请求到数据后，传给cell
@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shouye"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    
    UIBarButtonItem *mapBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-ditu"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedMapBarButton)];
    mapBar.tintColor = [UIColor orangeColor];
    mapBar.enabled = NO;
    self.navigationItem.rightBarButtonItem = mapBar;
}
#pragma mark--- navigationBar点击方法
// pop回上个VC
- (void)didClickedLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 打开行程地图
- (void)didClickedMapBarButton
{
    RouteMapViewController *mapVC = [[RouteMapViewController alloc] init];
    // 将所有城市model传过去
    NSMutableArray *array = [NSMutableArray array];
    for (RouteModel *routeModel in self.dataArray) {
        if (routeModel.citysArray.count < 2) {
            continue;
        }
        for (RouteCityModel *cityModel in routeModel.citysArray) {
            BOOL isHave = NO;
            for (RouteCityModel *model in array) {
                if ([model.name isEqualToString:cityModel.name]) {
                    isHave = YES;
                }
            }
            if (!isHave) {
                [array addObject:cityModel];
            }
        }
    }
    mapVC.array = array;
    [self.navigationController showViewController:mapVC sender:self];
}
#pragma mark--- 重写setter方法
- (void)setRow:(NSInteger)row
{
    _row = row;
    [self loadNewData];
}
#pragma mark--- 请求数据
- (void)loadNewData
{
    // 显示菊花
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor lightGrayColor];
    self.hud.delegate = self;
    
    // 从cloud请求数据
    __weak typeof(self) pSelf = self;
    [[DataForServer shareDataForServer] getArray:^(NSArray *arr) {
        
        pSelf.dictionary = arr[pSelf.row];
        pSelf.start_time = pSelf.dictionary[@"start_time"];
        pSelf.dataArray = [NSMutableArray array];
        NSArray *routeArray = pSelf.dictionary[@"route_array"];
        for (NSDictionary *dayDic in routeArray) {
            RouteModel *model = [[RouteModel alloc] init];
            [model setValuesForKeysWithDictionary:dayDic];
            [pSelf.dataArray addObject:model];
        }
        
        if (pSelf.tableView == nil) {
            [pSelf loadTableView];
        } else {
            [pSelf.tableView reloadData];
        }
        [pSelf hudWasHidden:self.hud];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    }];
}
#pragma mark--- 加载tableView，及代理方法
- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[RouteCell class] forCellReuseIdentifier:@"RouteCell"];
}
// cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
// cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return nil;
    }
    RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RouteCell" forIndexPath:indexPath];
    cell.row = indexPath.row;
    cell.start_timel = self.start_time;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
// cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DailyViewController *dailyVC = [[DailyViewController alloc] init];
    dailyVC.dictionary = self.dictionary;
    dailyVC.index = indexPath.row;
    __weak typeof(self) pSelf = self;
    dailyVC.block = ^() {
        [pSelf loadNewData];
    };
    [self.navigationController showViewController:dailyVC sender:self];
}
// footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}
//
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
// 设置cell可编辑（删除）
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.dataArray[indexPath.row] citysArray] count] < 2) {
        return YES;
    }
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 编辑的时候，必须先处理数据源，再处理view  /**** 核心 ****/
    [self.dataArray removeObjectAtIndex:indexPath.row];
    // 第一个参数，代表删除哪个分区下的cell；第二参数，代表删除的过程动画
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    // 将修改后的字典发送到数据库
    NSMutableArray *array = self.dictionary[@"route_array"];
    [array removeObjectAtIndex:indexPath.row];
    [self.dictionary setValue:array forKey:@"route_array"];
    
    NSInteger total_day = [self.dictionary[@"total_day"] integerValue];
    total_day--;
    [self.dictionary setValue:[NSNumber numberWithInteger:total_day] forKey:@"total_day"];
    
    [[DataForServer shareDataForServer] updateForArray:self.dictionary[@"objectId"] data:self.dictionary];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark--- 经纬度懒加载
- (CGFloat)latitude
{
    return [[MapHelper sharedMapHelper] getLatitudeWithCurrentPosition];
}
- (CGFloat)longitude
{
    return [[MapHelper sharedMapHelper] getLongitudeWithCurrentPosition];
}
#pragma mark--- MBPrograssHUD代理协议
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
