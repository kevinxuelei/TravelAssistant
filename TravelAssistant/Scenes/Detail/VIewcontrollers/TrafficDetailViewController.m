//
//  TrafficDetailViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "TrafficDetailViewController.h"
#import "TrafficDetailCell.h"
#import "DailyTrafficModel.h"
#import "DataForServer.h"


@interface TrafficDetailViewController ()<UITableViewDataSource, UITableViewDelegate, TrafficDetailCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end

@implementation TrafficDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.title = @"交通详情";
    
    self.dataDic = [NSMutableDictionary dictionaryWithObjects:@[@0, @0, @0, @0, @"", @"", @""] forKeys:@[@"starthours", @"startminutes", @"endhours", @"endminutes", @"fromplace", @"toplace", @"traffic_number"]];
    
    [self loadTableView];
}
#pragma mark--- navigationBar点击方法
// pop回上个VC
- (void)didClickedLeftBarButton
{
    if (_is_Create) {
        // 这是新创建的交通
        DailyTrafficModel *model = [[DailyTrafficModel alloc] init];
        [model setValuesForKeysWithDictionary:self.dataDic];
        self.block(model);
        
        NSDictionary *dic = self.dictionary[@"route_array"][self.index];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:dic[@"traffic_array"]];
        [arr addObject:self.dataDic];
        
        self.dictionary[@"route_array"][self.index][@"traffic_array"] = arr;
        [[DataForServer shareDataForServer] updateForArray:self.dictionary[@"objectId"] data:self.dictionary];
    } else {
        self.block(self.model);
        
        NSDictionary *dic = self.dictionary[@"route_array"][self.index];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:dic[@"traffic_array"]];
//        NSLog(@"%ld, %ld, %ld, %ld", self.model.starthours,self.model.startminutes,self.model.endhours,self.model.endminutes);
        if ([self.dataDic[@"starthours"] integerValue] == 0) {
            [self.dataDic setValue:[NSNumber numberWithInteger:self.model.starthours] forKey:@"starthours"];
        }
        if ([self.dataDic[@"startminutes"] integerValue] == 0) {
            [self.dataDic setValue:[NSNumber numberWithInteger:self.model.startminutes] forKey:@"startminutes"];
        }
        if ([self.dataDic[@"endhours"] integerValue] == 0) {
            [self.dataDic setValue:[NSNumber numberWithInteger:self.model.endhours] forKey:@"endhours"];
        }
        if ([self.dataDic[@"endminutes"] integerValue] == 0) {
            [self.dataDic setValue:[NSNumber numberWithInteger:self.model.endminutes] forKey:@"endminutes"];
        }
        if ([self.dataDic[@"fromplace"] isEqualToString:@""] || self.dataDic[@"fromplace"] == nil) {
            [self.dataDic setValue:self.model.fromplace forKey:@"fromplace"];
        }
        if ([self.dataDic[@"toplace"] isEqualToString:@""] || self.dataDic[@"toplace"] == nil) {
            [self.dataDic setValue:self.model.toplace forKey:@"toplace"];
        }
        if ([self.dataDic[@"traffic_number"] isEqualToString:@""] || self.dataDic[@"traffic_number"] == nil) {
            [self.dataDic setValue:self.model.traffic_number forKey:@"traffic_number"];
        }
        [arr replaceObjectAtIndex:self.row withObject:self.dataDic];
        self.dictionary[@"route_array"][self.index][@"traffic_array"] = arr;
        [[DataForServer shareDataForServer] updateForArray:self.dictionary[@"objectId"] data:self.dictionary];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--- 重写setter方法
- (void)setModel:(DailyTrafficModel *)model
{
    _model = model;
    if (_model == nil) {
        _model = [[DailyTrafficModel alloc] init];
    }
    if (self.tableView == nil) {
        [self loadTableView];
    } else {
        [self.tableView reloadData];
    }
}
#pragma mark--- tableView的加载，及代理方法
- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[TrafficDetailCell class] forCellReuseIdentifier:@"TrafficDetailCell"];
}
// cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
// cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrafficDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrafficDetailCell" forIndexPath:indexPath];
    cell.model = self.model;
    cell.row = indexPath.row;
    cell.deleagate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark--- cell代理方法
- (void)dateChangeWithHour:(NSInteger)hour Minute:(NSInteger)minute WithRow:(NSInteger)row
{
    switch (row) {
        case 3: {
            self.model.starthours = hour;
            self.model.startminutes = minute;
            [self.dataDic setValue:[NSNumber numberWithInteger:hour] forKey:@"starthours"];
            [self.dataDic setValue:[NSNumber numberWithInteger:minute] forKey:@"startminutes"];
        }
            break;
        case 4: {
            self.model.endhours = hour;
            self.model.endminutes = minute;
            [self.dataDic setValue:[NSNumber numberWithInteger:hour] forKey:@"endhours"];
            [self.dataDic setValue:[NSNumber numberWithInteger:minute] forKey:@"endminutes"];
        }
            break;
        default:
            break;
    }
}
- (void)messageChangeWithString:(NSString *)string WithRow:(NSInteger)row
{
    switch (row) {
        case 0:{
            self.model.traffic_number = string;
            [self.dataDic setValue:string forKey:@"traffic_number"];
        }
            break;
        case 1:{
            self.model.fromplace = string;
            [self.dataDic setValue:string forKey:@"fromplace"];
        }
            break;
        case 2:{
            self.model.toplace = string;
            [self.dataDic setValue:string forKey:@"toplace"];
        }
            break;
        default:
            break;
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
