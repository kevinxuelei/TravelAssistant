//
//  SelectedCityCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/24.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "SelectedCityCell.h"
#import "DestinationCityModel.h"
#import "Macros.h"

@interface SelectedCityCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIButton *button;

@end

@implementation SelectedCityCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        self.view = [[UIView alloc] init];
        [self.contentView addSubview:self.view];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:self.button];
    }
    return self;
}
- (void)setModel:(DestinationCityModel *)model
{
    self.nameLabel.text = model.cn_name;
    [self.button setImage:[UIImage imageNamed:@"iconfont-cuo"] forState:UIControlStateNormal];
    [self.button setTintColor:[UIColor lightGrayColor]];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    self.nameLabel.frame = CGRectMake(0, 0, kVwidth - KVheight, KVheight);
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:70/255.0 alpha:1.0];
    
    self.view.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame), 0, KVheight, KVheight);
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:200/255.0 blue:70/255.0 alpha:1.0];
    
    self.button.frame = CGRectMake(5, 5, KVheight - 10, KVheight - 10);
    [self.button addTarget:self action:@selector(deleteCity) forControlEvents:UIControlEventTouchUpInside];
}
- (void)deleteCity
{
    self.block(self.row);
}


@end
