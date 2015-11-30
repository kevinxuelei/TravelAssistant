//
//  CommentViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/18.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "CommentViewController.h"
#import "PoiDetailCommentCell.h"
#import "CommentModel.h"
#import "Macros.h"
#import "MapHelper.h"
#import <MJRefresh.h>
#import <AFNetworking.h>

@interface CommentViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger maxPage;
@property (nonatomic, assign) CGFloat latitude;  // 纬度
@property (nonatomic, assign) CGFloat longitude; // 经度

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    
    [self loadTableView];
    [self setupRefresh];
}
#pragma mark--- navigationBar点击方法
// pop回上个VC
- (void)didClickedLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--- 请求数据
- (void)requestCommentDataWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude Page:(NSInteger)page PoiId:(NSInteger)pid
{
    // 拼接网址并转码
    NSString *urlString = [[NSString stringWithFormat:@"http://open.qyer.com/plan/poi/comment_list?app_installtime=1447226744&client_id=qyer_planner_ios&client_secret=e24e75dbf6fa3c49651f&ip=172.21.63.239&lat=%f&lon=%f&oauth_token=638efcf04dddd20d171f8e8a1632c230&page=%ld&pagesize=20&poi_id=%ld&timestamp=1447852008&track_app_channel=App Store&track_app_version=1.4.5&track_device_info=iPhone 5s&track_deviceid=E928D450-E7D0-4E20-939E-1FCCF0742DB3&track_os=ios 9.1&track_user_id=&v=1", latitude, longitude, page, pid] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    __weak typeof(self) pSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *d1 = responseObject[@"data"];
        pSelf.maxPage = [d1[@"total"] integerValue] / 20;
        NSArray *arr = d1[@"comment"];
        for (NSDictionary *dic in arr) {
            CommentModel *model = [[CommentModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [pSelf.dataArray addObject:model];
        }
        
        [pSelf.tableView reloadData];
        [pSelf.tableView.mj_header endRefreshing];
        if (pSelf.page < pSelf.maxPage) {
            [pSelf.tableView.mj_footer endRefreshing];
        } else {
            [pSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        // 网络请求失败
        UILabel *label = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请求数据失败";
        [pSelf.view addSubview:label];
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
    self.dataArray = [NSMutableArray array];
    // 1.添加数据
    [self requestCommentDataWithLatitude:self.latitude Longitude:self.longitude Page:self.page PoiId:self.pid];
    
}
#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    self.page++;
    // 1.添加数据
    [self requestCommentDataWithLatitude:self.latitude Longitude:self.longitude Page:self.page PoiId:self.pid];
    
}
#pragma mark--- 加载tableView及代理方法
- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, KVCheight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[PoiDetailCommentCell class] forCellReuseIdentifier:@"PoiDetailCommentCell"];
}
// cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
// cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PoiDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoiDetailCommentCell" forIndexPath:indexPath];
    cell.row = indexPath.row;
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [self stringHeightWithString:[self.dataArray[indexPath.row] comment]] + 100;
    }
    return [self stringHeightWithString:[self.dataArray[indexPath.row] comment]] + 60;
}
// 在返回每个row的高度时，调用此方法
- (CGFloat)stringHeightWithString:(NSString *)str
{
    CGRect stringRect = [str boundingRectWithSize:CGSizeMake(kVCwidth - 60, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return stringRect.size.height;
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
