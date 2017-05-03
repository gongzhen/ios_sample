//
//  CustomCollectionLayout.m
//  UICollectionViewFlowlayout2
//
//  Created by zhen gong on 4/26/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "CustomCollectionLayout.h"

NSString *const CollectionElementKindSectionHeader = @"CollectionElementKindSectionHeader";
NSString *const CollectionElementKindSectionFooter = @"CollectionElementKindSectionFooter";


@interface CustomCollectionLayout()

/// The delegate will point to collection view's delegate automatically.
@property (nonatomic, weak) id <CustomCollectionViewLayoutDelegate> delegate;

/// Array to store height for each column
@property (nonatomic, strong) NSMutableArray *columnHeights;
/// Array of arrays. Each array stores item attributes for each section
@property (nonatomic, strong) NSMutableArray *sectionItemAttributes;
/// Array to store attributes for all items includes headers, cells, and footers
@property (nonatomic, strong) NSMutableArray *allItemAttributes;
/// Dictionary to store section headers' attribute
@property (nonatomic, strong) NSMutableDictionary *headersAttribute;
/// Dictionary to store section footers' attribute
@property (nonatomic, strong) NSMutableDictionary *footersAttribute;
/// Array to store union rectangles
@property (nonatomic, strong) NSMutableArray *unionRects;

@end

@implementation CustomCollectionLayout

/// How many items to be union into a single rectangle
static const NSInteger unionSize = 20;

static CGFloat FloorCGFloat(CGFloat value) {
    CGFloat scale = [UIScreen mainScreen].scale;
    return floor(value * scale) / scale;
}

#pragma mark - Public Accessors

- (void)setColumnCount:(NSInteger) columnCount {
    if(_columnCount != columnCount) {
        _columnCount = columnCount;
        //@test: without invalidateLayout, the view does not change very much.
        [self invalidateLayout];
    }
}

- (void)setMinimumColumnSpacing:(CGFloat) minimumColumnSpacing{
    if(_minimumColumnSpacing != minimumColumnSpacing) {
        _minimumColumnSpacing = minimumColumnSpacing;
        [self invalidateLayout];
    }
}

- (void)setMinimumInteritemSpacing:(CGFloat) minimumInteritemSpacing{
    if(_minimumInteritemSpacing != minimumInteritemSpacing) {
        _minimumInteritemSpacing = minimumInteritemSpacing;
        [self invalidateLayout];
    }
}

- (void)setHeaderHeight:(CGFloat) headerHeight{
    if(_headerHeight != headerHeight) {
        _headerHeight = headerHeight;
        [self invalidateLayout];
    }
}

- (void)setHeaderInset:(UIEdgeInsets) headerInset{
    if(!UIEdgeInsetsEqualToEdgeInsets(_headerInset, headerInset)) {
        _headerInset = headerInset;
        [self invalidateLayout];
    }
}

- (void)setFooterInset:(UIEdgeInsets) footerInset{
    if(!UIEdgeInsetsEqualToEdgeInsets(_footerInset, footerInset)) {
        _footerInset = footerInset;
        [self invalidateLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets) sectionInset{
    if(!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

- (void)setmMnimumContentHeight:(CGFloat) minimumContentHeight{
    if(_minimumContentHeight != minimumContentHeight) {
        _minimumContentHeight = minimumContentHeight;
        [self invalidateLayout];
    }
}

- (CGFloat)itemWidthInSectionAtIndex:(NSInteger)section {
    UIEdgeInsets sectionInset;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    } else {
        sectionInset = self.sectionInset;
    }
    
    CGFloat width = self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right;
    NSInteger columnCount = [self columnCountForSection:section];
    
    CGFloat columnSpacing;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumColumnSpacingForSectionAtIndex:)]) {
        columnSpacing = [self.delegate collectionView:self.collectionView layout:self minimumColumnSpacingForSectionAtIndex:section];
    } else {
        columnSpacing = self.minimumColumnSpacing;
    }
    return FloorCGFloat((width - (columnCount - 1) * columnSpacing) / columnCount);
    
}

#pragma mark - Private Accessors

- (NSMutableDictionary *)headersAttribute {
    if (!_headersAttribute) {
        _headersAttribute = [NSMutableDictionary dictionary];
    }
    return _headersAttribute;
}

- (NSMutableDictionary *)footersAttribute {
    if (!_footersAttribute) {
        _footersAttribute = [NSMutableDictionary dictionary];
    }
    return _footersAttribute;
}

- (NSMutableArray *)unionRects {
    if (!_unionRects) {
        _unionRects = [NSMutableArray array];
    }
    return _unionRects;
}

- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)allItemAttributes {
    if (!_allItemAttributes) {
        _allItemAttributes = [NSMutableArray array];
    }
    return _allItemAttributes;
}

- (NSMutableArray *)sectionItemAttributes {
    if (!_sectionItemAttributes) {
        _sectionItemAttributes = [NSMutableArray array];
    }
    return _sectionItemAttributes;
}

- (id <CustomCollectionViewLayoutDelegate> )delegate {
    return (id <CustomCollectionViewLayoutDelegate> )self.collectionView.delegate;
}

