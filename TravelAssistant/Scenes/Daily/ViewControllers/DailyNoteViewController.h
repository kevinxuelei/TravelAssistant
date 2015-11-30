//
//  DailyNoteViewController.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DailyNoteModel;

typedef void(^DailyNoteBlock)(DailyNoteModel *);

@interface DailyNoteViewController : UIViewController

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, assign) BOOL is_Create;

@property (nonatomic, strong) DailyNoteModel *model;

@property (nonatomic, copy) DailyNoteBlock block;

@end
