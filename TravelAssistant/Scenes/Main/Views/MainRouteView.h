//
//  MainRouteView.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainRouteModel;

@protocol MainRouteViewDelegate <NSObject>
// show到用户自定行程页面
- (void)showRouteViewControllerWithRow:(NSInteger)row;

- (void)showAddRouteViewController;

@end

@interface MainRouteView : UIView

@property (nonatomic, copy) NSString *user_id; // 用户id

@property (nonatomic, assign) id<MainRouteViewDelegate> delegate;


- (void)loadNewData;

@end
