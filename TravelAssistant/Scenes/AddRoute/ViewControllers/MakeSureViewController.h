//
//  MakeSureViewController.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/21.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MakeSureViewControllerBlock)();

@interface MakeSureViewController : UIViewController

@property (nonatomic, strong) NSDate *date; // 选择的出发日期

@property (nonatomic, copy) NSString *userId; // 用户id

@property (nonatomic, strong) NSMutableArray *cityArray;

@property (nonatomic, copy) MakeSureViewControllerBlock block;

@end
