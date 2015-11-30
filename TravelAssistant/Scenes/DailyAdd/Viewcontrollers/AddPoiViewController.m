//
//  AddPoiViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/27.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "AddPoiViewController.h"
#import "PoiDetailViewController.h"
#import "DailyPoiModel.h"
#import "AddPoiCell.h"
#import "MapHelper.h"
#import "Macros.h"
#import "DataForServer.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <MBProgressHUD.h>

@interface AddPoiViewController ()<UITableViewDataSource, UITableViewDelegate, AddPoiCellDelegate ,MBProgressHUDDelegate>

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation AddPoiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.title = @"游玩";
    
    self.selectArray = [NSMutableArray array];
    
    
}
#pragma mark--- navigationBar点击方法
// pop回上个VC
- (void)didClickedLeftBarButton
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor lightGrayColor];
    self.hud.delegate = self;
    
    // 将模型转成字典
    NSMutableArray *poiArray = [NSMutableArray array];
    for (DailyPoiModel *model in self.selectArray) {
        NSDictionary *poiDictionary = @{@"pid":[NSNumber numberWithInteger:model.pid],
                                        @"cn_name":model.cn_name,
                                        @"pic":model.pic,
                                        @"lat":[NSNumber numberWithFloat:model.lat],
                                        @"lng":[NSNumber numberWithFloat:model.lng]
                                        };
        [poiArray addObject:poiDictionary];
    }
    // 保存到数据库
    NSDictionary *dic = self.dictionary[@"route_array"][self.index];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:dic[@"poi_array"]];
    [arr addObjectsFromArray:poiArray];
    self.dictionary[@"route_array"][self.index][@"poi_array"] = arr;
    [[DataForServer shareDataForServer] updateForArray:self.dictionary[@"objectId"] data:self.dictionary];
    
    // 将已选择的景点数组传回上个VC，并刷新
    self.block(self.selectArray);
    [self hudWasHidden:self.hud];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--- 重写setter方法
- (void)setDictionary:(NSDictionary *)dictionary
{
    _dictionary = dictionary;
    NSArray *arr = dictionary[@"route_array"];
    NSDictionary *dic = arr[self.index];
    NSArray *city_arr = dic[@"city_array"];
    NSDictionary *city_dic = city_arr.lastObject;
    self.cityName  = city_dic[@"cn_name"];
    self.cityId = [city_dic[@"cityId"] integerValue];
    
    [self loadTableView];
    [self setupRefresh];
}
#pragma mark--- 请求数据
- (void)requestPoiDataWithCityId:(NSInteger)cityId Latitude:(CGFloat)lat Longitude:(CGFloat)lng Page:(NSInteger)page
{
    // 拼接网址，并转码
    NSString *urlString = [[NSString stringWithFormat:@"http://open.qyer.com/plan/poi/list?app_installtime=1447226744&cityid=%ld&client_id=qyer_planner_ios&client_secret=e24e75dbf6fa3c49651f&ip=172.21.63.97&lat=%f&lng=%f&oauth_token=638efcf04dddd20d171f8e8a1632c230&ordernum=1&page=%ld&pagesize=20&timestamp=1448607093&track_app_channel=App Store&track_app_version=1.4.5&track_device_info=iPhone 5s&track_deviceid=E928D450-E7D0-4E20-939E-1FCCF0742DB3&track_os=ios 9.1&track_user_id=&v=1", cityId, lat, lng, page] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    __weak typeof(self) pSelf = self;
    // 请求数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (page == 1) {
            pSelf.dataArray = [NSMutableArray array];
        }
        NSArray *arr = responseObject[@"data"];
        for (NSDictionary *dic in arr) {
            DailyPoiModel *model = [[DailyPoiModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [pSelf.dataArray addObject:model];
        }
        
        if (pSelf.tableView == nil) {
            [pSelf loadTableView];
        } else {
            [pSelf.tableView reloadData];
        }
        [pSelf.tableView.mj_header endRefreshing];
        [pSelf.tableView.mj_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [pSelf.tableView.mj_header endRefreshing];
        [pSelf.tableView.mj_footer endRefreshing];
        
    }];
}
#pragma mark--- 刷数据
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个@SEL）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置图片
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i < 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.tiff", i]];
        [array addObject:image];
    }
    [header setImages:array forState:MJRefreshStateIdle];
    [header setImages:array forState:MJRefreshStateRefreshing];
    // 隐藏刷新时间、文字
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
}
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    self.page = 1;
    [self requestPoiDataWithCityId:self.cityId Latitude:self.lat Longitude:self.lng Page:self.page];
}
#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    self.page++;
    [self requestPoiDataWithCityId:self.cityId Latitude:self.lat Longitude:self.lng Page:self.page];
}
#pragma mark--- 加载tableView
- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, KVCheight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[AddPoiCell class] forCellReuseIdentifier:@"AddPoiCell"];
}
// cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
// cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddPoiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPoiCell" forIndexPath:indexPath];
    BOOL is_Selected = NO; // 默认该景点为选择
    for (DailyPoiModel *model in self.selectArray) {
        if ([model isEqual:self.dataArray[indexPath.row]]) {
            // 该景点已选择
            is_Selected = YES;
        }
    }
    cell.is_Selected = is_Selected;
    cell.cityName = self.cityName;
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}
// cell的高低
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
// cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PoiDetailViewController *poiVC = [[PoiDetailViewController alloc] init];
    poiVC.poiId = [self.dataArray[indexPath.row] pid];
    poiVC.title = [self.dataArray[indexPath.row] cn_name];
    [self.navigationController showViewController:poiVC sender:self];
}

#pragma mark--- AddPoiCellDelegate
// 添加选中数组中的模型
- (void)addPoiModelWithModel:(DailyPoiModel *)model
{
    [self.selectArray addObject:model];
}
// 删除选中数组中的模型
- (void)deletePoiModelWithModel:(DailyPoiModel *)model
{
    [self.selectArray removeObject:model];
}
//
- (void)showMBPrograssHUD
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor lightGrayColor];
    self.hud.delegate = self;
    [self performSelector:@selector(removeHud) withObject:nil afterDelay:0.5f];
}
- (void)removeHud
{
    [self hudWasHidden:self.hud];
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
