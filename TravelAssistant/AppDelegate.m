//
//  AppDelegate.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Macros.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UMSocial.h"

@interface AppDelegate ()<BMKGeneralDelegate>

@property (nonatomic, strong) UIScrollView *introduceView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //链接云服务器
    [AVOSCloud setApplicationId:@"pPjJP5Mo7jON9Fc8VRmf0z1a" clientKey:@"mR9L9hzO7jpiVEdKbMtItAC1"];
    
    //设置友盟AppKey
    [UMSocialData setAppKey:@"5652dfaa67e58e025400038a"];
    
    // 开启百度地图
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"YZ1loQeMh1Dmh8bixgRS7WGZ" generalDelegate:self];
    if (!ret) {
//        NSLog(@"百度地图开启失败！！！");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    MainViewController *mainVC = [[MainViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navi;

    [self onlyOneAddIntroduceView];
    return YES;
}
#pragma mark--- BMKGeneralDelegate
/**
 *返回网络错误(Bundle identifier)
 *@param iError 错误号 : 为0时验证通过
 */
- (void)onGetNetworkState:(int)iError
{
//    NSLog(@"%d", iError);
}
/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError
{
//    NSLog(@"%d", iError);
}

// 添加引导页
#pragma mark - 引导页只执行一次
- (void)onlyOneAddIntroduceView{
    
    //  读取沙盒数据
    NSUserDefaults *settings1 = [NSUserDefaults standardUserDefaults];
    NSString *key1 = @"is_first";
    NSString *value = [settings1 objectForKey:key1];
    //  如果没有数据
    if (!value)
    {
        //  加入引导页
        [self addIntroduceView];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        //  写入数据
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        NSString * key = @"is_first";
        [setting setObject:[NSString stringWithFormat:@"false"] forKey:key];
        [setting synchronize];
    }
}

#pragma mark - 添加引导页效果
- (void)addIntroduceView {
    
    _introduceView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _introduceView.showsHorizontalScrollIndicator = NO;//滚动条
    _introduceView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    _introduceView.pagingEnabled = YES;
    _introduceView.bounces = NO;
    [self.window addSubview:_introduceView];
    
    _firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _firstImageView.image = [UIImage imageNamed:@"1"];
    [_introduceView addSubview:_firstImageView];
    
    _secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight)];
    _secondImageView.image = [UIImage imageNamed:@"2"];

    [_introduceView addSubview:_secondImageView];
    
    _thirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight)];
    _thirdImageView.image = [UIImage imageNamed:@"3"];
    _thirdImageView.userInteractionEnabled = YES;
    [_introduceView addSubview:_thirdImageView];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [_thirdImageView addGestureRecognizer:tapGestureRecognizer];
    
    
}

// 最后一页，点击图片进入app
- (void)gestureRecognizerHandle:(UITapGestureRecognizer *)gesture{
    
    [UIView animateWithDuration:0.5 animations:^{
        _thirdImageView.alpha = 1;
        _thirdImageView.transform = CGAffineTransformScale(_thirdImageView.transform, 0, 0);
    } completion:^(BOOL finished) {
        [_introduceView removeFromSuperview];
    }];
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
