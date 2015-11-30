//
//  ScenicBasicInfoTableViewCell.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "ScenicBasicInfoTableViewCell.h"

@interface ScenicBasicInfoTableViewCell()

@property (nonatomic, strong) UILabel *priceLabel; // 门票
@property (nonatomic, strong) UILabel *opentimeLabel; // 开放时间
@property (nonatomic, strong) UILabel *addressLabel; // 到达路线
@property (nonatomic, strong) UILabel *siteLabel; // 网址
@property (nonatomic, strong) UILabel *catenameLabel; // 分类
@property (nonatomic, strong) UILabel *phoneLabel; // 电话



@end

@implementation ScenicBasicInfoTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _priceLabel = [[UILabel alloc] init];
        _opentimeLabel = [[UILabel alloc] init];
        _addressLabel  = [[UILabel alloc] init];
        _siteLabel = [[UILabel alloc] init];
        _catenameLabel = [[UILabel alloc] init];
        _phoneLabel = [[UILabel alloc] init];
        
    }
    [self.contentView addSubview:_priceLabel];
    [self.contentView addSubview:_opentimeLabel];
    [self.contentView addSubview:_addressLabel];
    [self.contentView addSubview:_siteLabel];
    [self.contentView addSubview:_catenameLabel];
    [self.contentView addSubview:_phoneLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _priceLabel.frame = CGRectMake(10, 10, self.frame.size.width - 20, [self stringHeightWithString:self.scenicBasicModel.price fontSize:14 contentSize:CGSizeMake(self.frame.size.width - 10, 2000)]);
    _priceLabel.textColor = [UIColor grayColor];
    _priceLabel.numberOfLines = 0;
    [_priceLabel sizeToFit];
    
    _opentimeLabel.frame = CGRectMake(10, CGRectGetMaxY(self.priceLabel.frame), self.frame.size.width - 20, [self stringHeightWithString:self.scenicBasicModel.opentime fontSize:14 contentSize:CGSizeMake(self.frame.size.width - 10, 2000)]);
    _opentimeLabel.textColor = [UIColor grayColor];
    _opentimeLabel.numberOfLines = 0;
    [_opentimeLabel sizeToFit];
    
    _addressLabel.frame = CGRectMake(10, CGRectGetMaxY(self.opentimeLabel.frame), self.frame.size.width - 20, [self stringHeightWithString:self.scenicBasicModel.address fontSize:14 contentSize:CGSizeMake(self.frame.size.width - 10, 2000)]);
    _addressLabel.textColor = [UIColor grayColor];
    _addressLabel.numberOfLines = 0;
    [_addressLabel sizeToFit];
    
    _siteLabel.frame = CGRectMake(10, CGRectGetMaxY(self.addressLabel.frame), self.frame.size.width, [self stringHeightWithString:self.scenicBasicModel.site fontSize:14 contentSize:CGSizeMake(self.frame.size.width - 10, 2000)]);
    _siteLabel.textColor = [UIColor grayColor];
    
    _catenameLabel.frame = CGRectMake(10, CGRectGetMaxY(self.siteLabel.frame), self.frame.size.width, 20);
    _catenameLabel.textColor = [UIColor grayColor];
    
    _phoneLabel.frame = CGRectMake(10, CGRectGetMaxY(self.catenameLabel.frame), self.frame.size.width, 20);
    _phoneLabel.textColor = [UIColor grayColor];

}

- (void)setScenicBasicModel:(ScenicBasicInfoModel *)scenicBasicModel {
    _scenicBasicModel = scenicBasicModel;
//    if ([scenicBasicModel.price isEqualToString:@""]) {
//        <#statements#>
//    }
    _priceLabel.text = [NSString stringWithFormat:@"门票： %@",scenicBasicModel.price];
    _opentimeLabel.text = [NSString stringWithFormat:@"时间： %@",scenicBasicModel.opentime];
    _addressLabel.text = [NSString stringWithFormat:@"到达： %@",scenicBasicModel.wayto];
    _siteLabel.text = [NSString stringWithFormat:@"网址 %@",scenicBasicModel.site];
    _catenameLabel.text = [NSString stringWithFormat:@"分类： %@",[scenicBasicModel.tagNames componentsJoinedByString:@","]]; // 拼接
    _phoneLabel.text = [NSString stringWithFormat:@"电话 %@",scenicBasicModel.phone];
    
}



// 在返回每个row的高度时，调用此方法
- (CGFloat)stringHeightWithString:(NSString *)str fontSize:(CGFloat)fontSize contentSize:(CGSize)size
{
    // 第一个参数：代表最大的范围
    // 第二个参数：代表的是 是否考虑字体，是否考虑字号
    // 第三个参数：代表的是是用什么字体什么字号
    // 第四个参数：用不到，所以基本写成nil
    CGRect stringRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return stringRect.size.height;
}








@end
