//
//  RouteCell.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RouteModel;


@interface RouteCell : UITableViewCell

@property (nonatomic, assign) NSInteger row;       // 行程中的第几天
@property (nonatomic, copy) NSString *start_timel; // 行程开始时间
@property (nonatomic, strong) RouteModel *model;


@end
