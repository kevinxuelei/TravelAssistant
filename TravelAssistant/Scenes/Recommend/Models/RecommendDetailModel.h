//
//  RecommendDetailModel.h
//  TravelAssistant
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelsModel.h"
#import "ScenicModel.h"
#import "TrafficsModel.h"
#import "CityModel.h"

@interface RecommendDetailModel : NSObject

@property (nonatomic, assign)NSInteger plan_id;
@property (nonatomic, assign)NSInteger start_time; // 开始时间编号
@property (nonatomic, assign)NSInteger end_time; // 结束时间编号

@property (nonatomic,copy) NSString *planner_name; // 行程名字
@property (nonatomic,copy) NSString *format_start_date; // 开始时间
@property (nonatomic,copy) NSString *format_end_date; // 结束时间

@property (nonatomic, assign)NSInteger ID;
@property (nonatomic, assign)NSInteger day; // 行程的第几天
@property (nonatomic, assign)NSInteger time; // 开始
@property (nonatomic, assign)NSInteger format_date; // 出发日期

@property (nonatomic, assign)NSInteger texts_id;
@property (nonatomic,copy) NSString *massage; // 笔记详情

@property (nonatomic, strong) NSMutableArray *hotels;
@property (nonatomic, strong) NSMutableArray *scenics;
@property (nonatomic, strong) NSMutableArray *traffics;
@property (nonatomic, strong) NSMutableArray *citys;
































@end
