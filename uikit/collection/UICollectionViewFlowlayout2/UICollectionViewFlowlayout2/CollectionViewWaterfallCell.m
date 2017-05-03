//
//  CollectionViewWaterfallCell.m
//  UICollectionViewFlowlayout2
//
//  Created by zhen gong on 4/30/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "CollectionViewWaterfallCell.h"

@implementation CollectionViewWaterfallCell

#pragma mark - Accessors
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

@end
