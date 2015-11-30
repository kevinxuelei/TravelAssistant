//
//  TrafficDetailViewController.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DailyTrafficModel;

typedef void(^DailyTrafficModelBlock)(DailyTrafficModel *);

@interface TrafficDetailViewController : UIViewController

@property (nonatomic, assign) BOOL is_Create;

@property (nonatomic, strong) DailyTrafficModel *model;

@property (nonatomic, copy) DailyTrafficModelBlock block;

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSDictionary *dictionary;

@end
