//
//  MakeSureCell.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/24.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DestinationCityModel;

@protocol MakeSureCellDelegate <NSObject>
// 提示用户重新选择时间
- (void)showAlvert;

// 修改到达、离开时间
- (void)changeStartTimeWithNewTime:(NSDate *)date IndexPath:(NSIndexPath *)indexPath;
- (void)changeEndTimeWithNewTime:(NSDate *)date IndexPath:(NSIndexPath *)indexPath;

@end

@interface MakeSureCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) DestinationCityModel *model;

@property (nonatomic, assign) id<MakeSureCellDelegate> delegate;

@end
