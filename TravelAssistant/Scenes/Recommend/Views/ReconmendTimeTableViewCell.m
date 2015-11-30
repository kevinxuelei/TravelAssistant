//
//  ReconmendTimeTableViewCell.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "ReconmendTimeTableViewCell.h"


@interface ReconmendTimeTableViewCell()

@property (nonatomic, strong) UIImageView *imgIcon; // 交通工具图片
@property (nonatomic, strong) UILabel *fromPlaceLabel; // 出发地
@property (nonatomic, strong) UILabel *toPlaceLabel; // 目的地
@property (nonatomic, strong) UILabel *fromTimeLabel; // 出发时间
@property (nonatomic, strong) UILabel *toTimeLabel; // 到达时间

@end

@implementation ReconmendTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imgIcon = [[UIImageView alloc] init];
        _fromPlaceLabel = [[UILabel alloc] init];
        _toPlaceLabel = [[UILabel alloc] init];
        _fromTimeLabel = [[UILabel alloc] init];
        _toTimeLabel = [[UILabel alloc] init];
    }
    [self.contentView addSubview:_fromPlaceLabel];
    [self.contentView addSubview:_imgIcon];
    [self.contentView addSubview:_fromTimeLabel];
    [self.contentView addSubview:_toTimeLabel];
    [self.contentView addSubview:_toPlaceLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgIcon.frame = CGRectMake(5, (self.frame.size.height - 20) / 2, 20, 20);
//    self.imgIcon.backgroundColor = [UIColor redColor];
    self.imgIcon.layer.cornerRadius = self.imgIcon.frame.size.width / 2;
    self.imgIcon.layer.masksToBounds = YES;
    
    self.fromPlaceLabel.frame = CGRectMake(CGRectGetMaxX(self.imgIcon.frame) + 5, (self.frame.size.height - 40) / 2, 80, 20);
//    self.fromPlaceLabel.backgroundColor = [UIColor yellowColor];
    
    self.toPlaceLabel.frame = CGRectMake(CGRectGetMaxX(self.imgIcon.frame) + 5, CGRectGetMaxY(self.fromPlaceLabel.frame) + 5, 80, 20);
//    self.toPlaceLabel.backgroundColor = [UIColor redColor];
    
    self.fromTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.fromPlaceLabel.frame) + 5, (self.frame.size.height - 40) / 2, 60, 20);
//    self.fromPlaceLabel.backgroundColor = [UIColor yellowColor];
    
    self.toTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.toPlaceLabel.frame) + 5, CGRectGetMaxY(self.fromTimeLabel.frame) + 5, 60, 20);
//    self.toTimeLabel.backgroundColor = [UIColor yellowColor];
}



- (void)setModel:(TrafficsModel *)model {
    
    _model = model;
    self.imgIcon.image = [UIImage imageNamed:@"feiji"];
    self.fromPlaceLabel.text = model.fromplace;
    self.toPlaceLabel.text = model.toplace;
    if (model.starthours == -1 && model.startminutes == -1) {
        self.fromTimeLabel.text = @"--:--";
    }else if (model.starthours != -1 && model.startminutes == -1){
        self.fromTimeLabel.text = [NSString stringWithFormat:@"%ld:00",(long)model.starthours];
    }else {
        self.fromTimeLabel.text = [NSString stringWithFormat:@"%ld:%ld",(long)model.starthours,(long)model.startminutes];
    }
    
    
    if (model.endhours == -1) {
        self.toTimeLabel.text = @"--:--";
    }else if (model.endhours != -1 && model.endminutes == -1) {
        self.toTimeLabel.text = [NSString stringWithFormat:@"%ld:00",(long)model.endhours];
    }else {
        self.toTimeLabel.text = [NSString stringWithFormat:@"%ld:%ld",(long)model.endhours,model.endminutes];
    
    }
}











@end
