//
//  CountryCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/21.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "CountryCell.h"
#import "CountryModel.h"
#import "Macros.h"
#import <UIImageView+WebCache.h>

@interface CountryCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CountryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headerImageView];
        self.label = [[UILabel alloc] init];
        [self.contentView addSubview:self.label];
    }
    return self;
}
- (void)setModel:(CountryModel *)model
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    self.label.text = model.cn_name;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.headerImageView.frame = CGRectMake(0, 0, kVwidth, KVheight);
    
    self.label.frame = CGRectMake(10, KVheight - 40, kVwidth - 20, 40);
    self.label.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    self.label.textColor = [UIColor whiteColor];
}

@end
