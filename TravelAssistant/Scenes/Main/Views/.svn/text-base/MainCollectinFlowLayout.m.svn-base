//
//  MainCollectinFlowLayout.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "MainCollectinFlowLayout.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define ITEM_WIDTH kScreenWidth*0.6
#define ITEM_HEIGHT kScreenHeight*0.55

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

@implementation MainCollectinFlowLayout

-(id)init {
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, (kScreenWidth - ITEM_WIDTH) / 2, 60, (kScreenWidth - ITEM_WIDTH) / 2);
        self.minimumLineSpacing = 50;
    }
    return self;
}

// 刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    [super shouldInvalidateLayoutForBoundsChange:oldBounds];
    return YES;
}

// 当前item放大
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    // 遍历array中所有的UICollectionViewLayoutAttributes
    for (UICollectionViewLayoutAttributes *attributes in array) {
        
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}


@end
