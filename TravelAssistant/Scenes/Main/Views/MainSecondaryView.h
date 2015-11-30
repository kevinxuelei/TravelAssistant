//
//  MainSecondaryView.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/13.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainRouteModel.h"

typedef void(^MainSecondaryViewBlock)();

@interface MainSecondaryView : UIView

@property (nonatomic, strong) MainRouteModel *model;

@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic, copy) MainSecondaryViewBlock block;

@end
