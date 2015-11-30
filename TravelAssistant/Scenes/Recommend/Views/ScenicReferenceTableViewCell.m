//
//  ScenicReferenceTableViewCell.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "ScenicReferenceTableViewCell.h"
@interface ScenicReferenceTableViewCell()


@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation ScenicReferenceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _gradeLabel = [[UILabel alloc] init];
        _countLabel = [[UILabel alloc] init];
        
    }
    [self.contentView addSubview:self.gradeLabel];
    [self.contentView addSubview:self.countLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _gradeLabel.frame = CGRectMake(10, 5, self.frame.size.width, 20);
    _gradeLabel.textColor = [UIColor grayColor];
    _countLabel.frame = CGRectMake(10, CGRectGetMaxY(self.gradeLabel.frame) + 10, self.frame.size.width, 20);
    _countLabel.textColor = [UIColor grayColor];
}

- (void)setScenicModel:(ScenicBasicInfoModel *)scenicModel {
    _scenicModel = scenicModel;
    _gradeLabel.text = [NSString stringWithFormat:@"评分 %ld分，来自%ld点评",(long)scenicModel.grade,(long)scenicModel.commentcounts];
    _countLabel.text = [NSString stringWithFormat:@"去过 %ld人",(long)scenicModel.beentocounts];
}



@end
