//
//  HotelDetailViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "HotelDetailViewController.h"
#import "HotelDetailNormalCell.h"
#import "HotelDetailReferCell.h"
#import "DailyHotelModel.h"
#import "HeaderScrollView.h"
#import "Macros.h"
#import "MapHelper.h"
#import "MapViewController.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>

@interface HotelDetailViewController ()<UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) CGFloat latitude;  // 纬度
@property (nonatomic, assign) CGFloat longitude; // 经度
@property (nonatomic, strong) DailyHotelModel *model;

@end

@implementation HotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-ditu"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedMapBarButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];

}
#pragma mark--- navigationBar点击方法
// pop回上个VC
- (void)didClickedLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 打开地图
- (void)didClickedMapBarButton
{
    MapViewController *mapVC = [[MapViewController alloc] init];
    [mapVC setLatitude:self.model.latitude Longitude:self.model.longitude Title:self.model.cn_name subTitle:self.model.en_name];
    [self.navigationController showViewController:mapVC sender:self];
}
#pragma mark--- 重写setter方法
- (void)setHotelId:(NSInteger)hotelId
{
    _hotelId = hotelId;
    self.isOpen = NO;
    [self requsetHotelDetailDataWithHotelId:hotelId Laitude:self.latitude LongItude:self.longitude];
}
#pragma mark--- 请求数据
- (void)requsetHotelDetailDataWithHotelId:(NSInteger)hotelId Laitude:(CGFloat)lat LongItude:(CGFloat)lng
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor lightGrayColor];
    self.hud.delegate = self;
    // 拼接网址，并转码
    NSString *urlString = [[NSString stringWithFormat:@"http://open.qyer.com/plan/businesshotel/detail?app_installtime=1447226744&checkin_time=2015-11-14&client_id=qyer_planner_ios&client_secret=e24e75dbf6fa3c49651f&id=%ld&ip=172.21.61.254&lat=%f&lon=%f&oauth_token=638efcf04dddd20d171f8e8a1632c230&timestamp=1448693260&track_app_channel=App Store&track_app_version=1.4.5&track_device_info=iPhone 5s&track_deviceid=E928D450-E7D0-4E20-939E-1FCCF0742DB3&track_os=ios 9.1&track_user_id=&v=1", hotelId, lat, lng] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    __weak typeof(self) pSelf = self;
    // 请求数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = responseObject[@"data"];
        pSelf.model = [[DailyHotelModel alloc] init];
        [pSelf.model setValuesForKeysWithDictionary:dic];
        
        if (pSelf.tableView == nil) {
            [pSelf loadTableView];
        } else {
            [pSelf.tableView reloadData];
        }
        // 设置tableViewHeaderView
        if (pSelf.model.piclistArr.count > 0) {
            HeaderScrollView *headerView = [[HeaderScrollView alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, kVCwidth * 0.66)];
            headerView.imageArray = pSelf.model.piclistArr;
            pSelf.tableView.tableHeaderView = headerView;
        }
        
        [pSelf hudWasHidden:pSelf.hud];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [pSelf hudWasHidden:pSelf.hud];
        
    }];
}

#pragma mark--- 加载tableView，及代理方法
- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, KVCheight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HotelDetailReferCell class] forCellReuseIdentifier:@"HotelDetailReferCell"];
    [self.tableView registerClass:[HotelDetailNormalCell class] forCellReuseIdentifier:@"HotelDetailNormalCell"];
}
// cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
// cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        HotelDetailReferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelDetailReferCell" forIndexPath:indexPath];
        cell.model = self.model;
        cell.selectionStyle = NO;
        return cell;
    }
    if (indexPath.row == 0) {
        self.isOpen = NO;
    }
    HotelDetailNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelDetailNormalCell" forIndexPath:indexPath];
    cell.isOpen = self.isOpen;
    cell.model = self.model;
    cell.row = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            if ([self.model.recommend_reason isEqualToString:@""]) {
                return 0;
            }
            return [self stringHeightWithString:self.model.recommend_reason] + 60;
        }
            break;
        case 1: {
            if ([self.model.facility_name isEqualToString:@""]) {
                return 0;
            }
            return [self stringHeightWithString:self.model.facility_name] + 60;
        }
            break;
        case 2:
            return 140;
            break;
        case 3: {
            if ([self.model.descriptionHotel isEqualToString:@""]) {
                return 0;
            }
            if (self.isOpen) {
                return [self stringHeightWithString:self.model.descriptionHotel] + 80;
            }
            return 150;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)stringHeightWithString:(NSString *)str
{
    CGRect stringRect = [str boundingRectWithSize:CGSizeMake(kVCwidth - 40, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return stringRect.size.height;
}
// cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 3) {
        if (self.isOpen) {
            self.isOpen = NO;
        } else {
            self.isOpen = YES;
        }
        NSIndexPath *ip = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        [tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark--- 懒加载
- (CGFloat)latitude
{
    return [[MapHelper sharedMapHelper] getLatitudeWithCurrentPosition];
}
- (CGFloat)longitude
{
    return [[MapHelper sharedMapHelper] getLongitudeWithCurrentPosition];
}
#pragma mark--- MBPrograssDelegate
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