- (NSInteger)columnCountForSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:columnCountForSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self columnCountForSection:section];
    } else {
        return self.columnCount;
    }
}

#pragma mark - Init

- (void)commonInit {
    _columnCount = 2;
    _minimumColumnSpacing = 10;
    _minimumInteritemSpacing = 10;
    _headerHeight = 0;
    _footerHeight = 0;
    _sectionInset = UIEdgeInsetsZero;
    _headerInset  = UIEdgeInsetsZero;
    _footerInset  = UIEdgeInsetsZero;
    _itemRenderDirection = CollectionViewWaterfallLayoutItemRenderDirectionShortestFirst;
}

- (id)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}


//@todo: why need initWithCoder
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}


- (void)prepareLayout {
    [super prepareLayout];
///@test:after removing those removeAllObjcets, the UI layout does not change very much.
    [self.headersAttribute removeAllObjects];
    [self.footersAttribute removeAllObjects];
    [self.unionRects removeAllObjects];
    [self.columnHeights removeAllObjects];
    [self.allItemAttributes removeAllObjects];
    [self.sectionItemAttributes removeAllObjects];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];   
    if(numberOfSections == 0) {
        return;
    }
    
    //@todo NSAssert check protocol and columnCount
    NSInteger idx = 0;
    
    for(NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger columnCount = [self columnCountForSection:section];
        // Each section, create array to store column heights attributes.
        NSMutableArray *sectionColumnHeights = [NSMutableArray arrayWithCapacity:columnCount];
        // Initialized each column height as 0.
        for(idx = 0; idx < columnCount; idx++) {
            [sectionColumnHeights addObject:@(0)];
        }
        [self.columnHeights addObject:sectionColumnHeights];
    }
    
    // Create attributes
    CGFloat top = 0;
    
    UICollectionViewLayoutAttributes *attributes;
    
    for(NSInteger section = 0; section < numberOfSections; section++) {
        /*
         * 1. Get section-specific metrics (minimumInteritemSpacing, sectionInset)
         */
        
        CGFloat minimumInteritemSpacing;
        if([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            minimumInteritemSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
        } else {
            minimumInteritemSpacing = self.minimumInteritemSpacing;
        }
        
        CGFloat columnSpacing;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumColumnSpacingForSectionAtIndex:)]) {
            columnSpacing = [self.delegate collectionView:self.collectionView layout:self minimumColumnSpacingForSectionAtIndex:section];
        } else {
            columnSpacing = self.minimumColumnSpacing;
        }
        
        UIEdgeInsets sectionInset;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        } else {
            sectionInset = self.sectionInset;
        }
        
        // content width = whole screen width - sectionInset.left and right.
        CGFloat width = self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right;
        NSInteger columnCount = [self columnCountForSection:section];
        CGFloat itemWidth = FloorCGFloat((width - (columnCount - 1) * columnSpacing) / columnCount);
        
        /*
         * 2. Section header
         * @todo
         */
        
        CGFloat headerHeight;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForHeaderInSection:)]) {
            headerHeight = [self.delegate collectionView:self.collectionView layout:self heightForHeaderInSection:section];
        } else {
            headerHeight = self.headerHeight;
        }
        
        UIEdgeInsets headerInset;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForHeaderInSection:)]) {
            headerInset = [self.delegate collectionView:self.collectionView layout:self insetForHeaderInSection:section];
        } else {
            headerInset = self.headerInset;
        }
        
        top += headerInset.top;
        
        if (headerHeight > 0) {
            
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:CollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attributes.frame = CGRectMake(headerInset.left,
                                          top,
                                          self.collectionView.bounds.size.width - (headerInset.left + headerInset.right),
                                          headerHeight);
            
            self.headersAttribute[@(section)] = attributes;
            [self.allItemAttributes addObject:attributes];
            
            top = CGRectGetMaxY(attributes.frame) + headerInset.bottom;
        }
        
        top += sectionInset.top;
        for (idx = 0; idx < columnCount; idx++) {
            self.columnHeights[section][idx] = @(top);
        }
        
        /*
         * 3. Section items
         */
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
        
        for(idx = 0; idx < itemCount; idx++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            NSUInteger columnIndex = [self nextColumnIndexForItem:idx inSection:section];
            CGFloat xOffset = sectionInset.left + (itemWidth + columnSpacing) * columnIndex;
            CGFloat yOffset = [self.columnHeights[section][columnIndex] floatValue];
            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            CGFloat itemHeight = 0;
            if (itemSize.height > 0 && itemSize.width > 0) {
                itemHeight = FloorCGFloat(itemSize.height * itemWidth / itemSize.width);
            }
            
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
            [itemAttributes addObject:attributes];
            [self.allItemAttributes addObject:attributes];
            self.columnHeights[section][columnIndex] = @(CGRectGetMaxY(attributes.frame) + minimumInteritemSpacing);
        }
        
        [self.sectionItemAttributes addObject:itemAttributes];
        
        /*
         * 4. Section footer
         */
        
        CGFloat footerHeight;
        NSUInteger columnIndex = [self longestColumnIndexInSection:section];
        top = [self.columnHeights[section][columnIndex] floatValue] - minimumInteritemSpacing + sectionInset.bottom;

        if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForFooterInSection:)]) {
            footerHeight = [self.delegate collectionView:self.collectionView layout:self heightForFooterInSection:section];
        } else {
            footerHeight = self.footerHeight;
        }
        
        UIEdgeInsets footerInset;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForFooterInSection:)]) {
            footerInset = [self.delegate collectionView:self.collectionView layout:self insetForFooterInSection:section];
        } else {
            footerInset = self.footerInset;
        }
        
        top += footerInset.top;
        
        if (footerHeight > 0) {
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:CollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attributes.frame = CGRectMake(footerInset.left,
                                          top,
                                          self.collectionView.bounds.size.width - (footerInset.left + footerInset.right),
                                          footerHeight);
            
            self.footersAttribute[@(section)] = attributes;
            [self.allItemAttributes addObject:attributes];
            
            top = CGRectGetMaxY(attributes.frame) + footerInset.bottom;
        }
        
        for (idx = 0; idx < columnCount; idx++) {
            self.columnHeights[section][idx] = @(top);
        }
        
    } // end of for (NSInteger section = 0; section < numberOfSections; ++section)
    
    /// Build union rects
    idx = 0;
    NSInteger itemCounts = [self.allItemAttributes count];
    while(idx < itemCounts) {
        CGRect unionRect = ((UICollectionViewLayoutAttributes *)self.allItemAttributes[idx]).frame;
        NSInteger rectEndIndex = MIN(idx + unionSize, itemCounts);
        for(NSInteger i = idx + 1; i < rectEndIndex; i++) {
            unionRect = CGRectUnion(unionRect, ((UICollectionViewLayoutAttributes *)self.allItemAttributes[i]).frame);
        }
        
        idx = rectEndIndex;
        
        [self.unionRects addObject:[NSValue valueWithCGRect:unionRect]];
    }
}

