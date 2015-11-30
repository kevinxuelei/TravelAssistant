//
//  DataForServer.m
//  HelloFriends
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DataForServer.h"
#import <AVObject.h>
#import <AVUser.h>
#import <AVQuery.h>

@implementation DataForServer

+ (instancetype)shareDataForServer{

    static DataForServer *server = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        server = [[DataForServer alloc] init];
    });

    return server;
}

- (void)saveDataWithUser:(NSDictionary *)dataDic{
    
    AVUser *currentUser = [AVUser currentUser];
    
    
    NSString *userName = currentUser.username;
    NSMutableDictionary *diction = [NSMutableDictionary dictionaryWithObjects:@[dataDic,userName] forKeys:@[@"data", @"userName"]];
    
    //存字典
    AVObject *user = [AVObject objectWithClassName:@"SaveData" dictionary:diction];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"ok");
        } else {
        
            NSLog(@"%@",error);
        }
    }];

}

- (void)getArray:(MyBlock)block;{

    AVUser *currentUser = [AVUser currentUser];
    
    NSString *userName = currentUser.username;
    
    //获取数组
    NSMutableArray *arr = [NSMutableArray array];
    AVQuery *query = [AVQuery queryWithClassName:@"SaveData"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        
        for (AVObject *wen in objects) {
            
            NSDictionary *dictionary = [wen dictionaryForObject];
            
            if ([dictionary[@"userName"] isEqualToString:userName]) {
                NSMutableDictionary *datadiction = dictionary[@"data"];
              
                
                [datadiction setObject:wen.objectId forKey:@"objectId"];
                
                [arr addObject:datadiction];
            }
            
        }
        
        block(arr);
        
    }];


}

#pragma mark ------ 更新字典内容
- (void)updateForArray:(NSString *)objectId
                  data:(NSDictionary *)dataDic{
    
    // 知道 objectId，创建 AVObject
    AVObject *post = [AVObject objectWithoutDataWithClassName:@"SaveData" objectId:objectId];
    //更新属性
    [post setObject:dataDic forKey:@"data"];
    
    //保存
    [post saveInBackground];
    
}

- (void)deleteForServer:(NSString *)objectId{
    

    AVObject *user = [AVObject objectWithoutDataWithClassName:@"SaveData" objectId:objectId];
    [user deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];

}

@end
