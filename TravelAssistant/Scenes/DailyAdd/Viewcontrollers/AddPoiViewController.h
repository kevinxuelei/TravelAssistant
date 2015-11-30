//
//  AddPoiViewController.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/27.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DailyPoiModel;

typedef void(^AddPoiViewControllerBlock)(NSMutableArray *);

@interface AddPoiViewController : UIViewController

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, copy) AddPoiViewControllerBlock block;

@end
