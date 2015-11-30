//
//  HotelDetailNormalCell.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/18.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DailyHotelModel;

@interface HotelDetailNormalCell : UITableViewCell

@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, strong) DailyHotelModel *model;

@end
