//
//  DailyHotelModel.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DailyHotelModel.h"

@implementation DailyHotelModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _pid = [value integerValue];
    } else if ([key isEqualToString:@"description"]) {
        _descriptionHotel = value;
    } else if ([key isEqualToString:@"pic"]) {
        _pics = value;
        [_piclistArr insertObject:value atIndex:0];
    } else if ([key isEqualToString:@"piclist"]) {
        [_piclistArr addObjectsFromArray:value];
    } else if ([key isEqualToString:@"price"]) {
        _price = [NSString stringWithFormat:@"%.2f", [value floatValue]];
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _piclistArr = [NSMutableArray array];
    }
    return self;
}

@end
