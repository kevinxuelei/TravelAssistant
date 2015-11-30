//
//  MakeTrafficCell.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/24.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DestinationCityModel;

@interface MakeTrafficCell : UITableViewCell

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) DestinationCityModel *model;

@end
