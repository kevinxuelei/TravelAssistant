//
//  MainFoundView.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainFoundModel;

@protocol MainFoundViewDelegate <NSObject>

// 让代理人show到推荐列表
- (void)showRecommendViewControllerWithName:(NSString *)name Type:(NSInteger)type;

// 让代理人show到行程页面
- (void)showRecommendDetailViewControllerWithMainFoundModel:(MainFoundModel *)model;

@end

@interface MainFoundView : UIView

@property (nonatomic, copy) NSString *user_id; // 用户id

@property (nonatomic, assign) id<MainFoundViewDelegate> delegate;

@end