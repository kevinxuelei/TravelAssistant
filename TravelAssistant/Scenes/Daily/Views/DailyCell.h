//
//  DailyCell.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DailyPoiModel;

@interface DailyCell : UITableViewCell

@property (nonatomic, assign) NSInteger rank;

@property (nonatomic, strong) DailyPoiModel *model;

@end
