//
//  MakeTrafficCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/24.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MakeTrafficCell.h"
#import "DestinationCityModel.h"
#import "DateHelper.h"
#import "Macros.h"

@interface MakeTrafficCell ()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *horizView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIDatePicker *datePicker; // 自定义键盘
@property (nonatomic, strong) UIToolbar *toolBar; // 自定义键盘工具控件

@end

@implementation MakeTrafficCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.view = [[UIView alloc] init];
        [self.contentView addSubview:self.view];
        self.horizView = [[UIView alloc] init];
        [self.view addSubview:self.horizView];
        self.headerImageView = [[UIImageView alloc] init];
        [self.view addSubview:self.headerImageView];
        self.nameLabel = [[UILabel alloc] init];
        [self.view addSubview:self.nameLabel];
        self.textField = [[UITextField alloc] init];
        [self.view addSubview:self.textField];
        
        self.datePicker = [[UIDatePicker alloc] init];
        self.toolBar = [[UIToolbar alloc] init];
    }
    return self;
}
- (void)setRow:(NSInteger)row
{
    _row = row;
    self.headerImageView.image = [UIImage imageNamed:@"iconfont-hangban"];
    
    if (row == 0) {
        self.textField.text = [NSString stringWithFormat:@"%@ 出发", [[DateHelper sharedDateHelper] completeTimeWithDate:self.date]];
        self.nameLabel.text = @"北京（出发）";
    } else {
        self.textField.text = [NSString stringWithFormat:@"%@ 返回", [[DateHelper sharedDateHelper] completeTimeWithDate:self.model.end_time]];
        self.nameLabel.text = @"北京（返回）";
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.view.frame = CGRectMake(20, 20, kVwidth - 40, 102);
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view.layer.borderWidth = 0.5;
    
    self.headerImageView.frame = CGRectMake(20, 10, 32, 32);
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 20, CGRectGetMinY(self.headerImageView.frame), CGRectGetWidth(self.view.frame) - 80, CGRectGetHeight(self.headerImageView.frame));
    self.nameLabel.textColor = [UIColor grayColor];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    
    self.horizView.frame = CGRectMake(CGRectGetMinX(self.headerImageView.frame), CGRectGetMaxY(self.headerImageView.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 0.5);
    self.horizView.backgroundColor = [UIColor lightGrayColor];
    
    
    // 自定义键盘
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate; // 24小时制
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    
    self.toolBar = [[UIToolbar alloc] init];
    // 自定义键盘上的工具控件
    self.toolBar.bounds = CGRectMake(0, 0, kVwidth, 40);
    self.toolBar.barTintColor = [UIColor whiteColor]; // 背景颜色
    self.toolBar.tintColor = [UIColor blackColor];    // 字体颜色
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(didClickedCancelBarButton)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]; // 弹簧工具
    UIBarButtonItem *confilmItem = [[UIBarButtonItem alloc] initWithTitle:@"确认  " style:UIBarButtonItemStylePlain target:self action:@selector(didClickedConfilmStartBarButton)];
    self.toolBar.items = @[cancelItem, flexibleItem, confilmItem];
    
    self.textField.frame = CGRectMake(CGRectGetMinX(self.headerImageView.frame), CGRectGetMaxY(self.horizView.frame), CGRectGetWidth(self.view.frame) / 2 - 20, CGRectGetHeight(self.view.frame) / 2);
    self.textField.textColor = [UIColor orangeColor];
    self.textField.font = [UIFont systemFontOfSize:15];
    self.textField.textAlignment = NSTextAlignmentLeft;
    
    // 禁止编辑
    self.textField.enabled = NO;
    // 自定义键盘及工具控件
//    self.textField.inputView = self.datePicker;
//    self.textField.inputAccessoryView = self.toolBar;
    
}

#pragma mark--- 自定义键盘点击方法
// 取消
- (void)didClickedCancelBarButton
{
    [self.textField endEditing:YES];
}
// 到达时间确认
- (void)didClickedConfilmStartBarButton
{
    // 修改后时间不能早于原来的时间/上个离开时间
    
    
    // 结束输入
    [self.textField endEditing:YES];
}
// 离开时间确认
- (void)didClickedConfilmEndBarButton
{
    // 修改后时间不能早于到达时间
    
    // 结束输入
    [self.textField endEditing:YES];
}



@end
