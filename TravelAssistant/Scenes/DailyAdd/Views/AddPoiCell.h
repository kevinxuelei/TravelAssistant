//
//  AddPoiCell.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/27.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DailyPoiModel;

@protocol AddPoiCellDelegate <NSObject>

- (void)showMBPrograssHUD;

- (void)addPoiModelWithModel:(DailyPoiModel *)model;

- (void)deletePoiModelWithModel:(DailyPoiModel *)model;

@end


@interface AddPoiCell : UITableViewCell

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, assign) BOOL is_Selected;

@property (nonatomic, strong) DailyPoiModel *model;

@property (nonatomic, assign) id<AddPoiCellDelegate> delegate;

@end
