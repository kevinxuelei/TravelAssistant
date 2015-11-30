//
//  DestinationCityCell.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/23.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DestinationCityModel;

typedef void(^DestinationCityCellBlock)(DestinationCityModel *);

@interface DestinationCityCell : UITableViewCell

@property (nonatomic, strong) DestinationCityModel *model;

@property (nonatomic, copy) DestinationCityCellBlock block;

@end
