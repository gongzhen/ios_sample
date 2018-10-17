//
//  Photos.m
//  CustomPinterestCollectionView
//
//  Created by Zhen Gong on 9/30/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "Photos.h"

@interface Photo()

@end

@implementation Photo

- (instancetype)initWithDictiopanry:(NSDictionary *)dictionary {
    NSString *caption = [dictionary objectForKey:@"Caption"];
    NSString *comment = [dictionary objectForKey:@"Comment"];
    NSString *imageName = [dictionary objectForKey:@"Photo"];
    UIImage *image = [UIImage imageNamed:imageName];
    return [self initWithCaption:caption comment:comment image:image];
}

- (instancetype)initWithCaption:(NSString *)caption comment:(NSString *)comment image:(UIImage *)image {
    self = [super init];
    if (self) {
        _caption = caption;
        _comment = comment;
        _image = image;
    }
    return self;
}

@end

@interface Photos()

@end

@implementation Photos

+ (NSArray<Photo *> *)allPhotos {
    NSMutableArray<Photo *> *photos = [NSMutableArray new];
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"Photos" withExtension:@"plist"];
    if (!URL) {
        return nil;
    }
    NSArray <Photo *> *photosFromPlist = [NSArray arrayWithContentsOfURL:URL];
    if (!photosFromPlist) {
        return nil;
    }
    
    for (NSDictionary *dictionary in photosFromPlist) {
        Photo *photo = [[Photo alloc] initWithDictiopanry:dictionary];
        [photos addObject:photo];
    }
    return [photos copy];
}


@end







