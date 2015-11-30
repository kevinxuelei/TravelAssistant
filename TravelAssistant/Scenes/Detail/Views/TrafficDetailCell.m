//
//  TrafficDetailCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "TrafficDetailCell.h"
#import "DailyTrafficModel.h"
#import "Macros.h"

@interface TrafficDetailCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIDatePicker *datePicker; // 自定义键盘
@property (nonatomic, strong) UIToolbar *toolBar; // 自定义键盘工具控件

@end

@implementation TrafficDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.textField = [[UITextField alloc] init];
        [self.contentView addSubview:self.textField];
        self.datePicker = [[UIDatePicker alloc] init];
        self.toolBar = [[UIToolbar alloc] init];
    }
    return self;
}
- (void)setRow:(NSInteger)row
{
    _row = row;
    NSString *title;
    NSString *textField;
    switch (row) {
        case 0:{
            title = @"班次/航班号";
            textField = self.model.traffic_number;
            }
            break;
        case 1:{
            title = @"出发城市";
            textField = self.model.fromplace;
        }
            break;
        case 2:{
            title = @"到达城市";
            textField = self.model.toplace;
        }
            break;
        case 3:{
            title = @"出发时间";
            if (self.model.starthours >= 0 && self.model.startminutes >= 0) {
                textField = [NSString stringWithFormat:@"%.2ld:%.2ld", self.model.starthours, self.model.startminutes];
            } else {
                textField = @"--:--";
            }
            // 自定义键盘及工具控件
            self.textField.inputView = self.datePicker;
            self.textField.inputAccessoryView = self.toolBar;
        }
            break;
        case 4:{
            title = @"到达时间";
            if (self.model.endhours >= 0 && self.model.endminutes >= 0) {
                textField = [NSString stringWithFormat:@"%.2ld:%.2ld", self.model.endhours, self.model.endminutes];
            } else {
                textField = @"--:--";
            }
            
            // 自定义键盘及工具控件
            self.textField.inputView = self.datePicker;
            self.textField.inputAccessoryView = self.toolBar;
        }
            break;
        default:
            break;
    }
    self.titleLabel.text = title;
    self.textField.text = textField;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(20, 0, kVwidth / 2 - 20, KVheight);
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.textField.frame = CGRectMake(kVwidth / 2, 0, kVwidth / 2 - 20, KVheight);
    self.textField.font = [UIFont systemFontOfSize:15];
    self.textField.textColor = [UIColor orangeColor];
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.delegate = self;
    self.textField.placeholder = @"未填写";
    
    // 自定义键盘
    self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer; // 24小时制
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    NSDateFormatter *nsd = [[NSDateFormatter alloc] init];
    [nsd setDateFormat:@"HH:mm"];
    if (_row == 3) {
        if (self.model.starthours >= 0 && self.model.startminutes >= 0) {
            [self.datePicker setDate:[nsd dateFromString:[NSString stringWithFormat:@"%.2ld:%.2ld", self.model.starthours, self.model.startminutes]] animated:NO];
        }
    } else if (_row == 4) {
        if (self.model.starthours >= 0 && self.model.startminutes >= 0) {
            [self.datePicker setDate:[nsd dateFromString:[NSString stringWithFormat:@"%.2ld:%.2ld", self.model.endhours, self.model.endminutes]] animated:NO];
        }
    }
    
    // 自定义键盘上的工具控件
    self.toolBar.bounds = CGRectMake(0, 0, kVwidth, 40);
    self.toolBar.barTintColor = [UIColor whiteColor]; // 背景颜色
    self.toolBar.tintColor = [UIColor blackColor];    // 字体颜色
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(didClickedCancelBarButton)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]; // 弹簧工具
    UIBarButtonItem *confilmItem = [[UIBarButtonItem alloc] initWithTitle:@"确认  " style:UIBarButtonItemStylePlain target:self action:@selector(didClickedConfilmBarButton)];
    self.toolBar.items = @[cancelItem, flexibleItem, confilmItem];
    
}

#pragma mark--- 自定义键盘点击方法
// 取消
- (void)didClickedCancelBarButton
{
    [self.textField endEditing:YES];
}
// 确认
- (void)didClickedConfilmBarButton
{
    // 修改后的小时
    NSDateFormatter *hour = [[NSDateFormatter alloc] init];
    [hour setDateFormat:@"HH"];
    NSString *hourString = [hour stringFromDate:self.datePicker.date];
    // 修改后的分钟
    NSDateFormatter *minute = [[NSDateFormatter alloc] init];
    [minute setDateFormat:@"mm"];
    NSString *minuteString = [minute stringFromDate:self.datePicker.date];
    self.textField.text = [NSString stringWithFormat:@"%@:%@", hourString, minuteString];
    
    if (self.deleagate && [self.deleagate respondsToSelector:@selector(dateChangeWithHour:Minute:WithRow:)]) {
        [self.deleagate dateChangeWithHour:[hourString integerValue] Minute:[minuteString integerValue] WithRow:self.row];
    }
    [self.textField endEditing:YES];
}
#pragma mark--- 收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.deleagate && [self.deleagate respondsToSelector:@selector(messageChangeWithString:WithRow:)]) {
        [self.deleagate messageChangeWithString:textField.text WithRow:self.row];
    }
    if (textField == self.textField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.contentView endEditing:YES];
}


@end
