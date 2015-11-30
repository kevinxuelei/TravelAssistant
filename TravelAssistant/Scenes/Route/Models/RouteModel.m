//
//  RouteModel.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "RouteModel.h"
#import "RouteCityModel.h"
#import "RoutePoiModel.h"
#import "DailyPoiModel.h"

@implementation RouteModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"city_array"]) {
        NSArray *arr = value;
        for (NSDictionary *dic in arr) {
            RouteCityModel *model = [[RouteCityModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_citysArray addObject:model];
        }
    } else if ([key isEqualToString:@"poi_array"]) {
        NSArray *arr = value;
        for (NSDictionary *dic in arr) {
            DailyPoiModel *model = [[DailyPoiModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_poisArray addObject:model];
        }
    }
    
    // 原app数据
//    if ([key isEqualToString:@"id"]) {
//        _oneday_id = value;
//    } else if ([key isEqualToString:@"event_list"]) {
//        if (![value isEqual:@""]) {  // 数据中的坑点，有值为字典，无值为字符串
//            NSDictionary *d1 = value;
//            NSArray *a1 = d1[@"poi_detail"];
//            for (NSDictionary *dic in a1) {
//                RoutePoiModel *model = [[RoutePoiModel alloc] init];
//                [model setValuesForKeysWithDictionary:dic];
//                [_poisArray addObject:model];
//            }
//        }
//    } else if ([key isEqualToString:@"citys"]) {
//        NSArray *a2 = value;
//        for (NSDictionary *dic in a2) {
//            RouteCityModel *model = [[RouteCityModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_citysArray addObject:model];
//        }
//    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _citysArray = [NSMutableArray array];
        _poisArray = [NSMutableArray array];
    }
    return self;
}

@end
