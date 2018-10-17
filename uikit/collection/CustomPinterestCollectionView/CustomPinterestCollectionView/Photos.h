//
//  Photos.h
//  CustomPinterestCollectionView
//
//  Created by Zhen Gong on 9/30/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo: NSObject

@property(readonly, nonatomic) NSString *caption;
@property(readonly, nonatomic) NSString *comment;
@property(strong, nonatomic) UIImage *image;

@end

@interface Photos : NSObject

+ (NSArray<Photo *> *)allPhotos;

@end
