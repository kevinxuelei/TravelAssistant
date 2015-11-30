//
//  TrafficsModel.h
//  TravelAssistant
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrafficsModel : NSObject

@property (nonatomic, assign)NSInteger trafficid;
@property (nonatomic,copy) NSString *fromplace; // 出发地
@property (nonatomic, assign)NSInteger fromplaceid; // 出发地id
@property (nonatomic,copy) NSString *toplace; // 目的地
@property (nonatomic, assign)NSInteger toplaceid; // 目的地id
@property (nonatomic, assign)NSInteger tripmode; // 交通方式
@property (nonatomic,copy) NSString *traffic_number; // 班次/航号
@property (nonatomic, assign)NSInteger starthours; // 小时
@property (nonatomic, assign)NSInteger startminutes; // 分钟
@property (nonatomic, assign)NSInteger endhours; // 小时
@property (nonatomic, assign)NSInteger endminutes; // 分钟
@property (nonatomic, assign)NSInteger price; // 花费
@property (nonatomic,copy) NSString *currency; // 币种
@property (nonatomic, assign)NSInteger counts; // 行程顺序

+ (instancetype)TrafficsModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;


@end
