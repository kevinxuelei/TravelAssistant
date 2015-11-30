//
//  PoiDetailIntroCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "PoiDetailIntroCell.h"
#import "Macros.h"

@interface PoiDetailIntroCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) UIImageView *directImageView;

@end

@implementation PoiDetailIntroCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.introLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.introLabel];
        self.directImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.directImageView];
    }
    return self;
}
- (void)setIntroduction:(NSString *)introduction
{
    _introduction = introduction;
    self.titleLabel.text = @"- 简介 -";
    self.introLabel.text = introduction;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, kVwidth, 40);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.introLabel.frame = CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame), kVwidth - 40, KVheight - 70);
    self.introLabel.font = [UIFont systemFontOfSize:14];
    self.introLabel.textColor = [UIColor grayColor];
    self.introLabel.numberOfLines = 0;
    
    self.directImageView.frame = CGRectMake(kVwidth / 2 - 10, KVheight - 25, 30, 20);
    self.directImageView.image = [UIImage imageNamed:@"iconfont-xiangxia"];
    if (self.isOpen) {
        self.directImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.directImageView.transform = CGAffineTransformMakeRotation(0);
    }
    
}

@end
