//
//  GZAlphabeticalSortPostProcessor.h
//  Ohana
//
//  Created by zhen gong on 5/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GZAlphabeticalSortPostProcessorSortMode) {
    GZAlphabeticalSortPostProcessorSortModeFullName,
    GZAlphabeticalSortPostProcessorSortModeFirstName,
    GZAlphabeticalSortPostProcessorSortModeLastName
};

@interface GZAlphabeticalSortPostProcessor : NSObject

/**
 *  Mode by which to sort
 */
@property (nonatomic, readonly) GZAlphabeticalSortPostProcessorSortMode sortMode;

- (instancetype)initWithSortMode:(GZAlphabeticalSortPostProcessorSortMode)sortMode NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
