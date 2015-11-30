//
//  AddHotelCell.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/28.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DailyHotelModel;

@protocol AddHotelCellDelegate <NSObject>

- (void)showMBPrograssHUD;

- (void)addHotelModelWithModel:(DailyHotelModel *)model;

- (void)deleteHotelModelWithModel:(DailyHotelModel *)model;

@end

@interface AddHotelCell : UITableViewCell

@property (nonatomic, strong) DailyHotelModel *model;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) BOOL is_Selected;

@property (nonatomic, assign) id<AddHotelCellDelegate> delegate;

@end
