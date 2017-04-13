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
@property (assign, nonatomic) CGFloat interitemSpacing;

@end

@implementation CustomCollectionLayout

-(void)prepareLayout {
    [super prepareLayout];
    
    // 初始化参数
    _cellCount = [self.collectionView numberOfItemsInSection:0]; // cell个数，直接从collectionView中获得
    _interitemSpacing = 10; // 设置间距
    _itemWidth = (SCREEN_WIDTH - 3 *_interitemSpacing) / 2; // cell宽度
}

-(CGSize)collectionViewContentSize {
    return CGSizeMake(SCREEN_WIDTH, MAX(_leftY, _rightY));
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    _leftY = _interitemSpacing; // 左边起始Y轴
    _rightY = _interitemSpacing; // 右边起始Y轴
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

// it will call many times and generate the cell size.
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize itemSize = [self.delegate collectionView:self.collectionView collectionViewLayout:self sizeOfItemAtIndexPath:indexPath];
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // DLog(@"indexPath:(%ld:%ld), _leftY:%f, _rightY:%f", indexPath.section, indexPath.row, _leftY, _rightY);
    // _leftY and _rightY start from 10, 10.
    // It will update the height of y. The left side and right side of cell will grow gradually.
    BOOL isLeft = _leftY <= _rightY;
    
    if (isLeft) {
        CGFloat x = _interitemSpacing;
        attributes.frame = CGRectMake(x, _leftY, _itemWidth, itemSize.height);
        _leftY += itemSize.height + _interitemSpacing;
    }
    
    if(!isLeft){
        CGFloat x = _interitemSpacing * 2 + _itemWidth;
        attributes.frame = CGRectMake(x, _rightY, _itemWidth, itemSize.height);
        _rightY += itemSize.height + _interitemSpacing;
    }
    
    return attributes;
}

@end
