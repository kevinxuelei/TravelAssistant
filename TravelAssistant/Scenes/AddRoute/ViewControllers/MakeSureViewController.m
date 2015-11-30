//
//  MakeSureViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/21.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MakeSureViewController.h"
#import "DestinationCityModel.h"
#import "MakeTrafficCell.h"
#import "MakeSureCell.h"
#import "NumberView.h"
#import "DateHelper.h"
#import "Macros.h"
#import "DataForServer.h"
#import <MBProgressHUD.h>

@interface MakeSureViewController ()<UITableViewDataSource, UITableViewDelegate, MakeSureCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation MakeSureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-dui"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedRightBarButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.title = @"确认天数和日期";
    // 加载步骤View
    [self loadNumberView];
    
    [self loadTableView];
    
}
#pragma mark--- navigationBar点击方法
// pop回选择目的地界面
- (void)didClickedLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 确认添加
- (void)didClickedRightBarButton
{
    NSDictionary *beijing = @{@"cityId":[NSNumber numberWithInteger:11593],
                              @"lat":[NSNumber numberWithFloat:39.904209],
                              @"lng":[NSNumber numberWithFloat:116.407394],
                              @"cn_name":@"北京",
                              @"pic_max":@"http://pic.qyer.com/album/user/861/25/SU9UQB8CaA/index/w1080"
                              };
    
    // 添加行程
    // 添加到字典中
    
    static NSString *planner_name;
    static NSString *start_time;
    static NSString *end_time;
    static NSString *cover;
    
    NSMutableArray *route_array = [NSMutableArray array];
    for (int i = 0; i < self.cityArray.count; i++) {
        DestinationCityModel *model = self.cityArray[i];
        CGFloat start_float = [model.start_time timeIntervalSince1970];
        
        NSInteger index = model.recommend_days;
        if (i == 0) {
            index++;
        }
        for (int j = 0; j < index; j++) {
            
            NSMutableArray *city_array = [NSMutableArray array];
            // 如果是第一天，则添加一个出发地：北京（后期修改）
            if (i == 0 && j == 0) {
                [city_array addObject:beijing];
            }
            NSDictionary *dic = @{@"cityId":[NSNumber numberWithInteger:model.cityId],
                                  @"lat":[NSNumber numberWithFloat:model.lat],
                                  @"lng":[NSNumber numberWithFloat:model.lng],
                                  @"cn_name":model.cn_name,
                                  @"pic_max":model.pic_max,
                                  @"start_time":[NSString stringWithFormat:@"%f", start_float + j*24*60*60],
                                  };
            [city_array addObject:dic];
            
            // 如果是该城市的最后一天，则添加下一个城市
            NSInteger num = index;
            if (i < self.cityArray.count - 1 && j == --num) {
                DestinationCityModel *nextModel = self.cityArray[i+1];
                NSDictionary *dic2 = @{@"cityId":[NSNumber numberWithInteger:nextModel.cityId],
                                      @"lat":[NSNumber numberWithFloat:nextModel.lat],
                                      @"lng":[NSNumber numberWithFloat:nextModel.lng],
                                      @"cn_name":nextModel.cn_name,
                                      @"pic_max":nextModel.pic_max,
                                      @"start_time":[NSString stringWithFormat:@"%f", [nextModel.start_time timeIntervalSince1970] + j*24*60*60],
                                      };
                [city_array addObject:dic2];
            }
            // 如果是行程的最后一天，则添加一个返回地：北京（后期修改）
            NSInteger lastNum = index;
            if (i == self.cityArray.count - 1 && j == --lastNum) {
                 [city_array addObject:beijing];
            }
            
            NSDictionary *dictionary = @{@"traffic_array":@[], @"poi_array":@[], @"city_array":city_array, @"note_array":@[], @"hotel_array":@[]};
            [route_array addObject:dictionary];
        }
        
        if (i == 0) {
            planner_name = model.cn_name;
            start_time = [NSString stringWithFormat:@"%f", [model.start_time timeIntervalSince1970]];
            cover = model.pic_max;
        }
        if (i == self.cityArray.count - 1) {
            end_time = [NSString stringWithFormat:@"%f", [model.end_time timeIntervalSince1970]];
        }
    }
//    route_array;
    NSDictionary *dictoinary = @{
                                 @"planner_name":[NSString stringWithFormat:@"%@之行", planner_name],
                                 @"start_time":start_time,
                                 @"end_time":end_time,
                                 @"start_time_format":[[DateHelper sharedDateHelper] completeTimeWithDate:[NSDate dateWithTimeIntervalSince1970:[start_time floatValue]]],
                                 @"total_day":[[DateHelper sharedDateHelper] intervalFromStartTime:start_time WithEndTime:end_time],
                                 @"cover":cover,
                                 @"route_array":route_array
                                 };
    
    // 添加到数据库
    [[DataForServer shareDataForServer] saveDataWithUser:dictoinary];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(wait) withObject:nil afterDelay:2.0f];
}
- (void)wait
{
    self.block();
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark--- 加载步骤view
- (void)loadNumberView
{
    NumberView *numberView = [[NumberView alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, 5)];
    numberView.index = 3;
    [self.view addSubview:numberView];
}
#pragma mark--- 加载tableView
- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, kVCwidth, KVCheight - 69) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MakeSureCell class] forCellReuseIdentifier:@"MakeSureCell"];
    [self.tableView registerClass:[MakeTrafficCell class] forCellReuseIdentifier:@"MakeTrafficCell"];
}
// cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 + self.cityArray.count;
}
// cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == self.cityArray.count + 1) {
        // 出发返回cell
        MakeTrafficCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeTrafficCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.model = self.cityArray[0];
        } else {
            cell.model = self.cityArray[indexPath.row - 2];
        }
        cell.date =  self.date;
        cell.row = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    MakeSureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeSureCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (indexPath.row == 1) {
        cell.date = self.date;
    } else {
        cell.date = [self.cityArray[indexPath.row - 2] end_time];
    }
    cell.model = self.cityArray[indexPath.row - 1];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 123;
}

