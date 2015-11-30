//
//  TrafficDetailCell.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DailyTrafficModel;

@protocol  TrafficDetailCellDelegate <NSObject>

- (void)dateChangeWithHour:(NSInteger)hour Minute:(NSInteger)minute WithRow:(NSInteger)row;
- (void)messageChangeWithString:(NSString *)string WithRow:(NSInteger)row;

@end

@interface TrafficDetailCell : UITableViewCell

@property (nonatomic, strong) DailyTrafficModel *model;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) id<TrafficDetailCellDelegate> deleagate;


@end
