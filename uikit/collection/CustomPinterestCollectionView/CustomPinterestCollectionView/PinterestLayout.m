//
//  PinterestLayout.m
//  CustomPinterestCollectionView
//
//  Created by Zhen Gong on 9/30/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "PinterestLayout.h"

@interface PinterestLayout()

@property(readonly, assign) NSUInteger numberOfColumns;
@property(readonly, assign) NSUInteger cellPadding;
@property(readwrite, assign) CGFloat contentHeight;
@property(readwrite, assign) CGFloat contentWidth;
@property(readonly, nonatomic) NSArray<UICollectionViewLayoutAttributes *> *cache;
@end

@implementation PinterestLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (void)prepareLayout {
    [super prepareLayout];
    
    if (self.cache.count != 0 || !self.collectionView) {
        return;
    }
    _numberOfColumns = 2;
    _cellPadding = 6;
    UIEdgeInsets insets = self.collectionView.contentInset;
    self.contentWidth = self.collectionView.bounds.size.width - (insets.left + insets.right);
    NSMutableArray<UICollectionViewLayoutAttributes *> *mutCache = [NSMutableArray array];
    CGFloat columnWidth = self.contentWidth / (CGFloat)self.numberOfColumns;
    NSMutableArray<NSNumber *> *xOffset = [NSMutableArray array];
    for (NSInteger i = 0; i < self.numberOfColumns; i++) {
        [xOffset addObject:[NSNumber numberWithFloat:((CGFloat)i * columnWidth)]];
    }
    
    int column = 0;
    NSMutableArray<NSNumber *> *yOffset = [NSMutableArray arrayWithCapacity:self.numberOfColumns];
    for (int i = 0; i < self.numberOfColumns; i++) {
        [yOffset addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:0]; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        CGFloat photoHeight = 0.f;
        if ([self.delegate respondsToSelector:@selector(collectionView:heightForPhotoAtIndexPath:)]) {
            photoHeight = [self.delegate collectionView:self.collectionView heightForPhotoAtIndexPath:indexPath];
        }
        CGFloat height = _cellPadding * 2 + photoHeight;
        CGRect frame = CGRectMake([xOffset objectAtIndex:column].floatValue, [yOffset objectAtIndex:column].floatValue, columnWidth, height);
        CGRect insetFrame = CGRectInset(frame, _cellPadding, _cellPadding);
        
        UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = insetFrame;
        [mutCache addObject:attributes];
        
        self.contentHeight = MAX(self.contentHeight, CGRectGetMaxY(frame));
        CGFloat yOffsetValue = [yOffset objectAtIndex:column].floatValue;
        [yOffset setObject:[NSNumber numberWithFloat:yOffsetValue + height] atIndexedSubscript:column];
        column = column < (_numberOfColumns - 1) ? (column + 1) : 0;
    }
    _cache = [mutCache copy];
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray <UICollectionViewLayoutAttributes *> *visibleLayoutAttributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in self.cache) {
        if (attributes && CGRectIntersectsRect(attributes.frame, rect)) {
            [visibleLayoutAttributes addObject:attributes];
        }
    }
    return [visibleLayoutAttributes copy];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cache.count == 0 || self.cache.count > indexPath.item) {
        return nil;
    }
    return [self.cache objectAtIndex:indexPath.item];
}

@end
