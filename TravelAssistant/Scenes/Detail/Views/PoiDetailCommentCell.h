//
//  PoiDetailCommentCell.h
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentModel;

@interface PoiDetailCommentCell : UITableViewCell

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, strong) CommentModel *model;

@end
