//
//  HeadView.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "HeadView.h"
#import <UIImageView+WebCache.h>
#import "DateHelper.h"

@interface HeadView()
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *bgImage;

@end

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _userImage = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _timeLabel = [[UILabel alloc] init];
        _myView = [[UIView alloc] init];
        _bgImage = [[UIImageView alloc] init];
    }
    [self.myView addSubview:_userImage];
    [self.myView addSubview:_titleLabel];
    [self.myView addSubview:_timeLabel];
    
    [self addSubview:_bgImage];
    [self addSubview:_myView];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self loadMyView];
    
}

// 加载myView
- (void)loadMyView {
    _bgImage.frame = self.bounds;
    _bgImage.backgroundColor = [UIColor yellowColor];
    
    _myView.frame = CGRectMake(0, 120, self.frame.size.width, self.frame.size.height / 3);
    _myView.backgroundColor = [UIColor grayColor];
    _myView.alpha = 0.6;
    _userImage.frame = CGRectMake(10, (self.myView.frame.size.height - 35) / 2, 40, 40);
//    _userImage.backgroundColor = [UIColor redColor];
    _userImage.layer.cornerRadius = _userImage.frame.size.height / 2;
    _userImage.layer.masksToBounds = YES;
    
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 10, 10, self.frame.size.width - 50, 20);
//    _titleLabel.backgroundColor = [UIColor greenColor];
    
    _timeLabel.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 10, CGRectGetMaxY(self.titleLabel.frame) + 5, self.frame.size.width - 50, 20);
//    _timeLabel.backgroundColor = [UIColor blueColor];
    
}

- (void)setUserModel:(UserInfoModel *)userModel {
    
    [_bgImage sd_setImageWithURL:[NSURL URLWithString:userModel.img]];
    [_userImage sd_setImageWithURL:[NSURL URLWithString:userModel.usericon]];
    _titleLabel.text = userModel.planner_name;
    _timeLabel.text = [NSString stringWithFormat:@"%@出发",[[DateHelper sharedDateHelper] getDateStringWithDateString:userModel.format_date]]; 
}






@end
