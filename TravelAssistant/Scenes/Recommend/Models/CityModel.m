//
//  CityModel.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
}


- (instancetype)initWithDict:(NSDictionary *)dict {

    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)citysModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
    
}


@end
