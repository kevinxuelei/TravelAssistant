//
//  DailyNoRoute.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DailyNoRoute.h"
#import "Macros.h"

@implementation DailyNoRoute

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kVwidth, KVheight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"该日无行程，请点击右上角添加行程";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor grayColor];
        [self addSubview:label];
    }
    return self;
}

@end
