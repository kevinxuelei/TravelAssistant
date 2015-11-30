//
//  RouteCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "RouteCell.h"
#import "RouteModel.h"
#import "RoutePoiModel.h"
#import "RouteCityModel.h"
#import "DateHelper.h"
#import "Macros.h"
#import "DailyPoiModel.h"

@interface RouteCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *poiLabel;

@end

@implementation RouteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dateLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.dateLabel];
        self.cityLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.cityLabel];
        self.poiLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.poiLabel];
    }
    return self;
}
- (void)setModel:(RouteModel *)model
{
    self.dateLabel.text = [[DateHelper sharedDateHelper] getDayStringFromTimeIntervalString:self.start_timel Num:self.row];
    
    NSMutableArray *cityArray = model.citysArray;
    NSMutableArray *cityArr = [NSMutableArray array];
    for (RouteCityModel *model in cityArray) {
        [cityArr addObject:model.name];
    }
    self.cityLabel.text = [cityArr componentsJoinedByString:@" > "];
    
    NSMutableArray *poiArray = model.poisArray;
    NSMutableArray *poiArr = [NSMutableArray array];
//    for (RoutePoiModel *model in poiArray) {
//        [poiArr addObject:model.poi_title];
//    }
//    self.poiLabel.text = [poiArr componentsJoinedByString:@">"];
    for (DailyPoiModel *model in poiArray) {
        [poiArr addObject:model.cn_name];
    }
    self.poiLabel.text = [poiArr componentsJoinedByString:@">"];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.dateLabel.frame = CGRectMake(KVheight / 4, KVheight / 4, KVheight / 2, KVheight / 2);
    self.dateLabel.layer.masksToBounds = YES;
    self.dateLabel.layer.cornerRadius = self.dateLabel.frame.size.width / 2;
    self.dateLabel.backgroundColor = [UIColor orangeColor];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont systemFontOfSize:20];
    
    self.cityLabel.frame = CGRectMake(KVheight, KVheight / 4, kVwidth - KVheight - 20, KVheight / 4);
    self.cityLabel.font = [UIFont systemFontOfSize:15];
    
    self.poiLabel.frame = CGRectMake(KVheight, CGRectGetMaxY(self.cityLabel.frame) + 3, CGRectGetWidth(self.cityLabel.frame), KVheight / 4);
    self.poiLabel.textColor = [UIColor lightGrayColor];
    self.poiLabel.font = [UIFont systemFontOfSize:12];
}

@end
