//
//  MainRouteTableCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MainRouteTableCell.h"
#import "MainFoundModel.h"
#import "Macros.h"
#import "DateHelper.h"
#import <UIImageView+WebCache.h>

@interface MainRouteTableCell ()

@property (nonatomic, strong) UIImageView *bgIamgeView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UIImageView *countImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation MainRouteTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgIamgeView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.bgIamgeView];
        self.userImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userImageView];
        self.countImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.countImageView];
        self.dateLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.dateLabel];
        self.nameLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLable];
        self.countLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.countLabel];
        self.descLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.descLabel];
    }
    return self;
}
- (void)setModel:(MainFoundModel *)model
{
    _model = model;
    [self.bgIamgeView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.usericon]];
    if ([model.format_date isEqualToString:@""]) {
        self.dateLabel.text = [NSString stringWithFormat:@"·  暂无出发日期  ·  %@天  ·", model.total_day];
    } else {
        self.dateLabel.text = [NSString stringWithFormat:@"·  %@出发  ·  %@天  ·", [[DateHelper sharedDateHelper] getDateStringWithDateString:model.format_date], model.total_day];
    }
    self.nameLable.text = model.planner_name;
    self.nameLable.numberOfLines = 0;
    [self.nameLable sizeToFit];
    self.countImageView.image = [UIImage imageNamed:@"iconfont-chakan"];
    self.countLabel.text = [NSString stringWithFormat:@"%ld", model.viewcount];
    self.descLabel.text = model.info_desc_string;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.bgIamgeView.frame = CGRectMake(0, 0, kVwidth, kVwidth / 1.6);
    
    self.dateLabel.frame  = CGRectMake(0, kVwidth / 7, kVwidth, 20);
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.font = [UIFont systemFontOfSize:13];
    
    self.nameLable.frame = CGRectMake(80, CGRectGetMaxY(self.dateLabel.frame), kVwidth - 160, 80);
    self.nameLable.layer.borderWidth = 2;
    self.nameLable.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nameLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.nameLable.textColor = [UIColor whiteColor];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    
    self.userImageView.frame = CGRectMake(kVwidth / 2 - 16, CGRectGetMaxY(self.nameLable.frame) + 10, 32, 32);
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 16;
    
    self.countImageView.frame = CGRectMake(CGRectGetMaxX(self.bgIamgeView.frame) - 65, CGRectGetMaxY(self.bgIamgeView.frame) - 30, 20, 20);
    
    self.countLabel.frame = CGRectMake(CGRectGetMaxX(self.countImageView.frame) + 5, CGRectGetMinY(self.countImageView.frame), kVwidth - CGRectGetMinX(self.countLabel.frame), 20);
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.font = [UIFont systemFontOfSize:13];
    
    self.descLabel.frame = CGRectMake(20, CGRectGetMaxY(self.bgIamgeView.frame), kVwidth - 40, KVheight - CGRectGetHeight(self.bgIamgeView.frame));
    self.descLabel.textColor = [UIColor blackColor];
    self.descLabel.font = [UIFont systemFontOfSize:15];
    self.descLabel.numberOfLines = 0;
}

@end
