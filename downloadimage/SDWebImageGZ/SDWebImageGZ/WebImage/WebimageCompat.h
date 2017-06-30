//
//  WebimageCompat.h
//  SDWebImageGZ
//
//  Created by zhen gong on 6/29/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <TargetConditionals.h> /// allows developer to visit system configuration.

#if OS_OBJECT_USE_OBJC
    #undef DispatchQueueRelease
    #undef DispatchQueueSetterSementics
    #define DispatchQueueRelease(q)
    #define DispatchQueueSetterSementics strong
#else
    #undef DispatchQueueRelease
    #undef DispatchQueueSetterSementics
    #define DispatchQueueRelease(q) (dispatch_release(q))
    #define DispatchQueueSetterSementics assign
#endif

typedef void(^WebImageNoParamsBlock)();


#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif
