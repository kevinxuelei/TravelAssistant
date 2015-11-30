//
//  CountryModel.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/21.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "CountryModel.h"

@implementation CountryModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _countryId = [value integerValue];
    }
}

@end
