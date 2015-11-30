//
//  DestinationViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/21.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DestinationViewController.h"
#import "MakeSureViewController.h"
#import "DestinationCityModel.h"
#import "DestinationCityCell.h"
#import "CityViewController.h"
#import "SelectedCityCell.h"
#import "ContinentModel.h"
#import "CountryModel.h"
#import "CountryCell.h"
#import "NumberView.h"
#import "Macros.h"
#import "MapHelper.h"
#import "DropdownMenu.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>

#define kItemWidth kVCwidth / 3 - 1

@interface DestinationViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, DropdownDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NumberView *numberView; // 步骤View
@property (nonatomic, strong) UICollectionView *collectionView; // 默认展示热门国家地区
@property (nonatomic, strong) UICollectionView *selectCollectionView; // 被选择的城市cell
@property (nonatomic, strong) UITableView *cityTableView; // 城市tableView
@property (nonatomic, strong) NSMutableArray *hotCountryArray; // 热门地区数组
@property (nonatomic, strong) NSMutableArray *continentArray;  // 所有大洲
@property (nonatomic, strong) NSMutableArray *cityArray;       // 国家或地区所含城市
@property (nonatomic, strong) NSMutableArray *selectArray;     // 被选择的城市
@property (nonatomic, strong) DropdownMenu *dropdown; // 下拉选择国家地区栏

@end

@implementation DestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-push"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedRightBarButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.title = @"选择目的地";
    // 当没有选择城市时，不能跳转到下一页
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // 初始化被选择的城市数组
    self.selectArray = [NSMutableArray array];
    // 加载步骤view
    [self loadNumberView];
    // 加载collectionView
    [self loadCollectionView];
    [self loadSelectedCityCollectionView];
    // 请求数据
    [self requestCountryDataWithLatitude:[[MapHelper sharedMapHelper] getLatitudeWithCurrentPosition] Longitude:[[MapHelper sharedMapHelper] getLongitudeWithCurrentPosition]];
}
#pragma mark--- navigationBar点击方法
// pop回出发日期选择页面
- (void)didClickedLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
// show到确认添加页面
- (void)didClickedRightBarButton
{
    // 给每个城市赋值，到达时间和离开时间
    for (int i = 0; i < self.selectArray.count; i++) {
        DestinationCityModel *model = self.selectArray[i];
        if (i == 0) {
            model.start_time = self.date;
            model.end_time = [self.date dateByAddingTimeInterval:model.recommend_days*24*60*60];
        } else {
            model.start_time = [self.selectArray[i - 1] end_time];
            model.end_time = [model.start_time dateByAddingTimeInterval:model.recommend_days*24*60*60];
        }
//        NSLog(@"start===%@   end===%@", model.start_time, model.end_time);
    }
    MakeSureViewController *msVC =[[MakeSureViewController alloc] init];
    msVC.date = self.date;
    msVC.userId = self.userId;
    msVC.cityArray = self.selectArray;
    __weak typeof(self) pSelf = self;
    msVC.block = ^() {
        pSelf.block();
    };
    [self.navigationController showViewController:msVC sender:self];
}

#pragma mark--- 加载步骤view
- (void)loadNumberView
{
    self.numberView = [[NumberView alloc] initWithFrame:CGRectMake(0, 0, kVCwidth, 5)];
    self.numberView.index = 2;
    [self.view addSubview:self.numberView];
}

