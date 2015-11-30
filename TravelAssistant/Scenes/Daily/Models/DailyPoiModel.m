//
//  DailyPoiModel.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DailyPoiModel.h"
#import "CommentModel.h"

@implementation DailyPoiModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _pid = [value integerValue];
    } else if ([key isEqualToString:@"pic_big"]) {
        [_piclistArr insertObject:value atIndex:0];
    } else if ([key isEqualToString:@"piclist"]) {
        [_piclistArr addObjectsFromArray:value];
    } else if ([key isEqualToString:@"catename"]) {
        [_tagNames insertObject:value atIndex:0];
    } else if ([key isEqualToString:@"tagnames"]) {
        [_tagNames addObjectsFromArray:value];
    }
    if ([key isEqualToString:@"comments"]) {
        NSArray *arr = value;
        for (NSDictionary *dic in arr) {
            CommentModel *model = [[CommentModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_commentArr addObject:model];
        }
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _piclistArr = [NSMutableArray array];
        _commentArr = [NSMutableArray array];
        _tagNames = [NSMutableArray array];
    }
    return self;
}

@end
