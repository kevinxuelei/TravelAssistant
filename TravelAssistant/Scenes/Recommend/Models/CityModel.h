//
//  CityModel.h
//  TravelAssistant
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject


// 城市信息
@property (nonatomic, assign)NSInteger tagid; // 城市编码号
@property (nonatomic,copy) NSString *name; // 城市名


+ (instancetype)citysModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
