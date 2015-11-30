//
//  HotelDetailNormalCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/18.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "HotelDetailNormalCell.h"
#import "DailyHotelModel.h"
#import "Macros.h"

@interface HotelDetailNormalCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *directImageView;

@end

@implementation HotelDetailNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.messageLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.messageLabel];
        self.directImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.directImageView];
    }
    return self;
}
- (void)setRow:(NSInteger)row
{
    _row = row;
    switch (row) {
        case 0: {
            if (![self.model.recommend_reason isEqualToString:@""]) {
                self.titleLabel.text = @"推荐理由";
                self.messageLabel.text = self.model.recommend_reason;
            }
        }
            break;
        case 1: {
            if (![self.model.facility_name isEqualToString:@""]) {
                self.titleLabel.text = @"酒店设备";
                self.messageLabel.text = self.model.facility_name;
            }
        }
            break;
        case 3: {
            self.titleLabel.text = @"酒店介绍";
            self.messageLabel.text = self.model.descriptionHotel;
        }
            break;
        default:
            break;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    self.titleLabel.frame = CGRectMake(20, 0, kVwidth - 20, 40);
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.messageLabel.frame = CGRectMake(20, 40, kVwidth - 40, KVheight - 55);
    self.messageLabel.textColor = [UIColor grayColor];
    self.messageLabel.font = [UIFont systemFontOfSize:14];
    self.messageLabel.numberOfLines = 0;
    
    if (self.row == 3) {
        self.directImageView.frame = CGRectMake(kVwidth / 2 - 10, KVheight - 25, 30, 20);
        self.directImageView.image = [UIImage imageNamed:@"iconfont-xiangxia"];
        if (self.isOpen) {
            self.directImageView.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            self.directImageView.transform = CGAffineTransformMakeRotation(0);
        }
    }
}

- (CGFloat)stringHeightWithString:(NSString *)str
{
    CGRect stringRect = [str boundingRectWithSize:CGSizeMake(kVwidth - 40, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return stringRect.size.height;
}

@end
