//
//  DateHelper.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DateHelper.h"
#import "NSDate+StringToDate.h"

@implementation DateHelper

#pragma mark--- 获取单例
+ (DateHelper *)sharedDateHelper
{
    static DateHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DateHelper alloc] init];
    });
    return helper;
}

#pragma mark--- 将“xxxx-xx-xx”的日期类型转换为“xxxx年xx月xx日”类型
- (NSString *)getDateStringWithDateString:(NSString *)string
{
    NSDate *date = [NSDate dateWithDateString:string];
    // 设置日期格式
    NSDateFormatter *nsd = [[NSDateFormatter alloc] init];
    // 设置日期格式为“xxxx年xx月xx日”
    [nsd setDateFormat:@"yyyy年MM月dd日"];
    return [nsd stringFromDate:date];
}

#pragma maek--- 根据TimeInterval，和这是行程中的第几天，获取“日”
- (NSString *)getDayStringFromTimeIntervalString:(NSString *)timeInterval Num:(NSInteger)num
{
    // 默认date是格林尼治时间，在东八区需要加上8*60*60秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInterval integerValue] + 8*60*60 + num*24*60*60];
    // 设置日期格式
    NSDateFormatter *nsd = [[NSDateFormatter alloc] init];
    // 只需要“日”
    [nsd setDateFormat:@"dd"];
    return [nsd stringFromDate:date];
}

#pragma mark--- 根据TimeInterval，获取评论发表时间，“xxxx-xx-xx  xx:xx”
- (NSString *)getCommentCreateDateWithTimeInterval:(NSInteger)timeInterval
{
    // 默认date是格林尼治时间，在东八区需要加上8*60*60秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval + 8*60*60];
    // 设置日期格式
    NSDateFormatter *nsd = [[NSDateFormatter alloc] init];
    [nsd setDateFormat:@"yyyy-MM-dd  HH:mm"];
    return [nsd stringFromDate:date];
}

#pragma mark--- 根据date，获取只有日期的准确date
- (NSDate *)dayDateWithDate:(NSDate *)date
{
    NSDate *nowDate = [date dateByAddingTimeInterval:8*60*60];
    NSDateFormatter *nsd = [[NSDateFormatter alloc] init];
    [nsd setDateFormat:@"yyyy-MM-dd"];
    NSString *nowString = [nsd stringFromDate:nowDate];
    // NSString转NSDate，还需要需要+8小时
    NSDate *dayDate = [[nsd dateFromString:nowString] dateByAddingTimeInterval:8*60*60];
    return dayDate;
}

#pragma mark--- 根据NSDate，获取日期“xxxx-xx-xx”
- (NSString *)timeWithDate:(NSDate *)date
{
    NSDateFormatter *nsd = [[NSDateFormatter alloc] init];
    [nsd setDateFormat:@"MM-dd"];
    NSString *string = [nsd stringFromDate:date];
    return string;
}
#pragma mark--- 根据NSDate，获取日期“xxxx-xx-xx”
- (NSString *)completeTimeWithDate:(NSDate *)date
{
    NSDateFormatter *nsd = [[NSDateFormatter alloc] init];
    [nsd setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [nsd stringFromDate:date];
    return string;
}

#pragma mark--- 根据两个TimeIntervier，获取时间差
- (NSString *)intervalFromStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime
{
    NSDate *d1 = [NSDate dateWithTimeIntervalSince1970:[startTime integerValue]];
    NSDate *d2 = [NSDate dateWithTimeIntervalSince1970:[endTime integerValue]];
    NSTimeInterval time  =[d2 timeIntervalSinceDate:d1];
    NSInteger ti = time / (24*60*60);
    return [NSString stringWithFormat:@"%ld", ti];
}

@end
