//
//  RecommendDetailViewController.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "RecommendDetailViewController.h"
#import "RecommendDetailTableViewCell.h"
#import "ReconmendTimeTableViewCell.h"
#import "ReconmmendHotelTableViewCell.h"
#import "RecHotelViewController.h"
#import "HotelsModel.h"
#import "ScenicModel.h"
#import "TrafficsModel.h"
#import "RecommendDetailModel.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import "SectionHeadView.h"
#import "HeadView.h"
#import "TrafficsViewController.h"
#import "ScenicDetailViewController.h"
#import "HotelDetailViewController.h"

@interface RecommendDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MBProgressHUD *hud;


@end

@implementation RecommendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.mainModel.planner_name;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    [self loadData];
    [self loadTableView];

}

#pragma mark - 初始化tableView
- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    
    // TableView的headView
    HeadView *headView = [[HeadView alloc] init];
    headView.userModel = self.mainModel;
    headView.frame = CGRectMake(0, 0, self.view.frame.size.width, 180);
    self.tableView.tableHeaderView = headView;
    UIView *myView = [[UIView alloc] init];
    myView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    self.tableView.tableFooterView = myView;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[RecommendDetailTableViewCell class] forCellReuseIdentifier:@"DetailTableViewCell"];
    [self.tableView registerClass:[ReconmendTimeTableViewCell class] forCellReuseIdentifier:@"TimeTableViewCell"];
    [self.tableView registerClass:[ReconmmendHotelTableViewCell class] forCellReuseIdentifier:@"HotelTableViewCell"];
}

#pragma mark - 加载数据
- (void)loadData {
    
    // 请求数据时的菊花
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundColor = [UIColor grayColor];
    self.hud.delegate = self;
    
    __weak typeof(self) pSelf = self;
    self.dataArray = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://open.qyer.com/plan/route/someone?app_installtime=1447228203&client_id=qyer_planner_ios&client_secret=e24e75dbf6fa3c49651f&ip=172.21.56.76&lat=40.029259&limit=5&lon=116.337090&oauth_token=3e26325855856e39d033ec1ceadbd47d&page=1&planid=%ld&timestamp=1447291456&track_app_channel=App Store&track_app_version=1.4.5&track_device_info=ios device&track_deviceid=1B4337A0-6DF6-4C98-94D8-C1F4B7ACE26A&track_os=ios 9.0&track_user_id=7010309&v=1",self.mainModel.plan_id];
    
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        NSDictionary *dict1 = [responseObject valueForKey:@"data"];
        NSArray *array = [dict1 valueForKey:@"list"];
        for (NSDictionary *dic in array) {
            RecommendDetailModel *model = [[RecommendDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [pSelf.dataArray addObject:model];
        }
        
        [pSelf hudWasHidden:pSelf.hud];
        [pSelf.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        // 网络请求失败
        [pSelf hudWasHidden:pSelf.hud];
        UILabel *label = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请求数据失败";
        [pSelf.view addSubview:label];
 
    }];
    

}

#pragma mark--- MBProgressHUD代理协议
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

// pop回上个VC
- (void)didClickedLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] hotels].count + [self.dataArray[section] scenics].count + [self.dataArray[section] traffics].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.dataArray[indexPath.section] traffics].count) {
        ReconmendTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeTableViewCell" forIndexPath:indexPath];
        cell.model = [self.dataArray[indexPath.section] traffics][indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor yellowColor];
        
        return cell;
        
    }else if (indexPath.row < [self.dataArray[indexPath.section] traffics].count + [self.dataArray[indexPath.section] scenics].count) {
        RecommendDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell" forIndexPath:indexPath];
        cell.scenicModel = [self.dataArray[indexPath.section] scenics][indexPath.row - [self.dataArray[indexPath.section] traffics].count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor orangeColor];
        
        return cell;
        
    }else if (indexPath.row < [self.dataArray[indexPath.section] traffics].count + [self.dataArray[indexPath.section] scenics].count + [self.dataArray[indexPath.section] hotels].count) {
        ReconmmendHotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelTableViewCell" forIndexPath:indexPath];
        cell.hotelModel = [self.dataArray[indexPath.section] hotels][indexPath.row - [self.dataArray[indexPath.section] traffics].count - [self.dataArray[indexPath.section] scenics].count];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    return nil;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeadView *sectionHeadView = [[SectionHeadView alloc] init];
    sectionHeadView.detailModel = self.dataArray[section];
    
    return sectionHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.dataArray[indexPath.section] traffics].count) {
        TrafficsViewController *trafficVC = [[TrafficsViewController alloc] init];
        trafficVC.trafficModel = [self.dataArray[indexPath.section] traffics][indexPath.row];
        [self.navigationController showViewController:trafficVC sender:self];
        
    }else if (indexPath.row < [self.dataArray[indexPath.section] traffics].count + [self.dataArray[indexPath.section] scenics].count) {
        ScenicDetailViewController *scenicVC = [[ScenicDetailViewController alloc] init];
        scenicVC.scenicModel = [self.dataArray[indexPath.section] scenics][indexPath.row - [self.dataArray[indexPath.section] traffics].count];
        [self.navigationController showViewController:scenicVC sender:self];
        
    }else if (indexPath.row < [self.dataArray[indexPath.section] traffics].count + [self.dataArray[indexPath.section] scenics].count + [self.dataArray[indexPath.section] hotels].count) {
        
        RecHotelViewController *hotelVC = [[RecHotelViewController alloc] init];
        hotelVC.hotelId = [[self.dataArray[indexPath.section] hotels][indexPath.row - [self.dataArray[indexPath.section] traffics].count - [self.dataArray[indexPath.section] scenics].count] hotelid];
        hotelVC.title = [[self.dataArray[indexPath.section] hotels][indexPath.row - [self.dataArray[indexPath.section] traffics].count - [self.dataArray[indexPath.section] scenics].count] title];
        [self.navigationController showViewController:hotelVC sender:self];
    }
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