#pragma mark--- 请求country数据
- (void)requestCountryDataWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude
{
    // 请求数据的时候显示菊花
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor lightGrayColor];
    self.hud.delegate = self;
    // 拼接网址，并转码
    NSString *urlString = [[NSString stringWithFormat:@"http://open.qyer.com/plan/country/list?app_installtime=1447226744&client_id=qyer_planner_ios&client_secret=e24e75dbf6fa3c49651f&ip=172.21.60.74&lat=%f&lon=%f&oauth_token=638efcf04dddd20d171f8e8a1632c230&timestamp=1448070645&track_app_channel=App Store&track_app_version=1.4.5&track_device_info=iPhone 5s&track_deviceid=E928D450-E7D0-4E20-939E-1FCCF0742DB3&track_os=ios 9.1&track_user_id=&v=1", latitude, longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    typeof(self) pSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        pSelf.hotCountryArray = [NSMutableArray array];
        
        NSDictionary *d1 = responseObject[@"data"];
        NSArray *a1 = d1[@"hot"];
        for (NSDictionary *dic in a1) {
            CountryModel *model = [[CountryModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [pSelf.hotCountryArray addObject:model];
        }
        NSArray *a2 = d1[@"continent"];
        pSelf.continentArray = [NSMutableArray array];
        for (NSDictionary *dic in a2) {
            ContinentModel *model = [[ContinentModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [pSelf.continentArray addObject:model];
        }
        [[pSelf.continentArray[0] countryArray] insertObject:pSelf.hotCountryArray.firstObject atIndex:0];
        
        ContinentModel *model = [[ContinentModel alloc] init];
        model.cn_name = @"热门";
        CountryModel *m = [[CountryModel alloc] init];
        m.cn_name = @"查看热门地区";
        model.countryArray = [NSMutableArray arrayWithObjects:m, nil];
        [pSelf.continentArray insertObject:model atIndex:0];
        
        NSArray *titleArray = @[@"热门"];
        NSArray *leftArray = [NSArray arrayWithObjects:pSelf.continentArray, nil];
        NSArray *rightArray = [NSArray arrayWithObjects:pSelf.continentArray, nil];
        pSelf.dropdown = [[DropdownMenu alloc] initDropdownWithButtonTitles:titleArray andLeftListArray:leftArray andRightListArray:rightArray];
        pSelf.dropdown.delegate = pSelf;   //此句的代理方法可返回选中下标值
        [pSelf.view addSubview:pSelf.dropdown.view];
        [pSelf.view bringSubviewToFront:pSelf.dropdown.view];
        [pSelf.view bringSubviewToFront:pSelf.numberView];
        
        [pSelf.collectionView reloadData];
        [pSelf hudWasHidden:pSelf.hud];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [pSelf hudWasHidden:pSelf.hud];
        
    }];
}
#pragma mark--- 加载热门国家地区collectionView，及代理方法
- (void)loadCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1.5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, kVCwidth, KVCheight - 109) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[CountryCell class] forCellWithReuseIdentifier:@"CountryCell"];
}
#pragma mark--- 加载被选择的城市collectionView
- (void)loadSelectedCityCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80, 30);
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 20);
    
    self.selectCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KVCheight, kVCwidth, 50) collectionViewLayout:layout];
    self.selectCollectionView.backgroundColor = [UIColor whiteColor];
    self.selectCollectionView.delegate = self;
    self.selectCollectionView.dataSource = self;
    [self.view addSubview:self.selectCollectionView];
    [self.selectCollectionView registerClass:[SelectedCityCell class] forCellWithReuseIdentifier:@"SelectedCityCell"];
}
// collectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionView]) {
        // 热门国家地区
        return self.hotCountryArray.count;
    }
    // 被选择的城市
    return self.selectArray.count;
}
// collectionViewCell的样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        // 热门国家地区cell
        CountryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CountryCell" forIndexPath:indexPath];
        cell.model = self.hotCountryArray[indexPath.row];
        return cell;
    }
    // 被选择的城市cell
    SelectedCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectedCityCell" forIndexPath:indexPath];
    cell.row = indexPath.row;
    cell.model = self.selectArray[indexPath.row];
    __weak typeof(self) pSelf = self;
    cell.block = ^(NSInteger index){
        // 删除城市
        [pSelf.selectArray removeObjectAtIndex:index];
        [pSelf.selectCollectionView reloadData];
        if (pSelf.selectArray.count == 0) {
            pSelf.navigationItem.rightBarButtonItem.enabled = NO;
            
            CGRect cf = pSelf.collectionView.frame;
            cf.size.height += 50;
            pSelf.collectionView.frame = cf;
            
            CGRect tf = pSelf.cityTableView.frame;
            tf.size.height += 50;
            pSelf.cityTableView.frame = tf;
            
            CGRect sf = pSelf.selectCollectionView.frame;
            sf.origin.y = cf.size.height + cf.origin.y;
            pSelf.selectCollectionView.frame = sf;
        }
    };
    return cell;
}
// collectionViewCell的点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        // 热门collectionView
        [self.collectionView removeFromSuperview];
        NSInteger first = 0;
        NSInteger second = 0;
        for (int i = 0; i < self.continentArray.count; i++) {
            NSMutableArray *array = [self.continentArray[i] countryArray];
            for (int j = 0; j < array.count; j++) {
                if ([array[j] countryId] == [self.hotCountryArray[indexPath.row] countryId]) {
                    first = i;
                    second = j;
                }
            }
        }
        [self.dropdown selectedFirstValue:[NSString stringWithFormat:@"%ld", first] SecondValue:[NSString stringWithFormat:@"%ld", second]];
        [self.dropdown setButtonTitleWithTitleString:[self.hotCountryArray[indexPath.row] cn_name]];
    }
}
// 在点击collectionView的cell后，更改liftNavigationItem的点击方法
- (void)changeLeftNavigationItem
{
    [self.dropdown selectedFirstValue:@"0" SecondValue:@"0"];
    [self.dropdown setButtonTitleWithTitleString:@"热门"];
    
    self.navigationItem.leftBarButtonItem.action = @selector(didClickedLeftBarButton);
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:self.dropdown.view];
    [self.view bringSubviewToFront:self.numberView];
}

