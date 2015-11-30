//
//  MainSecondaryView.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/13.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MainSecondaryView.h"
#import "MainRouteModel.h"
#import "DateHelper.h"
#import "Macros.h"
#import "DataForServer.h"

#define kCellWidth self.cellSize.width
#define kCellHeight self.cellSize.height

@interface MainSecondaryView ()

@property (nonatomic, strong) UILabel *planner_nameLabel;
@property (nonatomic, strong) UILabel *start_time_formatLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation MainSecondaryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.planner_nameLabel = [[UILabel alloc] init];
        [self addSubview:self.planner_nameLabel];
        self.start_time_formatLabel = [[UILabel alloc] init];
        [self addSubview:self.start_time_formatLabel];
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.deleteButton];
    }
    return self;
}
- (void)setModel:(MainRouteModel *)model
{
    _model = model;
//    NSLog(@"objId=== %@", model.objectId);
    self.planner_nameLabel.text = model.planner_name;
    self.planner_nameLabel.numberOfLines = 0;
    [self.planner_nameLabel sizeToFit];
    
    NSString *start_time_formatString = [NSString stringWithFormat:@"%@出发", [[DateHelper sharedDateHelper] getDateStringWithDateString:model.start_time_format]];
    if ([model.start_time_format isEqualToString:@""]) {
        start_time_formatString = @"无出发日期";
    }
    self.start_time_formatLabel.text = start_time_formatString;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.planner_nameLabel.frame = CGRectMake(0, kCellHeight / 3, kCellWidth, 30);
    self.planner_nameLabel.textColor = [UIColor whiteColor];
    self.planner_nameLabel.textAlignment = NSTextAlignmentCenter;
    self.planner_nameLabel.font = [UIFont systemFontOfSize:18];
    
    self.start_time_formatLabel.frame = CGRectMake(0, CGRectGetMaxY(self.planner_nameLabel.frame), kCellWidth, 20);
    self.start_time_formatLabel.textColor = [UIColor whiteColor];
    self.start_time_formatLabel.textAlignment = NSTextAlignmentCenter;
    self.start_time_formatLabel.font = [UIFont systemFontOfSize:13];
    
    self.deleteButton.bounds = CGRectMake(0, 0, 30, 30);
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"iconfont-shanchu"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(didClickedDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    CGPoint point = self.deleteButton.center;
    point.x = kVwidth / 2;
    point.y = KVheight - 40;
    self.deleteButton.center = point;
}
// 删除当前行程
- (void)didClickedDeleteButton
{
    [[DataForServer shareDataForServer] deleteForServer:_model.objectId];
    self.block();
}


@end
