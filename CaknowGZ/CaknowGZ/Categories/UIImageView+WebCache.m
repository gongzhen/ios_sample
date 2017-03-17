//
//  UIImageView+WebCache.m
//  CaknowGZ
//
//  Created by gongzhen on 3/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "UIImageView+WebCache.h"

@implementation UIImageView (WebCache)

- (void)processImageDataWithURLString:(NSString *)url completionBlock:(void(^)(NSData *imageData, BOOL successed)) processedImage {
    NSURL *URL = [NSURL URLWithString:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSession* _session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            processedImage(nil, NO);
        } else if (data) {
            processedImage(data, YES);
        }
    }];
    [task resume];
}

@end