#pragma mark--- 请求城市数据
- (void)requestCityDataWithCountryId:(NSInteger)countyId Latitude:(CGFloat)latitude Longitude:(CGFloat)longitude
{
    // 请求数据的时候显示菊花
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor lightGrayColor];
    self.hud.delegate = self;
    // 拼接网址，并转码
    NSString *urlString = [[NSString stringWithFormat:@"http://open.qyer.com/plan/city/list?app_installtime=1447226744&client_id=qyer_planner_ios&client_secret=e24e75dbf6fa3c49651f&country_id=%ld&ip=172.21.60.74&lat=%f&lon=%f&oauth_token=638efcf04dddd20d171f8e8a1632c230&page=1&pagesize=100&timestamp=1448070877&track_app_channel=App Store&track_app_version=1.4.5&track_device_info=iPhone 5s&track_deviceid=E928D450-E7D0-4E20-939E-1FCCF0742DB3&track_os=ios 9.1&track_user_id=&v=1", countyId, latitude, longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"%@", urlString);
    typeof(self)pSelf = self;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    [maneger GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        pSelf.cityArray = [NSMutableArray array];
        
        NSDictionary *d1 = responseObject[@"data"];
        NSArray *arr = d1[@"citys"];
        for (NSDictionary *dic in arr) {
            DestinationCityModel *model = [[DestinationCityModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [pSelf.cityArray addObject:model];
        }
        
        [pSelf loadTableView];
        pSelf.navigationItem.leftBarButtonItem.action = @selector(changeLeftNavigationItem);
        [pSelf.view bringSubviewToFront:pSelf.dropdown.view];
        [pSelf.view bringSubviewToFront:pSelf.numberView];
        [pSelf hudWasHidden:pSelf.hud];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [pSelf hudWasHidden:pSelf.hud];
    }];
}
#pragma mark--- 加载cityTableView，及代理方法
- (void)loadTableView
{
    if (self.selectArray.count == 0) {
        self.cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, kVCwidth, KVCheight - 45) style:UITableViewStylePlain];
    } else {
        self.cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, kVCwidth, KVCheight - 95) style:UITableViewStylePlain];
    }
    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    self.cityTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.cityTableView];
    [self.cityTableView registerClass:[DestinationCityCell class] forCellReuseIdentifier:@"DestinationCityCell"];
}
// 城市cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityArray.count;
}
// 城市cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DestinationCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DestinationCityCell" forIndexPath:indexPath];
    cell.model = self.cityArray[indexPath.row];
    __weak typeof(self) pSelf = self;
    cell.block = ^(DestinationCityModel *model) {
        // 添加城市
        if (pSelf.selectArray.count == 0) {
            CGRect cf = pSelf.collectionView.frame;
            cf.size.height -= 50;
            pSelf.collectionView.frame = cf;
            
            CGRect tf = pSelf.cityTableView.frame;
            tf.size.height -= 50;
            pSelf.cityTableView.frame = tf;
            
            CGRect sf = pSelf.selectCollectionView.frame;
            sf.origin.y = cf.size.height + cf.origin.y;
            pSelf.selectCollectionView.frame = sf;
            
            pSelf .navigationItem.rightBarButtonItem.enabled = YES;
        }
        [pSelf.selectArray addObject:model];
        [pSelf.selectCollectionView reloadData];
    };
    return cell;
}
// 城市cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
// 城市cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CityViewController *cityVC = [[CityViewController alloc] init];
    cityVC.cityId = [self.cityArray[indexPath.row] cityId];
    cityVC.title = [self.cityArray[indexPath.row] cn_name];
    [self.navigationController showViewController:cityVC sender:self];
}

#pragma mark--- MBPrograssDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}
#pragma mark--- DropdownDelegate，下拉菜单栏代理方法
- (void)DropdownSelectedLeftIndex:(NSString *)left RightIndex:(NSString *)right
{
    [self.cityTableView removeFromSuperview];
    self.cityTableView = nil;
//    NSLog(@"%@, %@", left, right);
    if ([left isEqualToString:@"0"] && [right isEqualToString:@"0"]) {
        [self.view addSubview:self.collectionView];
        [self.view bringSubviewToFront:self.dropdown.view];
        [self.view bringSubviewToFront:self.numberView];
    } else {
        [self.collectionView removeFromSuperview];
        NSMutableArray *countryArr = [self.continentArray[[left integerValue]] countryArray];
        [self.dropdown setButtonTitleWithTitleString:[countryArr[[right integerValue]] cn_name]];
        [self requestCityDataWithCountryId:[countryArr[[right integerValue]] countryId] Latitude:[[MapHelper sharedMapHelper] getLatitudeWithCurrentPosition] Longitude:[[MapHelper sharedMapHelper] getLongitudeWithCurrentPosition]];
    }
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
