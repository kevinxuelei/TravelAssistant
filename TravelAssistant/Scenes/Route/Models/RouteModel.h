//
//  RouteModel.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteModel : NSObject

@property (nonatomic, copy) NSString *oneday_id;
@property (nonatomic, strong) NSMutableArray *citysArray;
@property (nonatomic, strong) NSMutableArray *poisArray;

@end
