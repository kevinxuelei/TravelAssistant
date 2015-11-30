//
//  SelectedCityCell.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/24.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DestinationCityModel;

typedef void(^SelectedCityCellBlock)(NSInteger);

@interface SelectedCityCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, strong) DestinationCityModel *model;

@property (nonatomic, copy) SelectedCityCellBlock block;

@end
