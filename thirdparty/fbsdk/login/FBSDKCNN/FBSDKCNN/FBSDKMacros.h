
//
//  FBSDKMacros.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/14/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef FBSDKMacros_h
#define FBSDKMacros_h

#ifdef __cplusplus
#define FBSDK_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define FBSDK_EXTERN extern __attribute__((visibility ("default")))
#endif

#define FBSDK_STATIC_INLINE static inline

#endif /* FBSDKMacros_h */
