//
//  ContinentModel.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/23.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContinentModel : NSObject

@property (nonatomic, assign) NSInteger continentId; // 洲的id
@property (nonatomic, copy) NSString *cn_name;       // 洲的中文名
@property (nonatomic, copy) NSString *en_name;       // 洲的英文名
@property (nonatomic, strong) NSMutableArray *countryArray; // 洲所包含的国家（地区）

@end
