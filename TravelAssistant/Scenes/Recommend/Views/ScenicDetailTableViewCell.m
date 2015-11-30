//
//  ScenicDetailTableViewCell.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "ScenicDetailTableViewCell.h"
@interface ScenicDetailTableViewCell()

@property (nonatomic, strong) UILabel *introduceLabel;

@end


@implementation ScenicDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _introduceLabel = [[UILabel alloc] init];
        
    }
    [self.contentView addSubview:_introduceLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _introduceLabel.frame = CGRectMake(5, 10, self.frame.size.width - 10, [self stringHeightWithString:self.scenicModel.introduction fontSize:14 contentSize:CGSizeMake(self.frame.size.width, 2000)]);
    _introduceLabel.textColor = [UIColor grayColor];
    _introduceLabel.numberOfLines = 0;
    [_introduceLabel sizeToFit];
}

- (void)setScenicModel:(ScenicBasicInfoModel *)scenicModel {
    _introduceLabel.text = scenicModel.introduction;
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
