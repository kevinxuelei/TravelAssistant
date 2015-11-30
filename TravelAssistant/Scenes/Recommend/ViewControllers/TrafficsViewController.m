//
//  TrafficsViewController.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "TrafficsViewController.h"
#import "TrafficsTableViewCell.h"
#import "TrafficsModel.h"

@interface TrafficsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TrafficsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"交通详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    [self loadTableView];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //隐藏分割线
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[TrafficsTableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

// pop回上个VC
- (void)didClickedLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


// UITableView 的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrafficsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; // 设置cell不能点击

    switch (indexPath.row) {
        case 0:
            cell.leftLabel.text = @"交通方式";
            cell.rightLabel.text = [self getTraffic:self.trafficModel.tripmode];
            break;
        case 1:
            cell.leftLabel.text = @"班次/航号";
            if ([self.trafficModel.traffic_number isEqualToString:@""]) {
                cell.rightLabel.text = @"暂无";
            }
            cell.rightLabel.text = self.trafficModel.traffic_number;
            break;
        case 2:
            cell.leftLabel.text = @"出发城市";
            cell.rightLabel.text = self.trafficModel.fromplace;
            break;
        case 3:
            cell.leftLabel.text = @"到达城市";
            cell.rightLabel.text = self.trafficModel.toplace;
            break;
        case 4:
            cell.leftLabel.text = @"出发时间";
            if (self.trafficModel.starthours == -1 && self.trafficModel.startminutes == -1) {
                cell.rightLabel.text = @"--:--";
            }else if (self.trafficModel.starthours != -1 && self.trafficModel.startminutes == -1){
                 cell.rightLabel.text = [NSString stringWithFormat:@"%ld:00",(long)self.trafficModel.starthours];
            }else {
              cell.rightLabel.text = [NSString stringWithFormat:@"%ld:%ld",(long)self.trafficModel.starthours,(long)self.trafficModel.startminutes];
            }
//            cell.rightLabel.text = [NSString stringWithFormat:@"%ld:%ld",(long)self.trafficModel.starthours,(long)self.trafficModel.startminutes];
            break;
        case 5:
            cell.leftLabel.text = @"出发时间";
            if (self.trafficModel.starthours == -1 && self.trafficModel.startminutes == -1) {
                cell.rightLabel.text = @"--:--";
            }else if (self.trafficModel.starthours != -1 && self.trafficModel.startminutes == -1){
                cell.rightLabel.text = [NSString stringWithFormat:@"%ld:00",(long)self.trafficModel.starthours];
            }else {
                cell.rightLabel.text = [NSString stringWithFormat:@"%ld:%ld",(long)self.trafficModel.starthours,(long)self.trafficModel.startminutes];
            }
            break;
        case 6:
            cell.leftLabel.text = @"花费";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@ %ld",self.trafficModel.currency,(long)self.trafficModel.price];
            break;
            
        default:
            break;
    }
    return cell;
}

- (NSString *)getTraffic:(NSInteger)tripmode {
    switch (tripmode) {
        case 1:
            return @"飞机";
            break;
        case 2:
            return @"火车";
            break;
        case 3:
            return @"汽车";
            break;
            
        default:
            break;
    }
    return nil;
}


@end
