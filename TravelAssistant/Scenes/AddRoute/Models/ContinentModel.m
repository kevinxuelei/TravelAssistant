//
//  ContinentModel.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/23.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "ContinentModel.h"
#import "CountryModel.h"

@implementation ContinentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _continentId = [value integerValue];
    } else if ([key isEqualToString:@"country"]) {
        NSArray *countryArray = value;
        for (NSDictionary *dic in countryArray) {
            CountryModel *model = [[CountryModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_countryArray addObject:model];
        }
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _countryArray = [NSMutableArray array];
    }
    return self;
}

@end
