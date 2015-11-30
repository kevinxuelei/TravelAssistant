//
//  CityViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/23.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "CityViewController.h"
#import "MapHelper.h"
#import "Macros.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface CityViewController ()<MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) UILabel *beentocountsLabel;
@property (nonatomic, assign) NSInteger counts;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *intro;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
    
    [self requestCityDetailDataWithCityId:self.cityId Latitude:[[MapHelper sharedMapHelper] getLatitudeWithCurrentPosition] Longitude:[[MapHelper sharedMapHelper] getLongitudeWithCurrentPosition]];
    
}
#pragma mark--- navigationBar点击方法
// pop回城市选择页面
- (void)didClickedLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--- 请求城市信息
- (void)requestCityDetailDataWithCityId:(NSInteger)cityId Latitude:(CGFloat)latitude Longitude:(CGFloat)longitude
{
    // 请求数据的时候显示菊花
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor lightGrayColor];
    
    NSString *urlString = [[NSString stringWithFormat:@"http://open.qyer.com/plan/city/detail?app_installtime=1447226744&client_id=qyer_planner_ios&client_secret=e24e75dbf6fa3c49651f&id=%ld&ip=172.21.60.74&lat=%f&lon=%f&oauth_token=638efcf04dddd20d171f8e8a1632c230&timestamp=1448070915&track_app_channel=App Store&track_app_version=1.4.5&track_device_info=iPhone 5s&track_deviceid=E928D450-E7D0-4E20-939E-1FCCF0742DB3&track_os=ios 9.1&track_user_id=7010389&v=1", cityId, latitude, longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"%@", urlString);
    __weak typeof(self) pSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *d1 = responseObject[@"data"];
        pSelf.intro = d1[@"intro"];
        pSelf.pic = d1[@"photo_big"];
        pSelf.counts = [d1[@"beentocounts"] integerValue];
        [pSelf hudWasHidden:pSelf.hud];
        [pSelf loadSubViews];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [pSelf hudWasHidden:pSelf.hud];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, KVCheight)];
        label.text = @"请求数据失败";
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }];
    
}
#pragma mark--- 加载城市图片View，和简介View
- (void)loadSubViews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, KVCheight)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, kVCwidth * 0.66)];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.pic] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [self.scrollView addSubview:self.headerImageView];
    
    self.beentocountsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kVCwidth * 0.66 - 30, kVCwidth / 2, 20)];
    self.beentocountsLabel.textColor = [UIColor whiteColor];
    self.beentocountsLabel.text = [NSString stringWithFormat:@"%ld人去过", self.counts];
    self.beentocountsLabel.font = [UIFont systemFontOfSize:14];
    self.beentocountsLabel.textAlignment = NSTextAlignmentLeft;
    [self.headerImageView addSubview:self.beentocountsLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerImageView.frame), kVCwidth, 30)];
    label.text = @"- 简介 -";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:label];
    
    self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame), kVCwidth - 40, [self stringHeightWithString:self.intro fontSize:14 contentSize:CGSizeMake(kVCwidth - 40, 10000)])];
    self.introLabel.numberOfLines = 0;
    self.introLabel.textColor = [UIColor grayColor];
    self.introLabel.font = [UIFont systemFontOfSize:14];
    self.introLabel.text = self.intro;
    [self.scrollView addSubview:self.introLabel];
    
    self.scrollView.contentSize = CGSizeMake(kVCwidth, kVCwidth * 0.66 + 80 + CGRectGetHeight(self.introLabel.frame));
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
#pragma mark--- 
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
