//
//  ScenicComentTableViewCell.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "ScenicComentTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "DateHelper.h"

@interface ScenicComentTableViewCell()

@property (nonatomic, strong) UIImageView *userIconImage; // 用户头像
@property (nonatomic, strong) UILabel *userNameAndContentLabel; // 用户名字及评论内容
@property (nonatomic, strong) UILabel *timeLabel; // 评论时间

@end

@implementation ScenicComentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userIconImage = [[UIImageView alloc] init];
        _userNameAndContentLabel = [[UILabel alloc] init];
        _timeLabel = [[UILabel alloc] init];
    }
    [self.contentView addSubview:self.userIconImage];
    [self.contentView addSubview:self.userNameAndContentLabel];
    [self.contentView addSubview:self.timeLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _userIconImage.frame = CGRectMake(10, 10, 40, 40);
    _userIconImage.layer.cornerRadius = 20;
    _userIconImage.layer.masksToBounds = YES;
    
    _userNameAndContentLabel.frame = CGRectMake(CGRectGetMaxX(self.userIconImage.frame) + 5,5, self.frame.size.width -CGRectGetMaxX(self.userIconImage.frame) - 20, [self stringHeightWithString:[NSString stringWithFormat:@"%@\n %@",self.commentModel.username,self.commentModel.comment]fontSize:14 contentSize:CGSizeMake(self.frame.size.width, 2000)]);
    _userNameAndContentLabel.textColor = [UIColor grayColor];
    _userNameAndContentLabel.numberOfLines = 0;
    [_userNameAndContentLabel sizeToFit];
    
    
    _timeLabel.frame = CGRectMake(CGRectGetMinX(self.userNameAndContentLabel.frame), CGRectGetMaxY(self.userNameAndContentLabel.frame),  self.frame.size.width, 20);
    _timeLabel.textColor = [UIColor grayColor];
}

- (void)setCommentModel:(CommentModel *)commentModel {
    _commentModel = commentModel;
    [_userIconImage sd_setImageWithURL:[NSURL URLWithString:commentModel.avatar] placeholderImage:nil];
    _userNameAndContentLabel.text = [NSString stringWithFormat:@"%@\n %@",self.commentModel.username,self.commentModel.comment];
    
    _timeLabel.text = [[DateHelper sharedDateHelper] getCommentCreateDateWithTimeInterval:self.commentModel.datetime];
    
    
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
