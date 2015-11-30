//
//  MainRouteModel.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/13.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MainRouteModel.h"

@implementation MainRouteModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.routeId = value;
    } else if ([key isEqualToString:@"objectId"]) {
        _objectId = [NSString stringWithFormat:@"%@", value];
    }
}

@end
