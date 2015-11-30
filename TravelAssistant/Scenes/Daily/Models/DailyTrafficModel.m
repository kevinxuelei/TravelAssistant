//
//  DailyTrafficModel.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DailyTrafficModel.h"

@implementation DailyTrafficModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _trafficId = value;
    }
}

@end
