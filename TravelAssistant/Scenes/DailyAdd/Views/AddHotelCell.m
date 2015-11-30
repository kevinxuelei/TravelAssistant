//
//  AddHotelCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/28.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "AddHotelCell.h"
#import "DailyHotelModel.h"
#import "Macros.h"
#import <UIImageView+WebCache.h>

@interface AddHotelCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *starLabel;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UILabel *priceLaebl;
@property (nonatomic, strong) UIButton *button;

@end

@implementation AddHotelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headerImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headerImageView];
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        self.starLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.starLabel];
        self.gradeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.gradeLabel];
        self.areaLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.areaLabel];
        self.priceLaebl = [[UILabel alloc] init];
        [self.contentView addSubview:self.priceLaebl];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.button];
    }
    return self;
}
- (void)setModel:(DailyHotelModel *)model
{
    _model = model;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.pics] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", model.en_name, model.cn_name];
    self.starLabel.text = [NSString stringWithFormat:@"%ld星级", model.star];
    self.gradeLabel.text = [NSString stringWithFormat:@"评分：%ld分", model.grade];
    self.areaLabel.text = model.area_name;
    self.priceLaebl.text = [NSString stringWithFormat:@"¥%.2f起", [model.price floatValue]];
    self.button.selected = self.is_Selected;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.headerImageView.frame = CGRectMake(20, 10, KVheight - 20, KVheight - 20);
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES; // 超出部分裁剪
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 10, CGRectGetMinY(self.headerImageView.frame), kVwidth - KVheight - 30, 23);
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    
    self.starLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) +5, 100, 25);
    self.starLabel.font = [UIFont systemFontOfSize:13];
    self.starLabel.textColor = [UIColor grayColor];
    
    self.gradeLabel.frame = CGRectMake(CGRectGetMinX(self.starLabel.frame), CGRectGetMaxY(self.starLabel.frame), 100, 25);
    self.gradeLabel.font = [UIFont systemFontOfSize:13];
    self.gradeLabel.textColor = [UIColor grayColor];
    
    self.areaLabel.frame = CGRectMake(CGRectGetMinX(self.gradeLabel.frame), CGRectGetMaxY(self.gradeLabel.frame), 100, 25);
    self.areaLabel.font = [UIFont systemFontOfSize:13];
    self.areaLabel.textColor = [UIColor grayColor];
    
    self.button.frame = CGRectMake(kVwidth - 52, CGRectGetMaxY(self.nameLabel.frame) + 15, 32, 32);
    [self.button setImage:[UIImage imageNamed:@"iconfont-add"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"iconfont-delete"] forState:UIControlStateSelected];
    [self.button addTarget:self action:@selector(changeSelectedPoi:) forControlEvents:UIControlEventTouchUpInside];
    
    self.priceLaebl.frame = CGRectMake(kVwidth - 140, CGRectGetMaxY(self.button.frame) + 3, 120, 30);
    self.priceLaebl.textColor = [UIColor redColor];
    self.priceLaebl.textAlignment = NSTextAlignmentRight;
    
}
- (void)changeSelectedPoi:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(showMBPrograssHUD)]) {
        [self.delegate showMBPrograssHUD];
    }
    
    if (sender.selected) {
        // 添加此景点
        //        NSLog(@"添加");
        if (self.delegate && [self.delegate respondsToSelector:@selector(addHotelModelWithModel:)]) {
            [self.delegate addHotelModelWithModel:_model];
        }
    } else {
        // 删除此景点
        //        NSLog(@"删除");
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteHotelModelWithModel:)]) {
            [self.delegate deleteHotelModelWithModel:_model];
        }
    }
    
}

@end
