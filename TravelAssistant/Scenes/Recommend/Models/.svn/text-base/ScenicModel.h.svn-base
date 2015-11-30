//
//  ScenicModel.h
//  TravelAssistant
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScenicModel : NSObject

@property (nonatomic, assign)NSInteger ID;
@property (nonatomic, assign)NSInteger pid;
@property (nonatomic, assign)CGFloat lat; // 经度
@property (nonatomic, assign)CGFloat lng; // 纬度
@property (nonatomic,copy) NSString *name; // 景点名字
@property (nonatomic,copy) NSString *pic; // 景点图片url
@property (nonatomic, assign)NSInteger cateid; // 美食id

+ (instancetype)ScenicModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
