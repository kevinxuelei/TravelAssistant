//
//  NSDate+StringToDate.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/13.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "NSDate+StringToDate.h"

@implementation NSDate (StringToDate)

+ (NSDate *)dateWithDateString:(NSString *)str{
    NSDate *nd = [[NSDate alloc] init];
    NSDateFormatter *ndf = [[NSDateFormatter alloc] init];
    [ndf setDateFormat:@"yyyy-MM-dd"];
    nd = [ndf dateFromString:str];
    return nd;
}

@end
