//
//  HeaderScrollView.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/18.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "HeaderScrollView.h"
#import "DailyPoiModel.h"
#import "Macros.h"
#import <UIImageView+WebCache.h>

#define kImgArrCount self.imageArray.count

@interface HeaderScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger flag;

@end

@implementation HeaderScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
// 重写seeter方法
- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    [self loadScrollView];
    [self loadImageView];
    if (imageArray.count > 1) {
        [self loadTimer];
        [self loadPageControl];
    }
}
// 加载scrollView
- (void)loadScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kVwidth, KVheight)];
    self.scrollView.contentSize = CGSizeMake(kVwidth * kImgArrCount, KVheight);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
}
// 加载图片
- (void)loadImageView
{
    for (int i = 0; i < kImgArrCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kVwidth * i, 0, kVwidth, KVheight)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
        [self.scrollView addSubview:imageView];
    }
}
// 加载pageControl
- (void)loadPageControl
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kVwidth - 100, KVheight - 40, 100, 40)];
    self.pageControl.numberOfPages = kImgArrCount;
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    UIView *view = [[UIView alloc] initWithFrame:self.pageControl.frame];
    [self addSubview:view];
}
// 加载timer
- (void)loadTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    //增加优先级 为了避免线程阻塞
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
// 移除timer
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
// timer执行方法
- (void)nextImage
{
    self.flag = self.scrollView.contentOffset.x / kVwidth;
    if (self.flag < kImgArrCount - 1) {
        self.flag++;
    } else {
        self.flag = 0;
    }
    [self.scrollView setContentOffset:CGPointMake(kVwidth * self.flag, 0) animated:YES];;
}

// scrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.flag == scrollView.contentOffset.x / kVwidth) {
        self.pageControl.currentPage = self.scrollView.contentOffset.x / kVwidth + 0.5;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.flag = scrollView.contentOffset.x / kVwidth;
    self.pageControl.currentPage = self.flag;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 在手动拖拽时移除timer
    [self removeTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 在拖拽结束时再加载timer
    [self loadTimer];
}



@end
