//
//  UserInfoModel.h
//  TravelAssistant
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic,copy) NSString *planner_name; // 行程名
@property (nonatomic,copy) NSString *usericon; // 用户头像地址
@property (nonatomic,copy) NSString *format_date; // 出发时间
@property (nonatomic, copy) NSString *img;          // 图片地址


@end