#pragma mark--- MakeSureCellDelegate
// 提示用户重新选择时间
- (void)showAlvert
{
    UIAlertController *av = [UIAlertController alertControllerWithTitle:@"提示" message:@"时间选择有误，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [av addAction:action];
    [self.navigationController presentViewController:av animated:YES completion:nil];
}
// 修改到达时间
- (void)changeStartTimeWithNewTime:(NSDate *)date IndexPath:(NSIndexPath *)indexPath
{
    // 修改对应模型
    DestinationCityModel *model = self.cityArray[indexPath.row - 1];
    model.start_time = date;
    model.end_time = [date dateByAddingTimeInterval:model.recommend_days*24*60*60];
    
    // 修改另一个模型
    if (indexPath.row < self.cityArray.count) {
        for (int i = (int)indexPath.row; i < self.cityArray.count; i++) {
            DestinationCityModel *lastModel = self.cityArray[i - 1];
            DestinationCityModel *nextModel = self.cityArray[i];
            nextModel.start_time = lastModel.end_time;
            nextModel.end_time = [nextModel.start_time dateByAddingTimeInterval:nextModel.recommend_days*24*60*60];
        }
    } else if (indexPath.row == self.cityArray.count) {
        // 修改返回时间
        
        
    }
    [self.tableView reloadData];
}
// 修改离开时间
- (void)changeEndTimeWithNewTime:(NSDate *)date IndexPath:(NSIndexPath *)indexPath
{
    // 修改对应模型
    DestinationCityModel *model = self.cityArray[indexPath.row - 1];
    model.end_time = date;
    model.recommend_days = (NSInteger)([model.end_time timeIntervalSince1970] - [model.start_time timeIntervalSince1970]) / (24*60*60);
    // 修改另一个模型
    if (indexPath.row < self.cityArray.count) {
        for (int i = (int)indexPath.row; i < self.cityArray.count; i++) {
            DestinationCityModel *nextModel = self.cityArray[i];
            nextModel.start_time = model.end_time;
            nextModel.end_time = [nextModel.start_time dateByAddingTimeInterval:nextModel.recommend_days*24*60*60];
        }
    } else if (indexPath.row == self.cityArray.count) {
        // 修改返回时间
        
        
    }
    [self.tableView reloadData];
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
