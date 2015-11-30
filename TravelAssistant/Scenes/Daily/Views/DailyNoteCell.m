//
//  DailyNoteCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DailyNoteCell.h"
#import "DailyNoteModel.h"
#import "Macros.h"

@interface DailyNoteCell ()

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation DailyNoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.messageLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.messageLabel];
    }
    return self;
}
- (void)setModel:(DailyNoteModel *)model
{
    _model = model;
    self.messageLabel.text = model.message;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.messageLabel.frame = CGRectMake(32, 20, kVwidth - 64, [self stringHeightWithString:self.model.message fontSize:14 contentSize:CGSizeMake(kVwidth - 64, 1000)]);
    self.messageLabel.font = [UIFont systemFontOfSize:14];
    self.messageLabel.numberOfLines = 0;
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
