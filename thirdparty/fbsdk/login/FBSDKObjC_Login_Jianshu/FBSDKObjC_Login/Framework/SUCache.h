//
//  SUCache.h
//  FBSDKObjC_Login_Jianshu
//
//  Created by gongzhen on 12/9/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "SUCacheItem.h"

// A helper class to store items in keychain.
@interface SUCache : NSObject

+ (SUCacheItem *)itemForSlot:(NSInteger)slot;
+ (void)saveItem:(SUCacheItem *)item slot:(NSInteger)slot;
+ (void)deleteItemInSlot:(NSInteger)slot;
+ (void)clearCache;

@end
