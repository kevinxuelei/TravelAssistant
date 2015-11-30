//
//  DestinationCityCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/23.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DestinationCityCell.h"
#import "DestinationCityModel.h"
#import "Macros.h"
#import <UIImageView+WebCache.h>

@interface DestinationCityCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *cn_nameLabel;
@property (nonatomic, strong) UILabel *memoLabel;
@property (nonatomic, strong) UIButton *chooseButton;

@end

@implementation DestinationCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headerImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headerImageView];
        self.cn_nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.cn_nameLabel];
        self.memoLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.memoLabel];
        self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.chooseButton];
    }
    return self;
}
- (void)setModel:(DestinationCityModel *)model
{
    _model = model;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_nor] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    self.cn_nameLabel.text = model.cn_name;
    self.memoLabel.text = model.memo;
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.headerImageView.frame = CGRectMake(0, 0, KVheight, KVheight);
    
    self.cn_nameLabel.frame = CGRectMake(KVheight + 10, KVheight / 2 - 20, kVwidth / 2 + 30, 20);
    self.cn_nameLabel.font = [UIFont systemFontOfSize:15];
    
    self.memoLabel.frame = CGRectMake(CGRectGetMinX(self.cn_nameLabel.frame), KVheight / 2, CGRectGetWidth(self.cn_nameLabel.frame), 20);
    self.memoLabel.textColor = [UIColor grayColor];
    self.memoLabel.font = [UIFont systemFontOfSize:13];
    
    self.chooseButton.frame = CGRectMake(kVwidth - 42, KVheight / 2 -16, 32, 32);
    self.chooseButton.tintColor = [UIColor orangeColor];
    self.chooseButton.layer.masksToBounds = YES;
//    self.chooseButton.layer.cornerRadius = KVheight / 6;
//    self.chooseButton.layer.borderColor = [UIColor orangeColor].CGColor;
//    self.chooseButton.layer.borderWidth = 1;
    [self.chooseButton setImage:[UIImage imageNamed:@"iconfont-add"] forState:UIControlStateNormal];
    [self.chooseButton addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    
}
// 选择城市
- (void)selectCity
{
    self.block(self.model);
}

@end
