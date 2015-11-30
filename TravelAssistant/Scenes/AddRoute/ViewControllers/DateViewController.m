//
//  DateViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/21.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DateViewController.h"
#import "DestinationViewController.h"
#import "FDCalendar.h"
#import "NumberView.h"
#import "DateHelper.h"
#import "Macros.h"

@interface DateViewController ()

@property (nonatomic, strong) UIView *numberView;
@property (nonatomic, strong) FDCalendar *calendarView;
@property (nonatomic, strong) NSDate *date; // 使用时注意+8小时

@end

@implementation DateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-cuo"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-push"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedRightBarButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.title = @"选择出发日期";
    // 初始化背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"placeholder2"];
    [self.view addSubview:imageView];
    // 给self.date一个初值
    self.date = [[DateHelper sharedDateHelper] dayDateWithDate:[NSDate date]];
    // 加载步骤view
    [self loadNumberView];
    // 加载日历
    [self loadFDCalendar];
}
#pragma mark--- navigationBar点击方法
// pop回选择出发日期页面
- (void)didClickedLeftBarButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
// 前进到选择目的地页面
- (void)didClickedRightBarButton
{
//    NSLog(@"选择= %@", self.date);
//    NSLog(@"当前= %@", [[DateHelper sharedDateHelper] dayDateWithDate:[NSDate date]]);

    // 如果选择日期早于今天，则不能添加行程
    if ([self.date timeIntervalSince1970] < [[[DateHelper sharedDateHelper] dayDateWithDate:[NSDate date]] timeIntervalSince1970]) {
        UIAlertController *av = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择的日期不能早于今日" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [av addAction:okAction];
        [self.navigationController presentViewController:av animated:YES completion:nil];
    } else {
        DestinationViewController *destinationVC = [[DestinationViewController alloc] init];
        destinationVC.date = self.date;
        __weak typeof(self) pSelf = self;
        destinationVC.block = ^() {
            pSelf.block();
        };
        [self.navigationController showViewController:destinationVC sender:self];
    }
}
#pragma mark--- 加载步骤view
- (void)loadNumberView
{
    NumberView *numberView = [[NumberView alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, 5)];
    numberView.index = 1;
    [self.view addSubview:numberView];
}
#pragma mark--- 加载日历
- (void)loadFDCalendar
{
    self.calendarView = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    CGRect frame = self.calendarView.frame;
    frame.origin.y += 5;
    self.calendarView.frame = frame;
    [self.view addSubview:self.calendarView];
    __weak typeof(self) pSelf = self;
    self.calendarView.block = ^(NSDate *date) {
        pSelf.date = [[DateHelper sharedDateHelper] dayDateWithDate:date];
//        NSLog(@"选择的日期是%@", date);
    };
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
