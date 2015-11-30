//
//  FDCalendar.h
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

// 获取所选择日期(NSDate *)，使用时需+8小时
typedef void(^FDCalendarBlock)(NSDate *);

@interface FDCalendar : UIView

@property (nonatomic, copy) FDCalendarBlock block;

- (instancetype)initWithCurrentDate:(NSDate *)date;

@end
