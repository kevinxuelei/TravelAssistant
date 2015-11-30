//
//  PoiDetailCommentCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "PoiDetailCommentCell.h"
#import "CommentModel.h"
#import "DateHelper.h"
#import "Macros.h"
#import <UIImageView+WebCache.h>

@interface PoiDetailCommentCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation PoiDetailCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.userImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userImageView];
        self.userLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.userLabel];
        self.commentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.commentLabel];
        self.timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}
- (void)setModel:(CommentModel *)model
{
    _model = model;
    if (_row == 0) {
        self.titleLabel.text = @"- 用户点评 -";
    } else {
        self.titleLabel.text = @"";
    }
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.userLabel.text = model.username;
    self.commentLabel.text = model.comment;
    self.timeLabel.text = [[DateHelper sharedDateHelper] getCommentCreateDateWithTimeInterval:model.datetime];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.row == 0) {
        self.titleLabel.frame = CGRectMake(0, 0, kVwidth, 40);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    } else {
        self.titleLabel.frame = CGRectMake(0, 0, kVwidth, 0);
    }
    self.userImageView.frame = CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame) + 10, 32, 32);
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 16;
    
    self.userLabel.frame = CGRectMake(CGRectGetMaxX(self.userImageView.frame) + 10, CGRectGetMinY(self.userImageView.frame), kVwidth - 72, 20);
    self.userLabel.textColor = [UIColor lightGrayColor];
    self.userLabel.font = [UIFont systemFontOfSize:14];
    
    self.commentLabel.frame = CGRectMake(CGRectGetMinX(self.userLabel.frame), CGRectGetMaxY(self.userLabel.frame) + 2, CGRectGetWidth(self.userLabel.frame), [self stringHeightWithString:self.model.comment fontSize:13 contentSize:CGSizeMake(CGRectGetWidth(self.userLabel.frame), 10000)]);
    self.commentLabel.textColor = [UIColor grayColor];
    self.commentLabel.font = [UIFont systemFontOfSize:13];
    self.commentLabel.numberOfLines = 0;
    
    self.timeLabel.frame = CGRectMake(CGRectGetMinX(self.commentLabel.frame), CGRectGetMaxY(self.commentLabel.frame) + 2, CGRectGetWidth(self.commentLabel.frame), 20);
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    
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
