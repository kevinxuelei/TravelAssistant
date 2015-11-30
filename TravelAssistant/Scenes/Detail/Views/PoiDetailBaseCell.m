//
//  PoiDetailBaseCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "PoiDetailBaseCell.h"
#import "DailyPoiModel.h"
#import "Macros.h"

@interface PoiDetailBaseCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *waytoLabel;
@property (nonatomic, strong) UILabel *opentimeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *tagNamesLabel;
@property (nonatomic, strong) UILabel *siteLabel;
@property (nonatomic, strong) UILabel *phobeLabel;

@end

@implementation PoiDetailBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.addressLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.addressLabel];
        self.waytoLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.waytoLabel];
        self.opentimeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.opentimeLabel];
        self.priceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.priceLabel];
        self.tagNamesLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.tagNamesLabel];
        self.siteLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.siteLabel];
        self.phobeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.phobeLabel];
    }
    return self;
}
- (void)setModel:(DailyPoiModel *)model
{
    _model = model;
    self.titleLabel.text = @"- 基本信息 -";
    if ([model.address isEqualToString:@""]) {
        self.addressLabel.text = [NSString stringWithFormat:@"地址:\n暂无信息"];
    } else {
        self.addressLabel.text = [NSString stringWithFormat:@"地址:\n%@", model.address];
    }
    if ([model.wayto isEqualToString:@""]) {
        self.waytoLabel.text = [NSString stringWithFormat:@"到达:\n暂无信息"];
    } else {
        self.waytoLabel.text = [NSString stringWithFormat:@"到达:\n%@", model.wayto];
    }
    if ([model.opentime isEqualToString:@""]) {
        self.opentimeLabel.text = [NSString stringWithFormat:@"时间:\n暂无信息"];
    } else {
        self.opentimeLabel.text = [NSString stringWithFormat:@"时间:\n%@", model.opentime];
    }
    if ([model.price isEqualToString:@""]) {
        self.priceLabel.text = [NSString stringWithFormat:@"门票:\n暂无信息"];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"门票:\n%@", model.price];
    }
    if (model.tagNames.count == 0) {
        self.tagNamesLabel.text = [NSString stringWithFormat:@"分类:\n暂无信息"];
    } else {
        self.tagNamesLabel.text = [NSString stringWithFormat:@"分类:\n%@", [model.tagNames componentsJoinedByString:@","]];
    }
    if ([model.site isEqualToString:@""]) {
        self.siteLabel.text = [NSString stringWithFormat:@"网站:\n暂无信息"];
    } else {
        self.siteLabel.text = [NSString stringWithFormat:@"网站:\n%@", model.site];
    }
    if ([model.phone isEqualToString:@""]) {
         self.phobeLabel.text = [NSString stringWithFormat:@"电话:\n暂无信息"];
    } else {
         self.phobeLabel.text = [NSString stringWithFormat:@"电话:\n%@", model.phone];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, kVwidth, 40);
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.addressLabel.frame = CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame) + 5, kVwidth - 40, [self stringHeightWithString:self.model.address] + 20);
    self.addressLabel.font = [UIFont systemFontOfSize:14];
    self.addressLabel.textColor = [UIColor grayColor];
    self.addressLabel.numberOfLines = 0;
    
    self.waytoLabel.frame = CGRectMake(20, CGRectGetMaxY(self.addressLabel.frame) + 5, kVwidth - 40, [self stringHeightWithString:self.model.wayto] + 20);
    self.waytoLabel.font = [UIFont systemFontOfSize:14];
    self.waytoLabel.textColor = [UIColor grayColor];
    self.waytoLabel.numberOfLines = 0;
    
    self.opentimeLabel.frame = CGRectMake(20, CGRectGetMaxY(self.waytoLabel.frame) + 5, kVwidth - 40, [self stringHeightWithString:self.model.opentime] + 20);
    self.opentimeLabel.font = [UIFont systemFontOfSize:14];
    self.opentimeLabel.textColor = [UIColor grayColor];
    self.opentimeLabel.numberOfLines = 0;
    
    self.priceLabel.frame = CGRectMake(20, CGRectGetMaxY(self.opentimeLabel.frame) + 5, kVwidth - 40, [self stringHeightWithString:self.model.price] + 20);
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    self.priceLabel.textColor = [UIColor grayColor];
    self.priceLabel.numberOfLines = 0;
    
    self.tagNamesLabel.frame = CGRectMake(20, CGRectGetMaxY(self.priceLabel.frame) + 5, kVwidth - 40, 40);
    self.tagNamesLabel.font = [UIFont systemFontOfSize:14];
    self.tagNamesLabel.textColor = [UIColor grayColor];
    self.tagNamesLabel.numberOfLines = 0;
    
    self.siteLabel.frame = CGRectMake(20, CGRectGetMaxY(self.tagNamesLabel.frame) + 5, kVwidth - 40, [self stringHeightWithString:self.model.site] + 20);
    self.siteLabel.font = [UIFont systemFontOfSize:14];
    self.siteLabel.textColor = [UIColor grayColor];
    self.siteLabel.numberOfLines = 0;
    
    self.phobeLabel.frame = CGRectMake(20, CGRectGetMaxY(self.siteLabel.frame) + 5, kVwidth - 40, 40);
    self.phobeLabel.font = [UIFont systemFontOfSize:14];
    self.phobeLabel.textColor = [UIColor grayColor];
    self.phobeLabel.numberOfLines = 0;
    
}
// 在返回每个row的高度时，调用此方法
- (CGFloat)stringHeightWithString:(NSString *)str
{
    CGRect stringRect = [str boundingRectWithSize:CGSizeMake(kVwidth - 40, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    return stringRect.size.height;
}


@end
