//
//  HotelDetailReferCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/18.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "HotelDetailReferCell.h"
#import "DailyHotelModel.h"
#import "Macros.h"

@interface HotelDetailReferCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *starLabel;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation HotelDetailReferCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.starLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.starLabel];
        self.gradeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.gradeLabel];
        self.addressLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.addressLabel];
        self.numLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.numLabel];
    }
    return self;
}

- (void)setModel:(DailyHotelModel *)model
{
    self.titleLabel.text = @"参考评价";
    self.starLabel.text = [NSString stringWithFormat:@"星级: %ld星级", model.star];
    self.gradeLabel.text = [NSString stringWithFormat:@"评分: %ld分", model.grade];
    self.addressLabel.text = [NSString stringWithFormat:@"地址: %@", model.address];
    self.numLabel.text = [NSString stringWithFormat:@"热度: %ld篇游记，%ld个行程中提及", model.thread_num, model.plan_num];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(20, 0, kVwidth - 20, 40);
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.starLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), kVwidth - 40, 20);
    self.starLabel.textColor = [UIColor grayColor];
    self.starLabel.font = [UIFont systemFontOfSize:14];
    
    self.gradeLabel.frame = CGRectMake(20, CGRectGetMaxY(self.starLabel.frame), CGRectGetWidth(self.starLabel.frame), CGRectGetHeight(self.starLabel.frame));
    self.gradeLabel.textColor = [UIColor grayColor];
    self.gradeLabel.font = [UIFont systemFontOfSize:14];
    
    self.addressLabel.frame = CGRectMake(20, CGRectGetMaxY(self.gradeLabel.frame), CGRectGetWidth(self.starLabel.frame), CGRectGetHeight(self.starLabel.frame));
    self.addressLabel.textColor = [UIColor grayColor];
    self.addressLabel.font = [UIFont systemFontOfSize:14];
    
    self.numLabel.frame = CGRectMake(20, CGRectGetMaxY(self.addressLabel.frame), CGRectGetWidth(self.starLabel.frame), CGRectGetHeight(self.starLabel.frame));
    self.numLabel.textColor = [UIColor grayColor];
    self.numLabel.font = [UIFont systemFontOfSize:14];
    
    
}

@end
