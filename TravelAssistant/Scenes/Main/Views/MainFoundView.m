//
//  MainFoundView.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MainFoundView.h"
#import "MainRouteTableCell.h"
#import "MainRecommendTableCell.h"
#import "MainRecommendModel.h"
#import "MainFoundModel.h"
#import "MapHelper.h"
#import "Macros.h"
#import "RecommendDetailViewController.h"
#import <AFNetworking.h>
#import <MJRefresh.h>

@interface MainFoundView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) CGFloat latitude;  // 纬度
@property (nonatomic, assign) CGFloat longitude; // 经度
@end

@implementation MainFoundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:self.tableView];
        [self.tableView registerClass:[MainRecommendTableCell class] forCellReuseIdentifier:@"MainRecommendTableCell"];
        [self.tableView registerClass:[MainRouteTableCell class] forCellReuseIdentifier:@"MainRouteTableCell"];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = [UIScreen mainScreen].bounds;
}
- (void)setUser_id:(NSString *)user_id
{
    _user_id = user_id;
    [self setupRefresh];
}
#pragma mark--- 请求数据
- (void)requestMainRouteDataWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude Page:(NSInteger)page UserId:(NSString *)userId
{
    __weak typeof(self) pSelf = self;
    // 拼接网址，并转码
    NSString *urlString = [[NSString stringWithFormat:@"http://open.qyer.com/plan/route/library_country?app_installtime=1447226744&client_id=qyer_planner_ios&client_secret=e24e75dbf6fa3c49651f&ip=172.21.62.235&lat=%f&limit=10&lon=%f&no_recommend=0&oauth_token=190d8f729a532219d1b606ccb60a72ec&page=%ld&timestamp=1447413319&track_app_channel=App Store&track_app_version=1.4.5&track_device_info=iPhone 5s&track_deviceid=E928D450-E7D0-4E20-939E-1FCCF0742DB3&track_os=ios 9.1&track_user_id=%@&v=1", latitude, longitude, page,userId] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (page == 1) {
            pSelf.dataArray = [NSMutableArray array];
        }
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *baseArray = dataDic[@"base"];
        for (NSDictionary *dic in baseArray) {
            MainRecommendModel *model = [[MainRecommendModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [pSelf.dataArray addObject:model];
        }
        NSArray *list = dataDic[@"list"];
        for (NSDictionary *dic in list) {
            MainFoundModel *model = [[MainFoundModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [pSelf.dataArray addObject:model];
        }
        if (pSelf.dataArray.count != 0) {
            [pSelf.tableView reloadData];
            [pSelf.tableView.mj_header endRefreshing];
        } else {
            [pSelf loadNewData];
        }
        
        [pSelf.tableView.mj_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        // 网络请求失败
        UILabel *label = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请求数据失败";
        [pSelf addSubview:label];
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
    // 1.添加数据
    [self requestMainRouteDataWithLatitude:self.latitude Longitude:self.longitude Page:self.page UserId:self.user_id];
}
#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    self.page++;
    
    // 1.添加数据
    [self requestMainRouteDataWithLatitude:self.latitude Longitude:self.longitude Page:self.page UserId:self.user_id];
}

#pragma mark--- 加载tableView，及代理方法
// section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
// 每个section里cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
// cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArray[indexPath.section] plan_id] == 0) {
        // 小编推荐、查找
        MainRecommendTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainRecommendTableCell" forIndexPath:indexPath];
        cell.model = self.dataArray[indexPath.section];
        return cell;
    }
    // 用户行程
    MainRouteTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainRouteTableCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section];
    return cell;
}
// footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArray[indexPath.section] plan_id] == 0) {
        return kVwidth / 1.5;
    }
    return kVwidth / 1.5 + [self stringHeightWithString:[self.dataArray[indexPath.section] info_desc_string] fontSize:15 contentSize:CGSizeMake(kVwidth - 40, 10000)] + 20;
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
// cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 推出页面
    if ([self.dataArray[indexPath.section] plan_id] == 0) {
        // 让代理人show到小编推荐列表
        if (self.delegate && [self.delegate respondsToSelector:@selector(showRecommendViewControllerWithName:Type:)]) {
            MainRecommendModel *model = self.dataArray[indexPath.section];
            [self.delegate showRecommendViewControllerWithName:model.name Type:model.type];
        }
    } else {
        // 让代理人show到行程页面
        if (self.delegate && [self.delegate respondsToSelector:@selector(showRecommendDetailViewControllerWithMainFoundModel:)]) {
            [self.delegate showRecommendDetailViewControllerWithMainFoundModel:self.dataArray[indexPath.section]];
        }
    }
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

@end
