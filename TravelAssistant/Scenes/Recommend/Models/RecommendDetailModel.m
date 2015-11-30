//
//  RecommendDetailModel.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "RecommendDetailModel.h"

@implementation RecommendDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = [value integerValue];
    }

}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"hotels"]) {
        self.hotels = [NSMutableArray array];
        for (NSDictionary *dict in value) {
            HotelsModel *model = [[HotelsModel alloc] init];
            model = [[HotelsModel alloc] initWithDict:dict];
            [self.hotels addObject:model];
        }
    }else if ([key isEqualToString:@"pois"]) {
        self.scenics = [NSMutableArray array];
        for (NSDictionary *dict in value) {
            ScenicModel *model = [[ScenicModel alloc] init];
            model = [[ScenicModel alloc] initWithDict:dict];
            [self.scenics addObject:model];
        }
    }else if ([key isEqualToString:@"traffics"]) {
        self.traffics = [NSMutableArray array];
        for (NSDictionary *dict in value) {
            TrafficsModel *model = [[TrafficsModel alloc] init];
            model = [[TrafficsModel alloc] initWithDict:dict];
            [self.traffics addObject:model];
        }
    }else if ([key isEqualToString:@"citys"]) {
        self.citys = [NSMutableArray array];
        for (NSDictionary *dict in value) {
            CityModel *model = [[CityModel alloc] init];
            model = [[CityModel alloc] initWithDict:dict];
            [self.citys addObject:model];
        }
    }
}

@end
