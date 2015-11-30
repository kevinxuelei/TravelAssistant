//
//  DailyViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DailyViewController.h"
#import "DailyTrafficCell.h"
#import "DailyHotelCell.h"
#import "DailyNoteCell.h"
#import "DailyCell.h"
#import "DailyPoiModel.h"
#import "DailyNoteModel.h"
#import "DailyHotelModel.h"
#import "DailyTrafficModel.h"
#import "MapHelper.h"
#import "Macros.h"
#import "DataForServer.h"
#import "DailyNoRoute.h"
#import "DailyNoteViewController.h"
#import "TrafficDetailViewController.h"
#import "HotelDetailViewController.h"
#import "PoiDetailViewController.h"
#import "RouteMapViewController.h"
#import "AddHotelViewController.h"
#import "AddPoiViewController.h"
#import "MainRouteModel.h"
#import "JHCustomMenu.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>

@interface DailyViewController ()<UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, JHCustomMenuDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, strong) JHCustomMenu *menu;
@property (nonatomic, assign) BOOL is_Update;

@end

@implementation DailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    
    UIBarButtonItem *mapBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-ditu"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedMapBarButton)];
    UIBarButtonItem *changeBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xiugai"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedChangeBarbutton)];
    mapBar.enabled = NO;
    mapBar.tintColor = [UIColor orangeColor];
    changeBar.enabled = NO;
    changeBar.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItems = @[mapBar, changeBar];
    
    
}
#pragma mark--- navigationBar点击方法
// pop回上个VC
- (void)didClickedLeftBarButton
{
    if (self.is_Update) {
        self.block();
        self.is_Update = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
// 打开行程地图
- (void)didClickedMapBarButton
{
    RouteMapViewController *routeVC = [[RouteMapViewController alloc] init];
    routeVC.array = self.dataArray[1];
    [self.navigationController showViewController:routeVC sender:self];
}
// 打开选择器，选择添加交通、行程、住宿、笔记
- (void)didClickedChangeBarbutton
{
    __weak __typeof(self) weakSelf = self;
    if (!self.menu) {
        self.menu = [[JHCustomMenu alloc] initWithDataArr:@[@"交通", @"游玩", @"住宿", @"笔记"] origin:CGPointMake([UIScreen mainScreen].bounds.size.width - 130, 0) width:100 rowHeight:44];
        _menu.delegate = self;
        _menu.dismiss = ^() {
            weakSelf.menu = nil;
        };
//        _menu.arrImgName = @[@"item_school.png", @"item_battle.png", @"item_list.png", @"item_chat.png"];
        [self.view addSubview:_menu];
    } else {
        [_menu dismissWithCompletion:^(JHCustomMenu *object) {
            weakSelf.menu = nil;
        }];
    }
}
// menu点击方法
- (void)jhCustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"select: %ld", indexPath.row);
    __weak typeof(self) pSelf = self;
    switch (indexPath.row) {
        case 0:{ // 添加交通页面
            TrafficDetailViewController *trafficVC = [[TrafficDetailViewController alloc] init];
            trafficVC.is_Create = YES;
            trafficVC.dictionary = self.dictionary;
            trafficVC.index = self.index;
            
            trafficVC.block = ^(DailyTrafficModel *model) {
                pSelf.is_Update = YES;
                NSMutableArray *array = pSelf.dataArray[0];
                if (array == nil) {
                    array = [NSMutableArray array];
                }
                [array addObject:model];
                [pSelf.dataArray replaceObjectAtIndex:0 withObject:array];
                if (pSelf.tableView == nil) {
                    [pSelf loadTableView];
                } else {
                    [pSelf.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            };
            [self.navigationController showViewController:trafficVC sender:self];
        }
            break;
        case 1:{ // 添加景点页面
            AddPoiViewController *addpoiVC = [[AddPoiViewController alloc] init];
            addpoiVC.index = self.index;
            addpoiVC.dictionary = self.dictionary;
            addpoiVC.block = ^(NSMutableArray *selectArray) {
                pSelf.is_Update = YES;
                NSMutableArray *array = pSelf.dataArray[1];
                if (array == nil) {
                    array = [NSMutableArray array];
                }
                [array addObjectsFromArray:selectArray];
                [pSelf.dataArray replaceObjectAtIndex:1 withObject:array];
                if (pSelf.tableView == nil) {
                    [pSelf loadTableView];
                } else {
                    [pSelf.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            };
            [self.navigationController showViewController:addpoiVC sender:self];
        }
            break;
        case 2:{ // 添加住宿页面
            AddHotelViewController *addhotelVC = [[AddHotelViewController alloc] init];
            addhotelVC.index = self.index;
            addhotelVC.dictionary = self.dictionary;
            addhotelVC.block = ^(NSMutableArray *selectArray) {
                pSelf.is_Update = YES;
                NSMutableArray *array = pSelf.dataArray[2];
                if (array == nil) {
                    array = [NSMutableArray array];
                }
                [array addObjectsFromArray:selectArray];
                [pSelf.dataArray replaceObjectAtIndex:2 withObject:array];
                if (pSelf.tableView == nil) {
                    [pSelf loadTableView];
                } else {
                    [pSelf.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            };
            [self.navigationController showViewController:addhotelVC sender:self];
        }
            break;
        case 3:{ // 添加笔记页面
            DailyNoteViewController *noteVC = [[DailyNoteViewController alloc] init];
            noteVC.dictionary = self.dictionary;
            noteVC.index = self.index;
            noteVC.is_Create = YES;
            noteVC.block = ^(DailyNoteModel *model) {
                pSelf.is_Update = YES;
                NSMutableArray *array = pSelf.dataArray[3];
                if (array == nil) {
                    array = [NSMutableArray array];
                }
                [array addObject:model];
                [pSelf.dataArray replaceObjectAtIndex:3 withObject:array];
                if (pSelf.tableView == nil) {
                    [pSelf loadTableView];
                } else {
                    [pSelf.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            };
            [self.navigationController showViewController:noteVC sender:self];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark--- 重写setter方法
- (void)setIndex:(NSInteger)index
{
    _index = index;
    NSArray *routeArray = _dictionary[@"route_array"];
    NSDictionary *dailyDictionary = routeArray[_index];
    // 交通
    NSArray *tArr = dailyDictionary[@"traffic_array"];
    NSMutableArray *trafficArr = [NSMutableArray array];
    for (NSDictionary *dic in tArr) {
        DailyTrafficModel *model = [[DailyTrafficModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [trafficArr addObject:model];
    }
    // 景点
    NSArray *pArr = dailyDictionary[@"poi_array"];
    NSMutableArray *poiArr = [NSMutableArray array];
    for (NSDictionary *dic in pArr) {
        DailyPoiModel *model = [[DailyPoiModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [poiArr addObject:model];
    }
    // 住宿
    NSArray *hArr = dailyDictionary[@"hotel_array"];
    NSMutableArray *hotelArr = [NSMutableArray array];
    for (NSDictionary *dic in hArr) {
        DailyHotelModel *model = [[DailyHotelModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [hotelArr addObject:model];
    }
    // 笔记
    NSArray *nArr = dailyDictionary[@"note_array"];
    NSMutableArray *noteArr = [NSMutableArray array];
    for (NSDictionary *dic in nArr) {
        DailyNoteModel *model = [[DailyNoteModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [noteArr addObject:model];
    }
    self.dataArray = [NSMutableArray arrayWithObjects:trafficArr, poiArr, hotelArr, noteArr, nil];
     
    // 遍历dataArray数组，如果子数组的count都为0，则提示“该日无行程”
    BOOL is_noRoute = YES;
    for (NSMutableArray *arr in self.dataArray) {
        if (arr.count != 0) {
            is_noRoute = NO;
        }
    }
    if (is_noRoute) {
        DailyNoRoute *view = [[DailyNoRoute alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, KVCheight - 64)];
        [self.view addSubview:view];
    } else {
        if (self.tableView == nil) {
            [self loadTableView];
        } else {
            [self.tableView reloadData];
        }
    }
    if (pArr.count > 0) {
        self.navigationItem.rightBarButtonItems[0].enabled = YES;
    }
    self.navigationItem.rightBarButtonItems[1].enabled = YES;
}
#pragma mark--- 请求数据

#pragma mark--- 加载tableView，及代理方法
- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, KVCheight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[DailyCell class] forCellReuseIdentifier:@"DailyCell"];
    [self.tableView registerClass:[DailyNoteCell class] forCellReuseIdentifier:@"DailyNoteCell"];
    [self.tableView registerClass:[DailyHotelCell class] forCellReuseIdentifier:@"DailyHotelCell"];
    [self.tableView registerClass:[DailyTrafficCell class] forCellReuseIdentifier:@"DailyTrafficCell"];
}
// section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
// 每个section里cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
// cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            // 交通cell
            DailyTrafficCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyTrafficCell" forIndexPath:indexPath];
            cell.model = self.dataArray[indexPath.section][indexPath.row];
            return cell;
        }
            break;
        case 1: {
            // 景点cell
            DailyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyCell" forIndexPath:indexPath];
            cell.rank = indexPath.row;
            cell.model = self.dataArray[indexPath.section][indexPath.row];
            return cell;
        }
            break;
        case 2: {
            // 住宿cell
            DailyHotelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyHotelCell" forIndexPath:indexPath];
            cell.model = self.dataArray[indexPath.section][indexPath.row];
            return cell;
        }
            break;
        default:
            break;
    }
    // 笔记cell
    DailyNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyNoteCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}
// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        DailyNoteModel *model = self.dataArray[indexPath.section][indexPath.row];
        return [self stringHeightWithString:model.message fontSize:14 contentSize:CGSizeMake(kVCwidth - 64, 1000)] + 40;
    }
    return 80;
}
// cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    __weak typeof(self) pSelf = self;
    switch (indexPath.section) {
        case 0: {
            // 交通VC
            TrafficDetailViewController *trafficVC = [[TrafficDetailViewController alloc] init];
            trafficVC.row = indexPath.row;
            trafficVC.index = self.index;
            trafficVC.dictionary = self.dictionary;
            trafficVC.model = self.dataArray[indexPath.section][indexPath.row];
            trafficVC.block = ^(DailyTrafficModel *model) {
                pSelf.is_Update = YES;
                NSMutableArray *array = pSelf.dataArray[indexPath.section];
                [array replaceObjectAtIndex:indexPath.row withObject:model];
                [pSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            [self.navigationController showViewController:trafficVC sender:self];
        }
            break;
        case 1: {
            // 景点VC
            PoiDetailViewController *poiVC = [[PoiDetailViewController alloc] init];
            DailyPoiModel *model = self.dataArray[indexPath.section][indexPath.row];
            poiVC.title = model.cn_name;
            poiVC.poiId = model.pid;
            [self.navigationController showViewController:poiVC sender:self];
        }
            break;
        case 2: {
            // 住宿VC
            HotelDetailViewController *hotelVC = [[HotelDetailViewController alloc] init];
            DailyHotelModel *model = self.dataArray[indexPath.section][indexPath.row];
            hotelVC.title = model.cn_name;
            hotelVC.hotelId = model.pid;
            [self.navigationController showViewController:hotelVC sender:self];
        }
            break;
        case 3: {
            // 笔记VC
            DailyNoteViewController *noteVC = [[DailyNoteViewController alloc] init];
            noteVC.row = indexPath.row;
            noteVC.index = self.index;
            noteVC.dictionary = self.dictionary;
            noteVC.model = self.dataArray[indexPath.section][indexPath.row];
            noteVC.block = ^(DailyNoteModel *model) {
                pSelf.is_Update = YES;
                NSMutableArray *array = pSelf.dataArray[indexPath.section];
                [array replaceObjectAtIndex:indexPath.row withObject:model];
                [pSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            [self.navigationController showViewController:noteVC sender:self];
        }
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
// 设置cell可编辑（删除）
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.is_Update = YES;
    for (UIBarButtonItem *bar in self.navigationItem.rightBarButtonItems) {
        bar.enabled = NO;
    }
    self.navigationItem.rightBarButtonItems[1].enabled = YES;
    if ([self.dataArray[1] count] != 0) {
        self.navigationItem.rightBarButtonItems[0].enabled = YES;
    }
    
    // 将修改后的字典发送到数据库
    NSDictionary *dailyDic = self.dictionary[@"route_array"][self.index];
    switch (indexPath.section) {
        case 0:{ // 删除的是交通
            NSMutableArray *array = [NSMutableArray arrayWithArray:dailyDic[@"traffic_array"]];
            [array removeObjectAtIndex:indexPath.row];
            self.dictionary[@"route_array"][self.index][@"traffic_array"] = array;
        }
            break;
        case 1:{ // 删除的是景点
            NSMutableArray *array = [NSMutableArray arrayWithArray:dailyDic[@"poi_array"]];
            [array removeObjectAtIndex:indexPath.row];
            self.dictionary[@"route_array"][self.index][@"poi_array"] = array;
        }
            break;
        case 2:{ // 删除的是住宿
            NSMutableArray *array = [NSMutableArray arrayWithArray:dailyDic[@"hotel_array"]];
            [array removeObjectAtIndex:indexPath.row];
            self.dictionary[@"route_array"][self.index][@"hotel_array"] = array;
        }
            break;
        case 3:{ // 删除的是笔记
            NSMutableArray *array = [NSMutableArray arrayWithArray:dailyDic[@"note_array"]];
            [array removeObjectAtIndex:indexPath.row];
            self.dictionary[@"route_array"][self.index][@"note_array"] = array;
        }
            break;
        default:
            break;
    }
    [[DataForServer shareDataForServer] updateForArray:self.dictionary[@"objectId"] data:self.dictionary];
    
    // 编辑的时候，必须先处理数据源，再处理view  /**** 核心 ****/
    [self.dataArray[indexPath.section] removeObjectAtIndex:indexPath.row];
    // 第一个参数，代表删除哪个分区下的cell；第二参数，代表删除的过程动画
    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark--- MBProgressHUD代理协议
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
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
