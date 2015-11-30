//
//  DateViewController.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/21.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DateViewControllerBlock)();

@interface DateViewController : UIViewController

@property (nonatomic, copy) DateViewControllerBlock block;

@end
