//
//  RouteCityModel.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RouteCityModel : NSObject

@property (nonatomic, copy) NSString *name;  // 城市名
@property (nonatomic, assign) CGFloat lat;   // 城市纬度
@property (nonatomic, assign) CGFloat lng;   // 城市经度
@property (nonatomic, copy) NSString *pic;   // 城市图片
@property (nonatomic, assign) NSInteger type; //
@property (nonatomic, assign) NSInteger tagid; // 城市id
@property (nonatomic, strong) NSArray *poi_array; // 游玩景点


@end
