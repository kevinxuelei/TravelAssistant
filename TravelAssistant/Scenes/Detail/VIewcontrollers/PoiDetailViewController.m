//
//  PoiDetailViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "PoiDetailViewController.h"
#import "DailyPoiModel.h"
#import "PoiDetailMapCell.h"
#import "PoiDetailBaseCell.h"
#import "PoiDetailIntroCell.h"
#import "PoiDetailTipsCell.h"
#import "PoiDetailCommentCell.h"
#import "CommentViewController.h"
#import "HeaderScrollView.h"
#import "HeaderPoiView.h"
#import "Macros.h"
#import "MapViewController.h"
#import "MapHelper.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>

@interface PoiDetailViewController ()<UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UIView *headerView; // 顶部轮播图
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DailyPoiModel *model;
@property (nonatomic, assign) BOOL isOpen; // 记录cell是否展开
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation PoiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.isOpen = NO;
    
}
#pragma mark--- navigationBar点击方法
// pop回上个VC
- (void)didClickedLeftBarButton
{
    // pop
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--- 重写setter方法
- (void)setPoiId:(NSInteger)poiId
{
    _poiId = poiId;
    [self requestPoiDetailDataWithPoiId:self.poiId Latitude:self.latitude Lonitude:self.longitude];
}
#pragma mark--- 请求数据
- (void)requestPoiDetailDataWithPoiId:(NSInteger)poiId Latitude:(CGFloat)lat Lonitude:(CGFloat)lng
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor lightGrayColor];
    self.hud.delegate = self;
    // 拼接网址，并转码
    NSString *urlString = [[NSString stringWithFormat:@"http://open.qyer.com/plan/place/detail?app_installtime=1447226744&client_id=qyer_planner_ios&client_secret=e24e75dbf6fa3c49651f&id=%ld&ip=172.21.63.97&lat=%f&lon=%f&oauth_token=638efcf04dddd20d171f8e8a1632c230&timestamp=1448634239&track_app_channel=App Store&track_app_version=1.4.5&track_device_info=iPhone 5s&track_deviceid=E928D450-E7D0-4E20-939E-1FCCF0742DB3&track_os=ios 9.1&track_user_id=&v=1", poiId, lat, lng] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    __weak typeof(self) pSelf = self;
    // 请求数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = responseObject[@"data"];
        pSelf.model = [[DailyPoiModel alloc] init];
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
            
            HeaderPoiView *poiView = [[HeaderPoiView alloc] initWithFrame:CGRectMake(20, kVCwidth * 0.66 - 70, kVCwidth / 3, 60)];
            [poiView setBeenCounts:pSelf.model.beentocounts];
            [poiView setCnName:pSelf.model.cn_name];
            [poiView setEnName:pSelf.model.en_name];
            [headerView addSubview:poiView];
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
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[PoiDetailMapCell class] forCellReuseIdentifier:@"PoiDetailMapCell"];
    [self.tableView registerClass:[PoiDetailBaseCell class] forCellReuseIdentifier:@"PoiDetailBaseCell"];
    [self.tableView registerClass:[PoiDetailIntroCell class] forCellReuseIdentifier:@"PoiDetailIntroCell"];
    [self.tableView registerClass:[PoiDetailTipsCell class] forCellReuseIdentifier:@"PoiDetailTipsCell"];
    [self.tableView registerClass:[PoiDetailCommentCell class] forCellReuseIdentifier:@"PoiDetailCommentCell"];
    [self.tableView registerClass:[PoiDetailMapCell class] forCellReuseIdentifier:@"PoiDetailMapCell"];
    // 设置tableViewFooterView
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    footerButton.frame = CGRectMake(60, 15, kVCwidth - 120, 30);
    footerButton.layer.masksToBounds = YES;
    footerButton.layer.cornerRadius = 10;
    footerButton.layer.borderWidth = 1;
    footerButton.layer.borderColor = [UIColor orangeColor].CGColor;
    [footerButton setBackgroundColor:[UIColor clearColor]];
    [footerButton setTitle:@"查看更多评论" forState:UIControlStateNormal];
    [footerButton setTintColor:[UIColor orangeColor]];
    [footerButton addTarget:self action:@selector(didClickedFooterButton) forControlEvents:UIControlEventTouchUpInside];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, 70)];
    [footerView addSubview:footerButton];
    self.tableView.tableFooterView = footerView;
}
- (void)didClickedFooterButton
{
    CommentViewController *comment = [[CommentViewController alloc] init];
    comment.pid = self.poiId;
    [self.navigationController showViewController:comment sender:self];
}
// section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
// 每个section里cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 2:
            if ([self.model.tips isEqualToString:@""]) {
                return 0;
            }
            break;
        case 3:
            return self.model.commentArr.count;
            break;
        default:
            break;
    }
    return 1;
}
// cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                // 基础信息cell
                PoiDetailBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoiDetailBaseCell" forIndexPath:indexPath];
                cell.model = self.model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            // 地图cell
            PoiDetailMapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoiDetailMapCell" forIndexPath:indexPath];
            cell.model = self.model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1: {
            // 简介cell
            PoiDetailIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoiDetailIntroCell" forIndexPath:indexPath];
            cell.isOpen = self.isOpen;
            cell.introduction = self.model.introduction;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2: {
            // 小贴士cell
            PoiDetailTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoiDetailTipsCell" forIndexPath:indexPath];
            cell.tips = self.model.tips;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            break;
    }
    // 评论cell
    PoiDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoiDetailCommentCell" forIndexPath:indexPath];
    cell.row = indexPath.row;
    cell.model = self.model.commentArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                // 基础信息的高度
                CGFloat flag = [self stringHeightWithString:self.model.wayto fontSize:14 contentSize:CGSizeMake(kVCwidth - 40, 10000)] + [self stringHeightWithString:self.model.opentime fontSize:14 contentSize:CGSizeMake(kVCwidth - 40, 10000)] + [self stringHeightWithString:self.model.price fontSize:14 contentSize:CGSizeMake(kVCwidth - 40, 10000)] + [self stringHeightWithString:self.model.site fontSize:14 contentSize:CGSizeMake(kVCwidth - 40, 10000)] + [self stringHeightWithString:self.model.address fontSize:14 contentSize:CGSizeMake(kVCwidth - 40, 10000)];
                return flag + 270;
            }
            // 地图的高度
            return 100;
        }
            break;
        case 1: {
            if ([self.model.introduction isEqualToString:@""]) {
                return 0;
            }
            if (_isOpen) {
                return [self stringHeightWithString:self.model.introduction fontSize:14 contentSize:CGSizeMake(kVCwidth - 40, 10000)] + 70;
            }
            // 简介的高度
            return 140;
        }
            break;
        case 2: {
            // 小贴士的高度
            if ([self.model.tips isEqualToString:@""]) {
                return 0;
            }
            return [self stringHeightWithString:self.model.tips fontSize:14 contentSize:CGSizeMake(kVCwidth - 40, 10000)] + 60;
        }
            break;
        case 3: {
            // 每条评论的高度
            if (indexPath.row == 0) {
                return [self stringHeightWithString:[self.model.commentArr[indexPath.row] comment] fontSize:14 contentSize:CGSizeMake(kVCwidth - 72, 1000)] + 100;
            }
            return [self stringHeightWithString:[self.model.commentArr[indexPath.row] comment] fontSize:14 contentSize:CGSizeMake(kVCwidth - 72, 1000)] + 60;
        }
            break;
        default:
            break;
    }
    return 0;
}
// cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 1) {
                MapViewController *mapVC = [[MapViewController alloc] init];
                [mapVC setLatitude:self.model.lat Longitude:self.model.lng Title:self.model.cn_name subTitle:self.model.en_name];
                [self.navigationController showViewController:mapVC sender:self];
            }
        }
            break;
        case 1: {
            if (self.isOpen) {
                self.isOpen = NO;
            } else {
                self.isOpen = YES;
            }
            NSIndexPath *ip = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            [tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        default:
            break;
    }
}
// 在返回每个row的高度时，调用此方法
- (CGFloat)stringHeightWithString:(NSString *)str fontSize:(CGFloat)fontSize contentSize:(CGSize)size
{
    // 第一个参数：代表最大的范围
    // 第二个参数：代表的是 是否考虑字体，是否考虑字号
    // 第三个参数：代表的是是用什么字体什么字号
    // 第四个参数：用不到，所以基本写成nil
    CGRect stringRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return stringRect.size.height;
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
