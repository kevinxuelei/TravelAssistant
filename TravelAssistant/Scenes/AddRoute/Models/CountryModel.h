//
//  CountryModel.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/21.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryModel : NSObject

@property (nonatomic, assign) NSInteger countryId; // 国家id
@property (nonatomic, copy) NSString *cn_name;     // 国家中文名
@property (nonatomic, copy) NSString *en_name;     // 国家英文名
@property (nonatomic, copy) NSString *photo;       // 国家图片

@end
