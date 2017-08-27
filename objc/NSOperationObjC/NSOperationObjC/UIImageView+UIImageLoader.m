//
//  UIImageView+UIImageLoader.m
//  NSOperationObjC
//
//  Created by zhen gong on 8/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import "UIImageView+UIImageLoader.h"
#import "UIImageLoader.h"
#import <objc/runtime.h>

static const char * _loadingURL = "uiImageLoader_loadingURL";
static const char * _runningTask = "uiImageLoader_runningTask";
static const char * _cancelsRunningTask = "uiImageLoader_cancelsRunningTask";
static const char * _finalScaling = "uiImageLoader_finalScaling";
//static const char * _spinner = "uiImageLoader_spinner";

@implementation UIImageView (UIImageLoader)

- (void) uiImageLoader_setFinalContentMode:(UIViewContentMode) finalContentMode; {
    objc_setAssociatedObject(self, _finalScaling, [NSNumber numberWithInt:finalContentMode], OBJC_ASSOCIATION_ASSIGN);
}

- (void) uiImageLoader_setCancelsRunningTask:(BOOL) cancelsRunningTask;{
    objc_setAssociatedObject(self, _cancelsRunningTask, [NSNumber numberWithBool:cancelsRunningTask], OBJC_ASSOCIATION_ASSIGN);
}

//- (void) uiImageLoader_setSpinner:(UIImageLoaderSpinner *) spinner; {
//    objc_setAssociatedObject(self, _spinner, spinner, OBJC_ASSOCIATION_ASSIGN);
//}

- (void) uiImageLoader_setImageWithURL:(NSURL *) url; {
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self uiImageLoader_setImageWithRequest:request];
}

- (void) uiImageLoader_setImageWithRequest:(NSURLRequest *) request {
    if(!request.URL || [request.URL.absoluteString length] < 1) {
        return;
    }
    
    //get cancels task
    BOOL cancelsTasks = [objc_getAssociatedObject(self, _cancelsRunningTask) boolValue];
    
    //check if there's an existing task to cancel.
    NSURLSessionDataTask * task = (NSURLSessionDataTask *)objc_getAssociatedObject(self, _runningTask);
    if(task && cancelsTasks) {
        [task cancel];
    }
    
    //set the last requested URL to load.
    objc_setAssociatedObject(self, _loadingURL, request.URL, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    //load image.
    task = [[UIImageLoader sharedInstance] loadImageWithRequest:request hasCache:^(UIImage * _Nullable image, UIImageLoadSource loadedFromSource) {
        if(image) {
            NSNumber * completedImageScaling = objc_getAssociatedObject(self, _finalScaling);
            if(completedImageScaling) {
                self.contentMode = completedImageScaling.integerValue;
            }
            self.image = image;
        }
    } sendingRequest:^(BOOL didHaveCachedImage) {
        
    } requestCompleted:^(NSError * _Nullable error, UIImage * _Nullable image, UIImageLoadSource loadedFromSource) {

        if(image) {
            
            //make sure the image completed matches the last requested image to display.
            //this is most useful for table cells which are recycled.
            NSURL * lastRequestedURL = objc_getAssociatedObject(self, _loadingURL);
            if(lastRequestedURL == nil || [lastRequestedURL isEqual:request.URL]) {
                NSNumber * completedImageScaling = objc_getAssociatedObject(self, _finalScaling);
                if(completedImageScaling) {
                    self.contentMode = completedImageScaling.integerValue;
                }
                
                self.image = image;
            }
        }
        
    }];
    
    objc_setAssociatedObject(self, _runningTask, task, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
