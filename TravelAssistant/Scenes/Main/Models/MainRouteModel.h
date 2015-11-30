//
//  MainRouteModel.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/13.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainRouteModel : NSObject

@property (nonatomic, copy) NSString *routeId;      // 行程的唯一标识
@property (nonatomic, copy) NSString *planner_name; // 行程名称
@property (nonatomic, copy) NSString *start_time;   // 行程开始日期
@property (nonatomic, copy) NSString *end_time;     // 行程结束日期
@property (nonatomic, copy) NSString *start_time_format; // 出发日期
@property (nonatomic, copy) NSString *total_day;    // 行程持续天数
@property (nonatomic, copy) NSString *cover;        // 背景图片
@property (nonatomic, copy) NSString *ctime;        // 创建时间
@property (nonatomic, assign) NSInteger utime;        // 更新时间

@property (nonatomic, copy) NSString *objectId;     // 行程唯一id
@property (nonatomic, strong) NSArray *route_array;     // 存放该城市要去的景点

@end
