//
//  NumberView.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/21.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "NumberView.h"
#import "Macros.h"

@implementation NumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}
- (void)setIndex:(NSInteger)index
{
    switch (index) {
        case 1:{
            [self loadFirstView];
        }
            break;
        case 2:{
            [self loadFirstView];
            [self loadSecondView];
        }
            break;
        case 3:{
            [self loadFirstView];
            [self loadSecondView];
            [self loadThirdView];
        }
            break;
        default:
            break;
    }
}
// 选择日期页面加载至此
- (void)loadFirstView
{
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kVwidth / 3, KVheight)];
    dateView.backgroundColor = [UIColor colorWithRed:255/255.0 green:200/255.0 blue:70/255.0 alpha:1.0];
    [self addSubview:dateView];
}
// 选择目的地页面加载至此
- (void)loadSecondView
{
    UIView *destinationView = [[UIView alloc] initWithFrame:CGRectMake(kVwidth / 3, 0, kVwidth / 3, KVheight)];
    destinationView.backgroundColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:70/255.0 alpha:1.0];
    [self addSubview:destinationView];
}
// 确认页面加载至此
- (void)loadThirdView
{
    UIView *makeSureView = [[UIView alloc] initWithFrame:CGRectMake(kVwidth * 2 / 3, 0, kVwidth, KVheight)];
    makeSureView.backgroundColor = [UIColor colorWithRed:255/255.0 green:100/255.0 blue:70/255.0 alpha:1.0];
    [self addSubview:makeSureView];
}

@end
