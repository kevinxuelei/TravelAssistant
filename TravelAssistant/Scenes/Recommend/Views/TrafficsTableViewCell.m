//
//  TrafficsTableViewCell.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "TrafficsTableViewCell.h"
@interface TrafficsTableViewCell()
@end

@implementation TrafficsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftLabel = [[UILabel alloc] init];
        _rightLabel = [[UILabel alloc] init];
        
    }
    [self.contentView addSubview:_rightLabel];
    [self.contentView addSubview:_leftLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _leftLabel.frame = CGRectMake(10, 10, 80, 20);
//    self.leftLabel.backgroundColor = [UIColor redColor];
    
    _rightLabel.frame = CGRectMake(self.frame.size.width - 240, 10,220, 20);
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.font = [UIFont systemFontOfSize:14];
//    self.rightLabel.backgroundColor = [UIColor yellowColor];
}






@end
