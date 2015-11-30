//
//  HotelsModel.h
//  TravelAssistant
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HotelsModel : NSObject

@property (nonatomic, assign)NSInteger hotelid;
@property (nonatomic,copy) NSString *title; // 酒店名字
@property (nonatomic,copy) NSString *pic; // 酒店图片url
@property (nonatomic, assign) CGFloat lat; // 经度
@property (nonatomic, assign) CGFloat lng; // 纬度
@property (nonatomic,copy) NSString *currency; // 币种
@property (nonatomic, assign)NSInteger spend; // 花费
//@property (nonatomic, assign)NSInteger enums; // 枚举的下标

+ (instancetype)HotelsModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
