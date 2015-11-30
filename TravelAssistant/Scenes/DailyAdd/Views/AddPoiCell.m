//
//  AddPoiCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/27.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "AddPoiCell.h"
#import "DailyPoiModel.h"
#import "Macros.h"
#import <UIImageView+WebCache.h>

@interface AddPoiCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *cn_nameLabel; // 中文名
@property (nonatomic, strong) UILabel *rankLabel;    // 排名
@property (nonatomic, strong) UILabel *gradeLabel;   // 评分
@property (nonatomic, strong) UIButton *button; // 添加按钮

@end

@implementation AddPoiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headerImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headerImageView];
        self.cn_nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.cn_nameLabel];
        self.rankLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.rankLabel];
        self.gradeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.gradeLabel];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.button];
    }
    return self;
}
- (void)setModel:(DailyPoiModel *)model
{
    _model = model;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.cn_nameLabel.text = model.cn_name;
    if (model.rank != 0) {
        self.rankLabel.text = [NSString stringWithFormat:@"%@景点综合排名第%ld名", self.cityName, model.rank];
    }
    self.gradeLabel.text = [NSString stringWithFormat:@"评分：%.2f分", model.grade];
    self.button.selected = self.is_Selected;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.headerImageView.frame = CGRectMake(20, 15, KVheight, KVheight - 30);
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    
    self.cn_nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 15, CGRectGetMinY(self.headerImageView.frame), kVwidth / 2 - 20, 20);
    self.cn_nameLabel.font = [UIFont systemFontOfSize:15];
    
    self.rankLabel.frame = CGRectMake(CGRectGetMinX(self.cn_nameLabel.frame), CGRectGetMaxY(self.cn_nameLabel.frame) + 5, CGRectGetWidth(self.cn_nameLabel.frame), 20);
    self.rankLabel.font = [UIFont systemFontOfSize:13];
    self.rankLabel.textColor = [UIColor grayColor];
    
    self.gradeLabel.frame = CGRectMake(CGRectGetMinX(self.cn_nameLabel.frame), CGRectGetMaxY(self.rankLabel.frame) + 5, CGRectGetWidth(self.cn_nameLabel.frame), 20);
    self.gradeLabel.font = [UIFont systemFontOfSize:13];
    self.gradeLabel.textColor = [UIColor grayColor];
    
    self.button.frame = CGRectMake(kVwidth - 52, KVheight / 2 - 16, 32, 32);
    [self.button setImage:[UIImage imageNamed:@"iconfont-add"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"iconfont-delete"] forState:UIControlStateSelected];
    [self.button addTarget:self action:@selector(changeSelectedPoi:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)changeSelectedPoi:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(showMBPrograssHUD)]) {
        [self.delegate showMBPrograssHUD];
    }
    
    if (sender.selected) {
        // 添加此景点
//        NSLog(@"添加");
        if (self.delegate && [self.delegate respondsToSelector:@selector(addPoiModelWithModel:)]) {
            [self.delegate addPoiModelWithModel:_model];
        }
    } else {
        // 删除此景点
//        NSLog(@"删除");
        if (self.delegate && [self.delegate respondsToSelector:@selector(deletePoiModelWithModel:)]) {
            [self.delegate deletePoiModelWithModel:_model];
        }
    }
    
}

@end
