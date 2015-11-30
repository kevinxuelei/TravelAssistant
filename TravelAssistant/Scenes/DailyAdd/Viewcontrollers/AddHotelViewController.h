//
//  AddHotelViewController.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/27.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddHotelViewControllerBlock)(NSMutableArray *);

@interface AddHotelViewController : UIViewController

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, copy) AddHotelViewControllerBlock block;

@end
