//
//  PoiDetailTipsCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "PoiDetailTipsCell.h"
#import "Macros.h"

@interface PoiDetailTipsCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipsLaebl;

@end

@implementation PoiDetailTipsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.tipsLaebl = [[UILabel alloc] init];
        [self.contentView addSubview:self.tipsLaebl];
    }
    return self;
}
- (void)setTips:(NSString *)tips
{
    _tips = tips;
    self.titleLabel.text = @"- 小贴士 -";
    self.tipsLaebl.text = tips;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, kVwidth, 40);
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tipsLaebl.frame = CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame), kVwidth - 40, [self stringHeightWithString:self.tips fontSize:14 contentSize:CGSizeMake(kVwidth - 40, 10000)]);
    self.tipsLaebl.textColor = [UIColor grayColor];
    self.tipsLaebl.font = [UIFont systemFontOfSize:14];
    self.tipsLaebl.numberOfLines = 0;
}
// 在返回每个row的高度时，调用此方法
- (CGFloat)stringHeightWithString:(NSString *)str fontSize:(CGFloat)fontSize contentSize:(CGSize)size
{
    // 第一个参数：代表最大的范围
    // 第二个参数：代表的是 是否考虑字体，是否考虑字号
    // 第三个参数：代表的是是用什么字体什么字号
    // 第四个参数：用不到，所以基本写成nil
    CGRect stringRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return stringRect.size.height;
}


@end
