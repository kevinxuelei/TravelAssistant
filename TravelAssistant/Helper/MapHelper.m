//
//  MapHelper.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MapHelper.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface MapHelper ()

@property (nonatomic, strong) BMKLocationService *locService;

@end

@implementation MapHelper

#pragma mark--- 获取单例
+ (MapHelper *)sharedMapHelper
{
    static MapHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MapHelper alloc] init];
    });
    return helper;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locService = [[BMKLocationService alloc] init];
        // 开始定位
        [self.locService startUserLocationService];
    }
    return self;
}
#pragma mark--- 获取当前所在城市纬度
- (CGFloat)getLatitudeWithCurrentPosition
{
    // 打印当前经纬度
//    NSLog(@"%f, %f", _locService.userLocation.location.coordinate.latitude, _locService.userLocation.location.coordinate.longitude);
    return _locService.userLocation.location.coordinate.latitude;
}
#pragma mark--- 获取当前所在城市经度
- (CGFloat)getLongitudeWithCurrentPosition
{
    return _locService.userLocation.location.coordinate.longitude;
}

#pragma mark--- 获取当前所在城市
- (NSString *)getCityNow
{
//    CLGeocoder *geodoer = [[CL    Geocoder alloc]init];
//    [geodoer reverseGeocodeLocation:_locService.userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        for (CLPlacemark *place in placemarks) {
//            NSLog(@"%@",place.addressDictionary);
//        }
//    }];
    return nil;
}
#pragma mark---
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error------%@",error);
}

@end
