//
//  DailyHotelModel.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DailyHotelModel : NSObject

@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, copy) NSString *en_name; // 英文名
@property (nonatomic, copy) NSString *cn_name; // 中文名
@property (nonatomic, copy) NSString *price;   // 价格
@property (nonatomic, copy) NSString *address; // 地址
@property (nonatomic, assign) NSInteger star;  // 星级
@property (nonatomic, assign) NSInteger grade; // 评价
@property (nonatomic, assign) NSInteger thread_num; // 提及的游记
@property (nonatomic, assign) NSInteger plan_num;   // 提及的行程
@property (nonatomic, copy) NSString *descriptionHotel; // 简介
@property (nonatomic, copy) NSString *facility_name;    // 酒店设备
@property (nonatomic, copy) NSString *recommend_reason; // 推荐理由
@property (nonatomic, copy) NSString *pics;              // 头像地址
@property (nonatomic, strong) NSMutableArray *piclistArr;  // 轮播图地址
@property (nonatomic, copy) NSString *area_name; // 地区名

@property (nonatomic, assign) CGFloat latitude;  // 纬度
@property (nonatomic, assign) CGFloat longitude; // 经度

@end
