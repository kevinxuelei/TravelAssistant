//
//  DataForServer.h
//  HelloFriends
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MyBlock)(NSArray *arr);

@interface DataForServer : NSObject

+ (instancetype)shareDataForServer;

#pragma mark ------ 在服务器上存字典
- (void)saveDataWithUser:(NSDictionary *)dataDic;

#pragma mark ------ 获取用户收藏的所有字典
- (void)getArray:(MyBlock)block;

#pragma mark ------ 更新字典内容
- (void)updateForArray:(NSString *)objectId
                  data:(NSDictionary *)dataDic;

#pragma mark ------ 删除字典      
//参数dataDic是getArray中获取的字典
- (void)deleteForServer:(NSString *)objectId;

@end
