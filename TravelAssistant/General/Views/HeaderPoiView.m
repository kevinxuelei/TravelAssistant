//
//  HeaderPoiView.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/18.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "HeaderPoiView.h"
#import "Macros.h"

@interface HeaderPoiView ()

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *cnNameLabel;
@property (nonatomic, strong) UILabel *enNameLabel;

@end

@implementation HeaderPoiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.countLabel = [[UILabel alloc] init];
        [self addSubview:self.countLabel];
        self.cnNameLabel = [[UILabel alloc] init];
        [self addSubview:self.cnNameLabel];
        self.enNameLabel = [[UILabel alloc] init];
        [self addSubview:self.enNameLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.countLabel.frame = CGRectMake(0, 0, kVwidth, 20);
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.font = [UIFont systemFontOfSize:12];
    
    self.cnNameLabel.frame = CGRectMake(0, 20, kVwidth, 20);
    self.cnNameLabel.textColor = [UIColor whiteColor];
    self.cnNameLabel.font = [UIFont systemFontOfSize:15];
    
    self.enNameLabel.frame = CGRectMake(0, 40, kVwidth, 20);
    self.enNameLabel.textColor = [UIColor whiteColor];
    self.enNameLabel.font = [UIFont systemFontOfSize:13];
}

- (void)setBeenCounts:(NSInteger)counts
{
    self.countLabel.text = [NSString stringWithFormat:@"%ld人来过", counts];
}
- (void)setCnName:(NSString *)cn_name
{
    self.cnNameLabel.text = cn_name;
}
- (void)setEnName:(NSString *)en_name
{
    self.enNameLabel.text = en_name;
}

@end
