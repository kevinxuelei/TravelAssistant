//
//  DailyHotelCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DailyHotelCell.h"
#import "DailyHotelModel.h"
#import "Macros.h"
#import <UIImageView+WebCache.h>

@interface DailyHotelCell ()

@property (nonatomic, strong) UIImageView *rankImageView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation DailyHotelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rankImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.rankImageView];
        self.headerImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headerImageView];
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}
- (void)setModel:(DailyHotelModel *)model
{
    self.rankImageView.backgroundColor = [UIColor blackColor];
    self.rankImageView.image = [UIImage imageNamed:@"iconfont-chuang"];
    self.nameLabel.text = model.cn_name;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.pics] placeholderImage:[UIImage imageNamed:@"iconfont-imageplaceholder"]];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.rankImageView.frame = CGRectMake(kImageViewWidth, (KVheight - kImageViewWidth) / 2, kImageViewWidth, kImageViewWidth);
    self.rankImageView.layer.masksToBounds = YES;
    self.rankImageView.layer.cornerRadius = kImageViewWidth / 2;
    
    self.headerImageView.frame = CGRectMake(kImageViewWidth * 3 - 10, CGRectGetMinY(self.rankImageView.frame), kImageViewWidth, kImageViewWidth);
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 17, CGRectGetMinY(self.headerImageView.frame), kVwidth / 2, kImageViewWidth);
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    
}

@end
