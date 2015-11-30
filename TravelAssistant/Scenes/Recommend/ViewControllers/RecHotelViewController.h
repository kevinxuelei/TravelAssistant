//
//  RecHotelViewController.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/20.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecHotelViewController : UIViewController

@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, assign) NSInteger hotelId;  // 酒店id，传值过来加载数据

@end
