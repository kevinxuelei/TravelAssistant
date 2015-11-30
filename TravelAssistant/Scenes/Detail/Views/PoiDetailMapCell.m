//
//  PoiDetailMapCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "PoiDetailMapCell.h"
#import "DailyPoiModel.h"
#import "MapHelper.h"
#import "Macros.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#define kSpan 0.01

@interface PoiDetailMapCell ()<BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKPointAnnotation *annotation;
@property (nonatomic, strong) UIView *view;

@end

@implementation PoiDetailMapCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.mapView = [[BMKMapView alloc] init];
        [self.contentView addSubview:self.mapView];
        self.annotation = [[BMKPointAnnotation alloc] init];
        self.view = [[UIView alloc] init];
        [self.contentView addSubview:self.view];
    }
    return self;
}
- (void)setModel:(DailyPoiModel *)model
{
    _model = model;
    self.mapView.delegate = self;
    // 默认地图中心
    BMKCoordinateRegion region;
    if (model.lat != 0 && model.lng != 0) {
        // 显示景点位置
        region.center.latitude = model.lat;
        region.center.longitude = model.lng;
    } else {
        // 获取当前位置，并显示在地图上
        region.center.latitude = [[MapHelper sharedMapHelper] getLatitudeWithCurrentPosition];
        region.center.longitude = [[MapHelper sharedMapHelper] getLongitudeWithCurrentPosition];
    }
    // 设置经纬度范围
    region.span.latitudeDelta = kSpan;
    region.span.longitudeDelta = kSpan;
    self.mapView.region = region;
    
    // 在这里定义并添加标注
    if (model.lat !=0 && model.lng != 0) {
        CLLocationCoordinate2D coor;
        coor.latitude = model.lat;
        coor.longitude = model.lng;
        self.annotation.coordinate = coor;
        [self.mapView addAnnotation:self.annotation];
    }

}
// 代理方法，生成标注
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        return newAnnotationView;
    }
    return nil;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.mapView.frame = CGRectMake(0, 0, kVwidth, KVheight);
    
    self.view.frame = CGRectMake(0, 0, kVwidth, KVheight);
}
//- (void)dealloc
//{
//    if (_mapView) {
//        _mapView = nil;
//    }
//}



@end
