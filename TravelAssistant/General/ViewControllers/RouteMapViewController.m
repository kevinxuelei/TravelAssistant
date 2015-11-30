//
//  RouteMapViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/20.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "RouteMapViewController.h"
#import "MapHelper.h"
#import "RouteCityModel.h"
#import "DailyPoiModel.h"
#import <MBProgressHUD.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface RouteMapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) NSMutableArray *annoArray; // 存放所有标注
@property (nonatomic, assign) CGFloat maxLat;
@property (nonatomic, assign) CGFloat maxLng;
@property (nonatomic, assign) CGFloat minLat;
@property (nonatomic, assign) CGFloat minLng;

@end

@implementation RouteMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBar)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-icondingweizuobiao"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedRightBar)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.title = @"行程地图";
    self.minLat = 1000;
    self.minLng = 1000;
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.mapView];
    
    self.locService = [[BMKLocationService alloc] init];
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
    _mapView.userTrackingMode = BMKUserTrackingModeFollow; //设置定位的状态，普通状态
    _mapView.showsUserLocation = YES; //显示定位图层
}
#pragma mark--- 重写setter方法
- (void)setArray:(NSMutableArray *)array
{
    _array = array;
    // 显示菊花
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor lightGrayColor];
    self.hud.delegate = self;
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    
    // 在这里定义标注
    self.annoArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        CLLocationCoordinate2D coor;
        coor.latitude = [array[i] lat];
        coor.longitude = [array[i] lng];
        annotation.coordinate = coor;
        [self.annoArray addObject:annotation];
    }
    [self.mapView addAnnotations:self.annoArray];
    
    
    if (array.count > 1) {
        for (int i = 0; i < array.count - 1; i ++) {
            // 折线
            CLLocationCoordinate2D coords[2] = {0};
            coords[0].latitude = [array[i] lat];
            coords[0].longitude = [array[i] lng];
            coords[1].latitude = [array[i+1] lat];
            coords[1].longitude = [array[i+1] lng];
            //构建分段颜色索引数组
            NSArray *colorIndexs = [NSArray arrayWithObjects:
                                    [NSNumber numberWithInt:0],
                                    [NSNumber numberWithInt:0], nil];
            
            //构建BMKPolyline,使用分段颜色索引，其对应的BMKPolylineView必须设置colors属性
            BMKPolyline *colorfulPolyline = [BMKPolyline polylineWithCoordinates:coords count:2 textureIndex:colorIndexs];
            [_mapView addOverlay:colorfulPolyline];
        }
    }
    
    // 获取经纬度最大值
    for (int i = 0; i < array.count; i++) {
        self.maxLat = self.maxLat > [array[i] lat] ? self.maxLat : [array[i] lat];
        self.maxLng = self.maxLng > [array[i] lng] ? self.maxLng : [array[i] lng];
        self.minLat = self.minLat < [array[i] lat] ? self.minLat : [array[i] lat];
        self.minLng = self.minLng < [array[i] lng] ? self.minLng : [array[i] lng];
    }
//    NSLog(@"maxlat===%f   maxlng===%f\nminlat===%f   minlng===%f", self.maxLat,self.maxLng,self.minLat,self.minLng);
    // 默认地图中心
    BMKCoordinateRegion region;
    region.center.latitude = (self.maxLat + self.minLat) / 2;
    region.center.longitude = (self.maxLng + self.minLng) / 2;
    // 设置经纬度范围
    region.span.latitudeDelta = (self.maxLat - self.minLat) * 1.4;
    region.span.longitudeDelta = (self.maxLng - self.minLng) * 1.3;
    self.mapView.region = region;
    
    [self hudWasHidden:self.hud];
}
- (void)setCityArray:(NSArray *)cityArray
{
    _cityArray = cityArray;

}
#pragma mark---
// 页面将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
#pragma mark--- 地图标注
// 代理方法，生成标注
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
// 删除标注
- (void)deleteAnnotationBar
{
        [self.mapView removeAnnotations:self.annoArray]; // 移除一组标注
}
#pragma mark--- 根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.lineWidth = 5;
        /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
        polylineView.colors = @[[UIColor redColor]];
        return polylineView;
    }
    
    return nil;
}


#pragma mark--- BMKLocationServiceDelegate
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
#pragma mark--- MBPrograssHUD代理协议
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
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
