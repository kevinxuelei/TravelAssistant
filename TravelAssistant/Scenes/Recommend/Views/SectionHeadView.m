//
//  SectionHeadView.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "SectionHeadView.h"
#import "CityModel.h"
#import <UIImageView+WebCache.h>
@interface SectionHeadView()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *cityNameLabel;

@end

@implementation SectionHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _timeLabel = [[UILabel alloc] init];
        _cityNameLabel = [[UILabel alloc] init];
    }
    [self addSubview:_timeLabel];
    [self addSubview:_cityNameLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _timeLabel.frame = CGRectMake(10, 0, self.frame.size.width, 25);
//    _timeLabel.backgroundColor = [UIColor redColor];
    
    _cityNameLabel.frame = CGRectMake(10, 25, self.frame.size.width, 20);
//    _cityNameLabel.backgroundColor = [UIColor yellowColor];
    
}

- (void)setDetailModel:(RecommendDetailModel *)detailModel {

    NSMutableArray *array = [NSMutableArray array];

    _detailModel = detailModel;

    _timeLabel.text = [NSString stringWithFormat:@"第%ld天",(long)detailModel.day];
    for (CityModel *cityModel in detailModel.citys) {
        [array addObject:cityModel.name];
    }
    _cityNameLabel.text = [array componentsJoinedByString:@">"];
//    _cityNameLabel.textColor = [UIColor greenColor];
    _cityNameLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setCityModel:(CityModel *)cityModel {
    _cityModel = cityModel;
    _cityNameLabel.text = cityModel.name;
}













@end
