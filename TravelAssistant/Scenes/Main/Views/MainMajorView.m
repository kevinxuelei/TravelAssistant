//
//  MainMajorView.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/13.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MainMajorView.h"
#import "Macros.h"
#import "DateHelper.h"
#import <UIImageView+WebCache.h>

#define kCellWidth self.cellSize.width
#define kCellHeight self.cellSize.height

@interface MainMajorView ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *total_dayLable;
@property (nonatomic, strong) UILabel *dayLable;
@property (nonatomic, strong) UILabel *planner_nameLabel;
@property (nonatomic, strong) UILabel *start_time_formatLabel;
@property (nonatomic, strong) UIView *verticalVIew;

@end

@implementation MainMajorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.coverImageView = [[UIImageView alloc] init];
        [self addSubview:self.coverImageView];
        self.total_dayLable = [[UILabel alloc] init];
        [self addSubview:self.total_dayLable];
        self.dayLable = [[UILabel alloc] init];
        [self addSubview:self.dayLable];
        self.planner_nameLabel = [[UILabel alloc] init];
        [self addSubview:self.planner_nameLabel];
        self.start_time_formatLabel = [[UILabel alloc] init];
        [self addSubview:self.start_time_formatLabel];
        self.verticalVIew = [[UIView alloc] init];
        [self addSubview:self.verticalVIew];
    }
    return self;
}
- (void)setModel:(MainRouteModel *)model
{
    _model = model;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.total_dayLable.text = [NSString stringWithFormat:@"%.2ld", [model.total_day integerValue] + 1];
    self.dayLable.text = @"天";
    self.planner_nameLabel.text = model.planner_name;
    NSString *start_time_formatString = [NSString stringWithFormat:@"%@出发", [[DateHelper sharedDateHelper] getDateStringWithDateString:model.start_time_format]];
    if ([model.start_time_format isEqualToString:@""]) {
        start_time_formatString = @"无出发日期";
    }
    self.start_time_formatLabel.text = start_time_formatString;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.coverImageView.frame = CGRectMake(0, 0, kCellWidth, kCellHeight);
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    
    self.total_dayLable.frame  =CGRectMake(0, kCellHeight - kCellWidth / 4, kCellWidth / 4, kCellWidth / 4);
    self.total_dayLable.textColor = [UIColor whiteColor];
    self.total_dayLable.font = [UIFont fontWithName:@"Arial Unicode MS" size:30];
    self.total_dayLable.textAlignment = NSTextAlignmentRight;
    
    self.dayLable.frame = CGRectMake(CGRectGetMaxX(self.total_dayLable.frame), CGRectGetMaxY(self.total_dayLable.frame) - 30, 20, 20);
    self.dayLable.textColor = [UIColor whiteColor];
    self.dayLable.font = [UIFont systemFontOfSize:13];
    
    self.verticalVIew.frame = CGRectMake(CGRectGetMaxX(self.dayLable.frame), CGRectGetMinY(self.total_dayLable.frame) + 10, 1, kCellWidth / 4 - 20);
    self.verticalVIew.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    self.planner_nameLabel.frame = CGRectMake(CGRectGetMaxX(self.verticalVIew.frame) + 5, CGRectGetMinY(self.verticalVIew.frame), kCellWidth - CGRectGetMinX(self.verticalVIew.frame) - 20, CGRectGetHeight(self.verticalVIew.frame) / 2);
    self.planner_nameLabel.textColor = [UIColor whiteColor];
    self.planner_nameLabel.font = [UIFont systemFontOfSize:13];
    
    self.start_time_formatLabel.frame = CGRectMake(CGRectGetMinX(self.planner_nameLabel.frame), CGRectGetMaxY(self.planner_nameLabel.frame), CGRectGetWidth(self.planner_nameLabel.frame), CGRectGetHeight(self.verticalVIew.frame) / 2);
    self.start_time_formatLabel.textColor = [UIColor whiteColor];
    self.start_time_formatLabel.font = [UIFont systemFontOfSize:11];
    
}


@end