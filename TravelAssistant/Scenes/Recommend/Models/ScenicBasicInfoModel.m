//
//  ScenicBasicInfoModel.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "ScenicBasicInfoModel.h"
#import "CommentModel.h"

@implementation ScenicBasicInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _pid = [value integerValue];
    } else if ([key isEqualToString:@"pic"]) {
        _pic = value;
        [_piclist insertObject:value atIndex:0];
    } else if ([key isEqualToString:@"piclist"]) {
        [_piclist addObjectsFromArray:value];
    } else if ([key isEqualToString:@"catename"]) {
        [_tagNames insertObject:value atIndex:0];
    } else if ([key isEqualToString:@"tagnames"]) {
        [_tagNames addObjectsFromArray:value];
    } else if ([key isEqualToString:@"comments"]) {
        NSArray *arr = value;
        for (NSDictionary *dic in arr) {
            CommentModel *model = [[CommentModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_comments addObject:model];
        }
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _piclist = [NSMutableArray array];
        _comments = [NSMutableArray array];
        _tagNames = [NSMutableArray array];
    }
    return self;
}



@end
