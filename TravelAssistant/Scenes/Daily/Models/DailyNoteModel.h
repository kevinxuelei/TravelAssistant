//
//  DailyNoteModel.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyNoteModel : NSObject

@property (nonatomic, assign) NSInteger noteId;
@property (nonatomic, assign) NSInteger pid;    // 笔记id
@property (nonatomic, copy) NSString *message;  // 笔记内容

@end
