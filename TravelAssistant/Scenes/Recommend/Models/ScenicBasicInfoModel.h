//
//  ScenicBasicInfoModel.h
//  TravelAssistant
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScenicBasicInfoModel : NSObject

@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) CGFloat lat; // 景点纬度
@property (nonatomic, assign) CGFloat lng; // 景点经度
@property (nonatomic, assign) NSInteger beentocounts;  // 来过的人数
@property (nonatomic, assign) NSInteger commentcounts; // 点评数
@property (nonatomic, assign) NSInteger grade;         // 评分
@property (nonatomic, copy) NSString *introduction; // 简介
@property (nonatomic, copy) NSString *tips;         // 小贴士
@property (nonatomic, copy) NSString *pic;   // 图片地址
@property (nonatomic, strong) NSMutableArray *piclist;  // 轮播图地址
@property (nonatomic, strong) NSMutableArray *tagNames; // 分类
@property (nonatomic, strong) NSMutableArray *comments; // 点评
@property (nonatomic, copy) NSString *wayto;    // 到达
@property (nonatomic, copy) NSString *address;  // 地址
@property (nonatomic, copy) NSString *phone;    // 电话
@property (nonatomic, copy) NSString *opentime; // 时间
@property (nonatomic, copy) NSString *price;    // 门票
@property (nonatomic, copy) NSString *site;     // 网站
@property (nonatomic, copy) NSString *cn_name;  // 中文名
@property (nonatomic, copy) NSString *en_name;  // 英文名



@end
