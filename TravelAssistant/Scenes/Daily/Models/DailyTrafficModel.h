//
//  DailyTrafficModel.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyTrafficModel : NSObject

@property (nonatomic, copy) NSString *trafficId;      // 交通id

@property (nonatomic, assign) NSInteger starthours;   // 出发时间(时)
@property (nonatomic, assign) NSInteger startminutes; // 出发时间(分)
@property (nonatomic, assign) NSInteger endhours;     // 到达时间(时)
@property (nonatomic, assign) NSInteger endminutes;   // 到达时间(分)

@property (nonatomic, copy) NSString *fromplace;      // 出发城市
@property (nonatomic, copy) NSString *toplace;        // 到达城市
@property (nonatomic, copy) NSString *traffic_number; // 班次/航班

@end
