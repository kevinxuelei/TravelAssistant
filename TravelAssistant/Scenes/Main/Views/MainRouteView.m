//
//  MainRouteView.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MainRouteView.h"
#import "MainCollectinFlowLayout.h"
#import "MainCollectionCell.h"
#import "MainAddRouteCell.h"
#import "MainRouteModel.h"
#import "Macros.h"
#import "MapHelper.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "DataForServer.h"

@interface MainRouteView ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat latitude;  // 纬度
@property (nonatomic, assign) CGFloat longitude; // 经度
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) NSInteger times;

@end

@implementation MainRouteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.times = 0;
        MainCollectinFlowLayout *layout = [[MainCollectinFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[MainCollectionCell class] forCellWithReuseIdentifier:@"MainCollectionCell"];
        [self.collectionView registerClass:[MainAddRouteCell class] forCellWithReuseIdentifier:@"MainAddRouteCell"];
    }
    return self;
}
- (void)setUser_id:(NSString *)user_id
{
    _user_id = user_id;
    [self loadNewData];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = [UIScreen mainScreen].bounds;
}
#pragma mark--- 请求数据
- (void)loadNewData
{
    self.times++;
    // 请求数据的时候显示菊花
    self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.hud.color = [UIColor lightGrayColor];
    self.hud.delegate = self;
    
    // 从cloud请求数据
    __weak typeof(self) pSelf = self;
    [[DataForServer shareDataForServer] getArray:^(NSArray *arr) {
//        NSLog(@"arr :%@", arr);
//        NSLog(@"%@", [NSDate date]);
        pSelf.times++;
        
        pSelf.dataArray = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            MainRouteModel *model = [[MainRouteModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [pSelf.dataArray addObject:model];
        }
        [pSelf.collectionView reloadData];
        [pSelf hudWasHidden:pSelf.hud];
    }];
}
// 延迟刷新数据
- (void)loadNewDataAfterTimeInterval:(CGFloat)flag
{
    [self performSelector:@selector(loadNewData) withObject:nil afterDelay:flag];
}
#pragma mark--- collectionView代理方法
// cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.times == 1) {
        return self.dataArray.count;
    }
    return self.dataArray.count + 1;
}
// cell的样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        MainAddRouteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainAddRouteCell" forIndexPath:indexPath];
        cell.cellSize = cell.bounds.size;
        return cell;
    }
    if (indexPath.row == self.dataArray.count) {
        MainAddRouteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainAddRouteCell" forIndexPath:indexPath];
        cell.cellSize = cell.bounds.size;
        return cell;
    }
    self.indexPath = indexPath;
    MainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCollectionCell" forIndexPath:indexPath];
    
    cell.layer.masksToBounds = NO; // NO时显示阴影
    cell.layer.contentsScale = [UIScreen mainScreen].scale;
    cell.layer.shadowOpacity = 0.75f;
    cell.layer.shadowRadius = 4.0f;
    cell.layer.shadowOffset = CGSizeMake(0,2);
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
    //设置缓存
    cell.layer.shouldRasterize = YES;
    //设置抗锯齿边缘
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    typeof(cell) pCell = cell; // 重定义，防止循环引用
    typeof(self) pSelf = self;
    cell.reloadBlock = ^() {
        [pSelf loadNewDataAfterTimeInterval:0.5f];
    };
    cell.block = ^() {
        pCell.layer.masksToBounds = YES;
        pCell.layer.shadowOpacity = 0;
        [pSelf performSelector:@selector(changeCellLayer:) withObject:pCell afterDelay:0.97f];
    };
    
    cell.cellSize = cell.bounds.size;
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}
- (void)changeCellLayer:(UICollectionViewCell *)cell
{
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOpacity = 0.75f;
}
// cell的点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.row == self.dataArray.count) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showAddRouteViewController)]) {
            [self.delegate showAddRouteViewController];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showRouteViewControllerWithRow:)] ) {
            [self.delegate showRouteViewControllerWithRow:indexPath.row];
        }
    }

}
#pragma mark--- scrollView代理方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.collectionView]) {
        CGFloat x = self.collectionView.contentOffset.x; // 获取偏移量的x值
        CGFloat index = x / (kVwidth * 0.6 + 50);// 获取当前为第几个cell
        NSInteger integer = index + 0.5;
//        NSLog(@"偏移量的x值:%f；%f；应该移动到第%ld个cell",  x, index, integer);
        [self.collectionView setContentOffset:CGPointMake(integer * (kVwidth * 0.6 + 50), 0) animated:YES];
        
        // 当x向右便宜一定距离时，刷新页面(水平刷新)
        if (x < -80) {
            [self loadNewData];
        }
    }
}

#pragma mark--- 经纬度懒加载
- (CGFloat)latitude
{
    return [[MapHelper sharedMapHelper] getLatitudeWithCurrentPosition];
}
- (CGFloat)longitude
{
    return [[MapHelper sharedMapHelper] getLongitudeWithCurrentPosition];
}
#pragma mark--- MBPrograssHUD代理协议
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}




@end
