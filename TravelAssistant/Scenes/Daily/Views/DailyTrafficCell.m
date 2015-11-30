//
//  DailyTrafficCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DailyTrafficCell.h"
#import "DailyTrafficModel.h"
#import "Macros.h"

@interface DailyTrafficCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *fromPlaceLabel;
@property (nonatomic, strong) UILabel *toPlaceLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;

@end

@implementation DailyTrafficCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headerImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headerImageView];
        self.fromPlaceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.fromPlaceLabel];
        self.toPlaceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.toPlaceLabel];
        self.startTimeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.startTimeLabel];
        self.endTimeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.endTimeLabel];
    }
    return self;
}
- (void)setModel:(DailyTrafficModel *)model
{
    self.headerImageView.backgroundColor = [UIColor blueColor];
    self.headerImageView.image = [UIImage imageNamed:@"iconfont-jiaotongiconplane"];
    self.fromPlaceLabel.text = model.fromplace;
    self.toPlaceLabel.text = model.toplace;
    if (model.starthours >= 0 && model.startminutes >= 0) {
        self.startTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", model.starthours, model.startminutes];
    } else {
        self.startTimeLabel.text = @"--:--";
    }
    if (model.endminutes >= 0 && model.endhours >= 0) {
        self.endTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", model.endhours, model.endminutes];
    } else {
        self.endTimeLabel.text = @"--:--";
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.headerImageView.frame = CGRectMake(kImageViewWidth, (KVheight - kImageViewWidth) / 2, kImageViewWidth, kImageViewWidth);
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = kImageViewWidth / 2;
    
    self.fromPlaceLabel.frame = CGRectMake(kImageViewWidth * 3 - 10, CGRectGetMinY(self.headerImageView.frame) - 5, kVwidth / 2, kImageViewWidth / 2);
    self.fromPlaceLabel.font = [UIFont systemFontOfSize:14];
    
    self.toPlaceLabel.frame = CGRectMake(CGRectGetMinX(self.fromPlaceLabel.frame), CGRectGetMaxY(self.fromPlaceLabel.frame) + 10, CGRectGetWidth(self.fromPlaceLabel.frame), CGRectGetHeight(self.fromPlaceLabel.frame));
    self.toPlaceLabel.font = [UIFont systemFontOfSize:14];
    
    self.startTimeLabel.frame = CGRectMake( CGRectGetMaxX(self.fromPlaceLabel.frame), CGRectGetMinY(self.fromPlaceLabel.frame), kVwidth - CGRectGetMinX(self.startTimeLabel.frame), CGRectGetHeight(self.fromPlaceLabel.frame));
    self.startTimeLabel.font = [UIFont systemFontOfSize:14];
    
    self.endTimeLabel.frame = CGRectMake(CGRectGetMinX(self.startTimeLabel.frame), CGRectGetMinY(self.toPlaceLabel.frame), CGRectGetWidth(self.startTimeLabel.frame), CGRectGetHeight(self.startTimeLabel.frame));
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
}

@end
