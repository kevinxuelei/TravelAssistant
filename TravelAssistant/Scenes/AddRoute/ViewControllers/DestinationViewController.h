//
//  DestinationViewController.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/21.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DestinationViewControllerBlock)();

@interface DestinationViewController : UIViewController

@property (nonatomic, strong) NSDate *date; // 选择的出发日期

@property (nonatomic, copy) NSString *userId; // 用户id

@property (nonatomic, copy) DestinationViewControllerBlock block;

@end
