//
//  MapViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/19.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MapViewController.h"
#import "MapHelper.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#define kSpan 0.01

@interface MapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKMapView *mapView; // 地图
@property (nonatomic, strong) BMKPointAnnotation *annotation; // 标注
@property (nonatomic, strong) BMKLocationService *locService; // 获取当前位置
@property (nonatomic, assign) CGFloat latitude;  // 纬度
@property (nonatomic, assign) CGFloat longitude; // 经度
@property (nonatomic, copy) NSString *annoTitle;   // 标注标题
@property (nonatomic, copy) NSString *subTitle;    // 子标题

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBar)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-icondingweizuobiao"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedRightBar)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.mapView];
    
    self.locService = [[BMKLocationService alloc] init];
}
- (void)setLatitude:(CGFloat)laititude Longitude:(CGFloat)longitude Title:(NSString *)title subTitle:(NSString *)subTitle
{
    self.latitude = laititude;
    self.longitude = longitude;
    self.annoTitle = title;
    self.subTitle = subTitle;
    self.navigationItem.title = title;
}
#pragma mark--- navigationBar点击方法
// pop回上个VC
- (void)didClickedLeftBar
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 显示用户当前位置
- (void)didClickedRightBar
{
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;  //先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow; //设置定位的状态，跟随状态
    _mapView.showsUserLocation = YES; //显示定位图层
}
#pragma mark--- 
// 页面将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    
    // 默认地图中心
    BMKCoordinateRegion region;
    if (self.latitude != 0 && self.longitude != 0) {
        //
        region.center.latitude = self.latitude;
        region.center.longitude = self.longitude;
    } else {
        // 获取当前位置，并显示在地图上
        region.center.latitude = [[MapHelper sharedMapHelper] getLatitudeWithCurrentPosition];
        region.center.longitude = [[MapHelper sharedMapHelper] getLongitudeWithCurrentPosition];
    }
    // 设置经纬度范围
    region.span.latitudeDelta = kSpan;
    region.span.longitudeDelta = kSpan;
    self.mapView.region = region;
}
// 页面将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
#pragma mark--- 地图标注
// 页面已经出现
- (void)viewDidAppear:(BOOL)animated
{
    // 在这里定义并添加标注
    if (self.latitude !=0 && self.longitude != 0) {
        self.annotation = [[BMKPointAnnotation alloc] init];
        CLLocationCoordinate2D coor;
        coor.latitude = self.latitude;
        coor.longitude = self.longitude;
        self.annotation.coordinate = coor;
        if (![self.annoTitle isEqualToString:@""] || self.annoTitle == nil) {
            self.annotation.title = self.annoTitle;
        }
        if (![self.subTitle isEqualToString:@""] || self.subTitle == nil) {
            self.annotation.subtitle = self.subTitle;
        }
        [self.mapView addAnnotation:self.annotation];
        // 默认显示title
        [self.mapView selectAnnotation:self.annotation animated:YES];
    }
}
// 代理方法，生成标注
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
// 删除标注
- (void)deleteAnnotationBar
{
    if (self.annotation != nil) {
        [self.mapView removeAnnotation:self.annotation];
    }
}

#pragma mark--- 
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
//    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
//    NSLog(@"location error------%@",error);
}


- (void)dealloc
{
    if (_mapView) {
        _mapView = nil;
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
