//
//  CommentModel.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"user"]) {
        NSDictionary *dic = value;
        _username = dic[@"username"];
        _avatar = dic[@"avatar"];
    }
}

@end
