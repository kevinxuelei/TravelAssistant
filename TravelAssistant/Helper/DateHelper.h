//
//  DateHelper.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

#pragma mark--- 获取单例
+ (DateHelper *)sharedDateHelper;

#pragma mark--- 将“xxxx-xx-xx”的日期类型转换为“xxxx年xx月xx日”类型
- (NSString *)getDateStringWithDateString:(NSString *)dateString;

#pragma maek--- 根据TimeInterval，和这是行程中的第几天，获取“日”
- (NSString *)getDayStringFromTimeIntervalString:(NSString *)timeInterval Num:(NSInteger)num;

#pragma mark--- 根据TimeInterval，获取评论发表时间，“xxxx-xx-xx  xx:xx”
- (NSString *)getCommentCreateDateWithTimeInterval:(NSInteger)timeInterval;

#pragma mark--- 根据date，获取只有日期的准确date
- (NSDate *)dayDateWithDate:(NSDate *)date;

#pragma mark--- 根据NSDate，获取日期“xx-xx”
- (NSString *)timeWithDate:(NSDate *)date;

#pragma mark--- 根据NSDate，获取日期“xxxx-xx-xx”
- (NSString *)completeTimeWithDate:(NSDate *)date;

#pragma mark--- 根据两个TimeIntervier，获取时间差
- (NSString *)intervalFromStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime;

@end