/// UICollectionViewLayout method overwrite.
- (CGSize)collectionViewContentSize {
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return CGSizeZero;
    }
    
    CGSize contentSize = self.collectionView.bounds.size;
    contentSize.height = [[[self.columnHeights lastObject] firstObject] floatValue];
    
    if (contentSize.height < self.minimumContentHeight) {
        contentSize.height = self.minimumContentHeight;
    }
    
    return contentSize;
}

/// UICollectionViewLayout method overwrite.
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    if (path.section >= [self.sectionItemAttributes count]) {
        return nil;
    }
    if (path.item >= [self.sectionItemAttributes[path.section] count]) {
        return nil;
    }
    return (self.sectionItemAttributes[path.section])[path.item];
}

/// UICollectionViewLayout method overwrite.
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // @todo bug
    NSInteger i;
    NSInteger begin = 0, end = self.unionRects.count;
    NSMutableArray *attrs = [NSMutableArray array];
    
    for (i = 0; i < self.unionRects.count; i++) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            begin = i * unionSize;
            break;
        }
    }
    for (i = self.unionRects.count - 1; i >= 0; i--) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            end = MIN((i + 1) * unionSize, self.allItemAttributes.count);
            break;
        }
    }
    for (i = begin; i < end; i++) {
        UICollectionViewLayoutAttributes *attr = self.allItemAttributes[i];
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }
    
    return [NSArray arrayWithArray:attrs];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

#pragma mark - Private Methods

/**
 *  Find the shortest column.
 *
 *  @return index for the shortest column
 */
- (NSUInteger)shortestColumnIndexInSection:(NSInteger)section {
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;
    
    [self.columnHeights[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            index = idx;
        }
    }];
    return index;
}

/**
 *  Find the longest column.
 *
 *  @return index for the longest column
 */
- (NSUInteger)longestColumnIndexInSection:(NSInteger)section{
    __block NSUInteger index = 0;
    __block CGFloat longestHeight = 0;
    
    [self.columnHeights[section] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [obj floatValue];
        if(height > longestHeight) {
            index = idx;
            longestHeight = height;
        }
    }];
    return index;
}

/**
 *  Find the index for the next column.
 *
 *  @return index for the next column
 */
- (NSUInteger)nextColumnIndexForItem:(NSInteger)item inSection:(NSInteger)section {
    NSUInteger index = 0;
    NSInteger columnCount = [self columnCountForSection:section];
    switch (self.itemRenderDirection) {
        case CollectionViewWaterfallLayoutItemRenderDirectionShortestFirst:
            index = [self shortestColumnIndexInSection:section];
            break;
            
        case CollectionViewWaterfallLayoutItemRenderDirectionLeftToRight:
            index = (item % columnCount);
            break;
            
        case CollectionViewWaterfallLayoutItemRenderDirectionRightToLeft:
            index = (columnCount - 1) - (item % columnCount);
            break;
            
        default:
            index = [self shortestColumnIndexInSection:section];
            break;
    }
    return index;
}

@end
