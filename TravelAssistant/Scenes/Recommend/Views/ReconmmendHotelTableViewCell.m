//
//  ReconmmendHotelTableViewCell.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "ReconmmendHotelTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface ReconmmendHotelTableViewCell()
@property (nonatomic, strong) UIImageView *imgIcon; // 旅馆的标识图片（本地图片）
@property (nonatomic, strong) UIImageView *imgTitle; // 旅馆图片
@property (nonatomic, strong) UILabel *titleLabel; // 旅馆名字
@property (nonatomic, strong) UILabel *spendLabel; // 花费


@end

@implementation ReconmmendHotelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _imgIcon = [[UIImageView alloc] init];
        _imgTitle = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _spendLabel = [[UILabel alloc] init];
    }
    [self.contentView addSubview:_imgIcon];
    [self.contentView addSubview:_imgTitle];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_spendLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgIcon.frame = CGRectMake(5, (self.frame.size.height - 20) / 2, 25, 25);
//    self.imgIcon.backgroundColor = [UIColor redColor];
    self.imgIcon.layer.cornerRadius = self.imgIcon.frame.size.width / 2;
    self.imgIcon.layer.masksToBounds = YES;
    
    self.imgTitle.frame = CGRectMake(CGRectGetMaxX(self.imgIcon.frame) + 9, (self.frame.size.height - 40) / 2, 30, 30);
//    self.imgTitle.backgroundColor = [UIColor yellowColor];
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imgTitle.frame) + 5, (self.frame.size.height - 35) / 2, self.frame.size.width - 70, 20);
//    self.titleLabel.backgroundColor = [UIColor r/edColor];
    
    self.spendLabel.frame = CGRectMake(CGRectGetMaxX(self.imgTitle.frame) + 5, CGRectGetMaxY(self.titleLabel.frame) , 300, 20);
    self.spendLabel.textColor = [UIColor grayColor];
    self.spendLabel.font = [UIFont systemFontOfSize:14];
//    self.spendLabel.backgroundColor = [UIColor yellowColor];
}

- (void)setHotelModel:(HotelsModel *)hotelModel {
    _hotelModel = hotelModel;
    self.imgIcon.image = [UIImage imageNamed:@"iconfont-binguan"];
    [self.imgTitle sd_setImageWithURL:[NSURL URLWithString:hotelModel.pic] placeholderImage:nil];
    self.titleLabel.text = hotelModel.title;
    if (hotelModel.spend == 0) {
        self.spendLabel.text = [NSString stringWithFormat:@"花费：暂无"];
    }else{
        self.spendLabel.text = [NSString stringWithFormat:@"花费：%@ %ld",hotelModel.currency,(long)hotelModel.spend];
    }
}


@end
