//
//  DestinationCityModel.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/23.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DestinationCityModel.h"

@implementation DestinationCityModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _cityId = [value integerValue];
    } else if ([key isEqualToString:@"pic"]) {
        _pic_nor = value;
        
        NSInteger length = _pic_nor.length; // 获取字符串长度
        if (_pic_nor.length == 0) {
            return;
        }
        NSRange range = NSMakeRange(0, length - 7);
        NSString *string = [_pic_nor substringWithRange:range];
        // 获取大图，用来显示在首页
        _pic_max = [NSString stringWithFormat:@"%@w1080", string];
//        NSLog(@"%@", _pic_max);
    }
}

@end
