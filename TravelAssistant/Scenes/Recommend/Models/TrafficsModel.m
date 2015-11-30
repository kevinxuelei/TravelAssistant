//
//  TrafficsModel.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "TrafficsModel.h"

@implementation TrafficsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)TrafficsModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
