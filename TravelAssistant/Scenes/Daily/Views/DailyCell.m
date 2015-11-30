//
//  DailyCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DailyCell.h"
#import "DailyPoiModel.h"
#import "Macros.h"
#import <UIImageView+WebCache.h>

@interface DailyCell ()

@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation DailyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rankLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.rankLabel];
        self.headerImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headerImageView];
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}
- (void)setModel:(DailyPoiModel *)model
{
    self.rankLabel.backgroundColor = [UIColor orangeColor];
    self.rankLabel.text = [NSString stringWithFormat:@"%ld", self.rank + 1];
    self.nameLabel.text = model.cn_name;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"iconfont-imageplaceholder"]];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.rankLabel.frame = CGRectMake(kImageViewWidth, (KVheight - kImageViewWidth) / 2, kImageViewWidth, kImageViewWidth);
    self.rankLabel.textAlignment = NSTextAlignmentCenter;
    self.rankLabel.textColor = [UIColor whiteColor];
    self.rankLabel.layer.masksToBounds = YES;
    self.rankLabel.layer.cornerRadius = kImageViewWidth / 2;
    
    self.headerImageView.frame = CGRectMake(kImageViewWidth * 3 - 10, CGRectGetMinY(self.rankLabel.frame), kImageViewWidth, kImageViewWidth);
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 17, CGRectGetMinY(self.headerImageView.frame), kVwidth / 2, kImageViewWidth);
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    
}

@end
