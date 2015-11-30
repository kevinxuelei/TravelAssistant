//
//  MainCollectionCell.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MainCollectionCell.h"
#import "MainMajorView.h"
#import "MainSecondaryView.h"
#import "Macros.h"
#import "DateHelper.h"
#import <UIImageView+WebCache.h>

#define kCellWidth self.cellSize.width
#define kCellHeight self.cellSize.height

@interface MainCollectionCell ()
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) MainMajorView *majorView;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) MainSecondaryView *secondaryView;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation MainCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.view = [[UIView alloc] init];
        [self.contentView addSubview:self.view];
        self.majorView = [[MainMajorView alloc] init];
        [self.view addSubview:self.majorView];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.majorView addSubview:self.button];
        
        self.secondaryView = [[MainSecondaryView alloc] init];
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.secondaryView addSubview:self.backButton];
        __weak typeof(self) pSelf = self;
        self.secondaryView.block = ^() {
            pSelf.reloadBlock();
        };
        
    }
    return self;
}
- (void)setModel:(MainRouteModel *)model
{
    // 先翻转页面
    if (self.majorView.superview == nil) {
        [self.secondaryView removeFromSuperview];
        [self.view addSubview:self.majorView];
    }
    // 再赋值
    _model = model;
    [self.button setBackgroundImage:[UIImage imageNamed:@"iconfont-fengmian"] forState:UIControlStateNormal];
    
    self.majorView.model = model;
    self.majorView.cellSize = self.cellSize;
    self.secondaryView.model = model;
    self.secondaryView.cellSize = self.cellSize;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.view.frame = CGRectMake(0, 0, kCellWidth, kCellHeight);
    
    self.majorView.frame = CGRectMake(0, 0, kCellWidth, kCellHeight);
    self.majorView.backgroundColor = [UIColor whiteColor];
    
    self.button.frame = CGRectMake(kCellWidth - 50, 0, 30, 30);
    [self.button addTarget:self action:@selector(turnTosecondaryView) forControlEvents:UIControlEventTouchUpInside];
    
    self.secondaryView.frame = CGRectMake(0, 0, kCellWidth, kCellHeight);
    self.secondaryView.backgroundColor = [UIColor orangeColor];
    
    self.backButton.frame =  CGRectMake(30, 10, 40, 20);
    self.backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.backButton addTarget:self action:@selector(turnBackmajorView) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setTintColor:[UIColor whiteColor]];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
}
// 翻转页面
- (void)turnTosecondaryView
{
    self.block();
    __weak typeof(self) pSelf = self; // 重定义，防止循环引用
    [UIView transitionWithView:self.view duration:1.0f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        if (pSelf.secondaryView.superview == nil) {
            [pSelf.majorView removeFromSuperview];
            [pSelf.view addSubview:pSelf.secondaryView];
        }
    } completion:^(BOOL finished) {
        
    }];
}
- (void)turnBackmajorView
{
    self.block();
    __weak typeof(self) pSelf = self; // 重定义，防止循环引用
    [UIView transitionWithView:self.view duration:1.0f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        if (pSelf.majorView.superview == nil) {
            [pSelf.secondaryView removeFromSuperview];
            [pSelf.view addSubview:pSelf.majorView];
        }
    } completion:^(BOOL finished) {
        
    }];
}

@end
