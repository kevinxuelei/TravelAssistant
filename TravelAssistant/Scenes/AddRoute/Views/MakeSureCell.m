//
//  MakeSureCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/24.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MakeSureCell.h"
#import "DestinationCityModel.h"
#import "DateHelper.h"
#import "Macros.h"

@interface MakeSureCell ()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *horizView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *startTextField;
@property (nonatomic, strong) UITextField *endTextField;
@property (nonatomic, strong) UIDatePicker *startDatePicker; // 自定义键盘
@property (nonatomic, strong) UIDatePicker *endDatePicker;
@property (nonatomic, strong) UIToolbar *startToolBar; // 自定义键盘工具控件
@property (nonatomic, strong) UIToolbar *endToolBar;


@end

@implementation MakeSureCell

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
        self.startTextField = [[UITextField alloc] init];
        [self.view addSubview:self.startTextField];
        self.endTextField = [[UITextField alloc] init];
        [self.view addSubview:self.endTextField];
        
        self.startDatePicker = [[UIDatePicker alloc] init];
        self.startToolBar = [[UIToolbar alloc] init];
        self.endDatePicker = [[UIDatePicker alloc] init];
        self.endToolBar = [[UIToolbar alloc] init];
        
    }
    return self;
}
- (void)setModel:(DestinationCityModel *)model
{
    _model = model;
    self.headerImageView.image = [UIImage imageNamed:@"iconfont-jing"];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ (%ld晚)", model.cn_name, model.recommend_days];
    
    self.startTextField.text = [NSString stringWithFormat:@"%@ 到达", [[DateHelper sharedDateHelper] timeWithDate:model.start_time]];
    
    self.endTextField.text = [NSString stringWithFormat:@"%@ 离开", [[DateHelper sharedDateHelper] timeWithDate:model.end_time]];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.view.frame = CGRectMake(20, 20, kVwidth - 40, 102);
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view.layer.borderWidth = 0.5;
    
    self.headerImageView.frame = CGRectMake(20, 10, 32, 32);
    self.headerImageView.layer.borderWidth = 1;
    self.headerImageView.layer.borderColor = [UIColor redColor].CGColor;
    self.headerImageView.tintColor = [UIColor redColor];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 16;
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 20, CGRectGetMinY(self.headerImageView.frame), CGRectGetWidth(self.view.frame) - 80, CGRectGetHeight(self.headerImageView.frame));
    self.nameLabel.textColor = [UIColor grayColor];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    
    self.horizView.frame = CGRectMake(CGRectGetMinX(self.headerImageView.frame), CGRectGetMaxY(self.headerImageView.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 0.5);
    self.horizView.backgroundColor = [UIColor lightGrayColor];
    
    
    // 自定义键盘
    self.startDatePicker = [[UIDatePicker alloc] init];
    self.startDatePicker.datePickerMode = UIDatePickerModeDate; // 24小时制
    self.startDatePicker.backgroundColor = [UIColor whiteColor];
    self.startDatePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    [self.startDatePicker setDate:_model.start_time animated:NO];
    
    self.startToolBar = [[UIToolbar alloc] init];
    // 自定义键盘上的工具控件
    self.startToolBar.bounds = CGRectMake(0, 0, kVwidth, 40);
    self.startToolBar.barTintColor = [UIColor whiteColor]; // 背景颜色
    self.startToolBar.tintColor = [UIColor blackColor];    // 字体颜色
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(didClickedCancelBarButton)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]; // 弹簧工具
    UIBarButtonItem *confilmItem = [[UIBarButtonItem alloc] initWithTitle:@"确认  " style:UIBarButtonItemStylePlain target:self action:@selector(didClickedConfilmStartBarButton)];
    self.startToolBar.items = @[cancelItem, flexibleItem, confilmItem];
    
    self.startTextField.frame = CGRectMake(CGRectGetMinX(self.headerImageView.frame), CGRectGetMaxY(self.horizView.frame), CGRectGetWidth(self.view.frame) / 2 - 20, CGRectGetHeight(self.view.frame) / 2);
    self.startTextField.textColor = [UIColor orangeColor];
    self.startTextField.font = [UIFont systemFontOfSize:15];
    self.startTextField.textAlignment = NSTextAlignmentLeft;
    // 自定义键盘及工具控件
    self.startTextField.inputView = self.startDatePicker;
    self.startTextField.inputAccessoryView = self.startToolBar;
    
    // 自定义键盘
    self.endDatePicker = [[UIDatePicker alloc] init];
    self.endDatePicker.datePickerMode = UIDatePickerModeDate; // 24小时制
    self.endDatePicker.backgroundColor = [UIColor whiteColor];
    self.endDatePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    [self.endDatePicker setDate:_model.end_time animated:YES];
    
    self.endToolBar = [[UIToolbar alloc] init];
    // 自定义键盘上的工具控件
    self.endToolBar.bounds = CGRectMake(0, 0, kVwidth, 40);
    self.endToolBar.barTintColor = [UIColor whiteColor]; // 背景颜色
    self.endToolBar.tintColor = [UIColor blackColor];    // 字体颜色
    UIBarButtonItem *endCancelItem = [[UIBarButtonItem alloc] initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(didClickedCancelBarButton)];
    UIBarButtonItem *endFlexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]; // 弹簧工具
    UIBarButtonItem *endConfilmItem = [[UIBarButtonItem alloc] initWithTitle:@"确认  " style:UIBarButtonItemStylePlain target:self action:@selector(didClickedConfilmEndBarButton)];
    self.endToolBar.items = @[endCancelItem, endFlexibleItem, endConfilmItem];

    self.endTextField.frame = CGRectMake( CGRectGetWidth(self.view.frame) / 2, CGRectGetMinY(self.startTextField.frame), CGRectGetWidth(self.startTextField.frame), CGRectGetHeight(self.startTextField.frame));
    self.endTextField.textColor = [UIColor orangeColor];
    self.endTextField.font = [UIFont systemFontOfSize:15];
    self.endTextField.textAlignment = NSTextAlignmentRight;
    // 自定义键盘及工具控件
    self.endTextField.inputView = self.endDatePicker;
    self.endTextField.inputAccessoryView = self.endToolBar;
}

#pragma mark--- 自定义键盘点击方法
// 取消
- (void)didClickedCancelBarButton
{
    [self.startTextField endEditing:YES];
    [self.endTextField endEditing:YES];
}
// 到达时间确认
- (void)didClickedConfilmStartBarButton
{
    // 修改后时间不能早于原来的时间/上个离开时间
    if (self.startDatePicker.date < _date) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showAlvert)]) {
            [self.delegate showAlvert];
        }
    } else {
        // 修改模型，并重载
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeStartTimeWithNewTime:IndexPath:)]) {
            [self.delegate changeStartTimeWithNewTime:self.startDatePicker.date IndexPath:self.indexPath];
        }
        // 结束输入
        [self.startTextField endEditing:YES];
        [self.endTextField endEditing:YES];
    }
}
// 离开时间确认
- (void)didClickedConfilmEndBarButton
{
    // 修改后时间不能早于到达时间
    if (self.endDatePicker.date <= self.startDatePicker.date) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showAlvert)]) {
            [self.delegate showAlvert];
        }
    } else {
        // 修改模型，并重载
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeEndTimeWithNewTime:IndexPath:)]) {
            [self.delegate changeEndTimeWithNewTime:self.endDatePicker.date IndexPath:self.indexPath];
        }
        // 结束输入
        [self.startTextField endEditing:YES];
        [self.endTextField endEditing:YES];

    }
}




@end
