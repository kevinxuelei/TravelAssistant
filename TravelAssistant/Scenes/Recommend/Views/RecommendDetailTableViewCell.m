//
//  RecommendDetailTableViewCell.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "RecommendDetailTableViewCell.h"
#import <UIImageView+WebCache.h>
@interface RecommendDetailTableViewCell()

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UIImageView *imgTitle;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation RecommendDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imgIcon = [[UIImageView alloc] init];
        _imgTitle = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
    }
    [self.contentView addSubview:_imgIcon];
    [self.contentView addSubview:_imgTitle];
    [self.contentView addSubview:_titleLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imgIcon.frame = CGRectMake(10, (self.frame.size.height - 20) / 2, 25, 25);
//    self.imgIcon.backgroundColor = [UIColor greenColor];
    self.imgIcon.layer.cornerRadius = self.imgIcon.frame.size.width / 2;
    self.imgIcon.layer.masksToBounds = YES;

    
    self.imgTitle.frame = CGRectMake(CGRectGetMaxX(self.imgIcon.frame) + 5, 20, 30, 30);
//    self.imgTitle.backgroundColor = [UIColor yellowColor];
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imgTitle.frame) + 5, 20, 300, 30);
//    self.titleLabel.backgroundColor = [UIColor redColor];


}

- (void)setScenicModel:(ScenicModel *)scenicModel {

    self.imgIcon.image = [UIImage imageNamed:@"iconfont-jingdian"];
    [self.imgTitle sd_setImageWithURL:[NSURL URLWithString:scenicModel.pic] placeholderImage:nil];
    self.titleLabel.text = scenicModel.name;
}







@end
