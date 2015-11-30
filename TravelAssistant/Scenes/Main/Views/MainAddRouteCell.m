//
//  MainAddRouteCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/26.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MainAddRouteCell.h"
#import "Macros.h"

#define kCellWidth self.cellSize.width
#define kCellHeight self.cellSize.height

@interface MainAddRouteCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation MainAddRouteCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headerImageView];
        self.label = [[UILabel alloc] init];
        [self.contentView addSubview:self.label];
    }
    return self;
}
- (void)setCellSize:(CGSize)cellSize
{
    _cellSize = cellSize;
    self.headerImageView.image = [UIImage imageNamed:@"iconfont-tianjia"];
    self.label.text = @"点击添加行程";
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
    
    self.headerImageView.frame = CGRectMake(kCellWidth/2 - 20, kCellHeight/2 - 40, 40, 40);
    
    self.label.frame = CGRectMake(0, CGRectGetMaxY(self.headerImageView.frame) + 5, kCellWidth, 20);
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor lightGrayColor];
    self.label.numberOfLines = 0;
    self.label.font = [UIFont systemFontOfSize:15];

}

@end
