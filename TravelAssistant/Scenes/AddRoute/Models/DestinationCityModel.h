//
//  DestinationCityModel.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/23.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DestinationCityModel : NSObject

@property (nonatomic, assign) NSInteger cityId; // 城市id
@property (nonatomic, assign) CGFloat lat;      // 城市纬度
@property (nonatomic, assign) CGFloat lng;      // 城市经度
@property (nonatomic, copy) NSString *cn_name;  // 城市中文名
@property (nonatomic, copy) NSString *en_name;  // 城市英文名
@property (nonatomic, copy) NSString *memo;     // 去过的人数，及推荐次数
@property (nonatomic, copy) NSString *pic_nor;      // 城市头像
@property (nonatomic, copy) NSString *pic_max;  // w1080头像，用来显示在首页
@property (nonatomic, assign) NSInteger recommend_days; // 推荐游玩天数

@property (nonatomic, strong) NSDate *start_time; // 到达时间
@property (nonatomic, strong) NSDate *end_time;   // 离开时间

@end
