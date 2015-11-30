//
//  CommentModel.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, assign) NSInteger commentId; // 评论id
@property (nonatomic, assign) NSInteger datetime;  // 评论时间
@property (nonatomic, copy) NSString *comment;     // 评论内容
@property (nonatomic, copy) NSString *username;    // 评论者
@property (nonatomic, copy) NSString *avatar;      // 评论者头像

@end
