//
//  MainRecommendTableCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MainRecommendTableCell.h"
#import "MainRecommendModel.h"
#import "Macros.h"
#import <UIImageView+WebCache.h>

@interface MainRecommendTableCell ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *nameLable;

@end

@implementation MainRecommendTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.bgImageView];
        self.nameLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLable];
    }
    return self;
}
- (void)setModel:(MainRecommendModel *)model
{
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    if (model.type == 0) {
        self.nameLable.text = @"";
    } else {
        self.nameLable.text = model.name;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.bgImageView.frame = CGRectMake(0, 0, kVwidth, KVheight);
    
    self.nameLable.frame = CGRectMake(0, 0, kVwidth, KVheight);
    self.nameLable.textColor = [UIColor whiteColor];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:18];
    
}

@end
