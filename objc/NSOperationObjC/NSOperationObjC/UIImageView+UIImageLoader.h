//
//  UIImageView+UIImageLoader.h
//  NSOperationObjC
//
//  Created by zhen gong on 8/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (UIImageLoader)

//The views contentMode after the image has loaded.
- (void) uiImageLoader_setFinalContentMode:(UIViewContentMode) finalContentMode;

//Whether or not existing running download task should be canceled. You can safely
//ignore this if you want to let images download to be cached.
- (void) uiImageLoader_setCancelsRunningTask:(BOOL) cancelsRunningTask;
    
//Set a spinner instance. This is retained so you should set it to nil at some point.
//- (void) uiImageLoader_setSpinner:(UIImageLoaderSpinner * _Nullable) spinner;
    
//Set the image with a URL.
- (void) uiImageLoader_setImageWithURL:(NSURL * _Nullable) url;
    
//    Set the image with a URLRequest.
- (void) uiImageLoader_setImageWithRequest:(NSURLRequest * _Nullable) request;

@end
