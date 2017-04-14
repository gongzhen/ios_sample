//
//  CustomCollectionLayout.m
//  UICollectionViewFlowlayout1
//
//  Created by gongzhen on 4/11/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "CustomCollectionLayout.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CustomCollectionLayout()

@property (assign, nonatomic) CGFloat leftY; // 左侧起始Y轴
@property (assign, nonatomic) CGFloat rightY; // 右侧起始Y轴
@property (assign, nonatomic) NSInteger cellCount; // cell个数
@property (assign, nonatomic) CGFloat itemWidth; // cell宽度
@property (assign, nonatomic) CGFloat cellPadding;
@property (assign, nonatomic) NSInteger numberOfColumns;
@property (strong, nonatomic) NSMutableArray *cache;
@property (assign, nonatomic) NSInteger contentHeight;
@property (assign, nonatomic) NSInteger contentWidth;

@end

@implementation CustomCollectionLayout

-(void)prepareLayout {
    [super prepareLayout];
    
    // 初始化参数
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    _numberOfColumns = 2;
    _cellPadding = 10;
    _contentHeight = 0.f;
    UIEdgeInsets insets = self.collectionView.contentInset;
    _contentWidth = self.collectionView.bounds.size.width - (insets.left + insets.right);
    
    if([self.cache count] == 0) {
        _cache = [NSMutableArray new];
        CGFloat columnWidth = (CGFloat)_contentWidth / _numberOfColumns;
        NSMutableArray *xOffset = [[NSMutableArray alloc] init];
        for(int i = 0; i < _numberOfColumns; i++) {
            [xOffset addObject:@(i * columnWidth)];
        }
        
        NSMutableArray *yOffset = [[NSMutableArray alloc] init];
        for(int i = 0; i < _numberOfColumns; i++) {
            [yOffset addObject:@(0)];
        }
        
        int column = 0;
        
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            CGSize itemSize = [self.delegate collectionView:self.collectionView collectionViewLayout:self sizeOfItemAtIndexPath:indexPath];
            CGFloat height = _cellPadding * 2 + itemSize.height;
            CGRect frame = CGRectMake([xOffset[column] floatValue], [yOffset[column] floatValue], columnWidth, height);
            CGRect insetFrame = CGRectInset(frame, _cellPadding, _cellPadding);
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = insetFrame;
            [_cache addObject:attributes];
            _contentHeight = MAX(_contentHeight, CGRectGetMaxY(frame));
            [yOffset setObject:@([yOffset[column] floatValue] + height) atIndexedSubscript:column];
            column = (column >= (_numberOfColumns - 1)) ? 0 : column + 1;
        }
    }
}

-(CGSize)collectionViewContentSize {
    return CGSizeMake(_contentWidth, _contentHeight);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.cache count]; i++) {
        UICollectionViewLayoutAttributes *attributes = (UICollectionViewLayoutAttributes *)self.cache[i];
        if(CGRectIntersectsRect(attributes.frame, rect) == YES) {
            [layoutAttributes addObject:attributes];
        }
    }
    return layoutAttributes;
}

@end
