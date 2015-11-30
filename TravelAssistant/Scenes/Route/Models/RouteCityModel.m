//
//  RouteCityModel.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "RouteCityModel.h"

@implementation RouteCityModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"lat"]) {
        _lat = [value doubleValue];
    } else if ([key isEqualToString:@"lng"]) {
        _lng = [value doubleValue];
    } else if ([key isEqualToString:@"cityId"]) {
        _tagid = [value integerValue];
    } else if ([key isEqualToString:@"cn_name"]) {
        _name = value;
    } else if ([key isEqualToString:@"pic_max"]) {
        _pic = value;
    }
}


@end
