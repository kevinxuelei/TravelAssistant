//
//  DailyViewController.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainRouteModel;

typedef void(^DailyViewControllerBlock)();

@interface DailyViewController : UIViewController

@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) DailyViewControllerBlock block;

@end
