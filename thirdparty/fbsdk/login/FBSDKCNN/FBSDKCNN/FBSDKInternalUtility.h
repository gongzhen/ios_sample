//
//  FBSDKInternalUtility.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBSDKInternalUtility : NSObject


/**
 Returns bundle for returning localized strings
 
 We assume a convention of a bundle named FBSDKStrings.bundle, otherwise we
 return the main bundle.
 */
+ (NSBundle *)bundleForStrings;

@end
