//
//  MainViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MainViewController.h"
#import "MainRouteView.h"
#import "MainFoundView.h"
#import "MainRouteViewController.h"
#import "Macros.h"
#import "UserViewController.h"
#import "RecommendDetailViewController.h"
#import "RouteViewController.h"
#import "DateViewController.h"
#import "MapHelper.h"
#import <AVUser.h>
#import "LoginViewController.h"

@interface MainViewController ()<MainFoundViewDelegate, MainRouteViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) MainRouteView *routeView;  // 我的行程页面
@property (nonatomic, strong) MainFoundView *foundView; // 发现页面

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-user"] style:UIBarButtonItemStylePlain target:self action:@selector(toPriviteViewController:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jiahao"] style:UIBarButtonItemStylePlain target:self action:@selector(addRoute)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
    
    [self loadSubViews];
    [self loadSegmentControl];
    self.routeView.user_id = @"7010389";
    self.foundView.user_id = @"7010389";
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark--- navigationItem点击事件
// 跳转到个人信息页面
- (void)toPriviteViewController:(UIBarButtonItem *)sender
{
    UserViewController *user = [[UserViewController alloc] init];
    __weak typeof(self) pSelf = self;
    user.block = ^() {
        [pSelf.routeView loadNewData];
    };
    [self.navigationController pushViewController:user animated:YES];
}
// 跳转到添加行程页面
- (void)addRoute
{
    // 先判断用户是否登录
    AVUser *currentUser = [AVUser currentUser];
    
    if (currentUser.username == nil) {
    
        // 如果未登录，跳转到登陆页面
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNavigation = [[UINavigationController alloc] initWithRootViewController:login];
        __weak typeof(self) pSelf = self;
        login.block = ^() {
            [pSelf.routeView loadNewData];
        };
        [self presentViewController:loginNavigation animated:YES completion:nil];
    
    } else {
        // 如果已登录，选择行程出发日期
        DateViewController *dateVC = [[DateViewController alloc] init];
        __weak typeof(self) pSelf = self;
        dateVC.block = ^() {
            [pSelf.routeView loadNewData];
        };
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:dateVC];
        [self.navigationController presentViewController:navi animated:YES completion:nil];
    }
}
#pragma mark--- 初始化两个view
- (void)loadSubViews
{
    self.routeView = [[MainRouteView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.routeView.backgroundColor = [UIColor whiteColor];
    self.routeView.delegate = self;
    [self.view addSubview:self.routeView];
    
    self.foundView = [[MainFoundView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.foundView.delegate = self;
    self.foundView.backgroundColor = [UIColor whiteColor];
}
#pragma mark--- 加载segmentControl
- (void)loadSegmentControl
{
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"我的行程", @"发现"]];
    self.segmentControl.bounds = CGRectMake(0, 0, kVCwidth / 2, 30);
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentControl.tintColor = [UIColor orangeColor];
    [self.segmentControl addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentControl;
}
// segmentControl点击方法
- (void)changeView:(UISegmentedControl *)seg
{
    switch (seg.selectedSegmentIndex) {
        case 0:{
            if (self.navigationItem.rightBarButtonItem == nil) {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jiahao"] style:UIBarButtonItemStylePlain target:self action:@selector(addRoute)];
                self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
            }
            [self.foundView removeFromSuperview];
            [self.view addSubview:self.routeView];
        }
            break;
        case 1:{
            if (self.navigationItem.rightBarButtonItem != nil) {
                self.navigationItem.rightBarButtonItem = nil;
            }
            [self.routeView removeFromSuperview];
            [self.view addSubview:self.foundView];
        }
            break;
        default:
            break;
    }
}
#pragma maek--- MainFoundView代理方法
// show到小编推荐列表
- (void)showRecommendViewControllerWithName:(NSString *)name Type:(NSInteger)type
{
    MainRouteViewController *mainRouteVC = [[MainRouteViewController alloc] init];
    mainRouteVC.title = name;
    mainRouteVC.name = name;
    mainRouteVC.type = type;
    mainRouteVC.user_id = @"7010389";
    [self.navigationController showViewController:mainRouteVC sender:self];
}
// show到行程页面
- (void)showRecommendDetailViewControllerWithMainFoundModel:(MainFoundModel *)model
{
    RecommendDetailViewController *recommendVC = [[RecommendDetailViewController alloc] init];
    recommendVC.mainModel = model;
    [self.navigationController showViewController:recommendVC sender:self];
}
#pragma mark--- MainRouteView代理方法
- (void)showRouteViewControllerWithRow:(NSInteger)row
{
    RouteViewController *routeVC = [[RouteViewController alloc] init];
    routeVC.row = row;
    [self.navigationController showViewController:routeVC sender:self];
}
- (void)showAddRouteViewController
{
    [self addRoute];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
