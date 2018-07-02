//
//  UIImageView+AFNetworking.m
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 6/27/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "UIImageView+AFNetworking.h"

#import <objc/runtime.h>

#if TARGET_OS_IOS || TARGET_OS_TV

#import "AFImageDownloader.h"

/*
 这里注意cancelImageDownloadTask中，调用了self.af_activeImageDownloadReceipt这么一个属性，看看定义的地方：
 我们现在是给UIImageView添加的一个类目，所以我们无法直接添加属性，而是使用的是runtime的方式来生成set和get方法生成
 了一个AFImageDownloadReceipt类型的属性。看过上文应该知道这个对象里面就一个task和一个UUID。这个属性就是我们这次
 下载任务相关联的信息。
 */
@interface UIImageView (_AFNetworking)
@property (readwrite, nonatomic, strong, setter = af_setActiveImageDownloadReceipt:) AFImageDownloadReceipt *af_activeImageDownloadReceipt;
@end

@implementation UIImageView (_AFNetworking)

//绑定属性 AFImageDownloadReceipt，就是一个事件响应的接受对象，包含一个task，一个uuid
- (AFImageDownloadReceipt *)af_activeImageDownloadReceipt {
    return (AFImageDownloadReceipt *)objc_getAssociatedObject(self, @selector(af_activeImageDownloadReceipt));
}

/*
 2）然后做了一系列判断，见注释。
 3）然后生成了一个我们之前分析过得AFImageDownloader，然后去获取缓存，如果有缓存，则直接读缓存。
 还记得AFImageDownloader里也有一个读缓存的方法么？那个是和cachePolicy相关的，而这个是有缓存的话直接读取。不明白的可以回过头去看看。
 4）走到这说明没缓存了，然后就去用AFImageDownloader，我们之前讲过的方法，去请求图片。
 完成后，则调用成功或者失败的回调，并且置空属性self.af_activeImageDownloadReceipt，成功则设置图片。
 */
- (void)af_setActiveImageDownloadReceipt:(AFImageDownloadReceipt *)imageDownloadReceipt {
    objc_setAssociatedObject(self, @selector(af_activeImageDownloadReceipt), imageDownloadReceipt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark -

@implementation UIImageView (AFNetworking)

+ (AFImageDownloader *)sharedImageDownloader {
    return objc_getAssociatedObject(self, @selector(sharedImageDownloader)) ?: [AFImageDownloader defaultInstance];
}

+ (void)setSharedImageDownloader:(AFImageDownloader *)imageDownloader {
    objc_setAssociatedObject(self, @selector(sharedImageDownloader), imageDownloader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure
{
    
    if ([urlRequest URL] == nil) {
        self.image = placeholderImage;
        if (failure) {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
            failure(urlRequest, nil, error);
        }
        return;
    }
    
    if ([self isActiveTaskURLEqualToURLRequest:urlRequest]){
        return;
    }
    
    [self cancelImageDownloadTask];
    
    AFImageDownloader *downloader = [[self class] sharedImageDownloader];
    id <AFImageRequestCache> imageCache = downloader.imageCache;
    
    //Use the image from the image cache if it exists
    UIImage *cachedImage = [imageCache imageforRequest:urlRequest withAdditionalIdentifier:nil];
    if (cachedImage) {
        if (success) {
            success(urlRequest, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
        [self clearActiveDownloadInformation];
    } else {
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        
        __weak __typeof(self)weakSelf = self;
        NSUUID *downloadID = [NSUUID UUID];
        AFImageDownloadReceipt *receipt;
        //去下载，并得到一个receipt，可以用来取消回调
        // DLog(@"downloadID:%@", downloadID);
        receipt = [downloader
                   downloadImageForURLRequest:urlRequest
                   withReceiptID:downloadID
                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       //判断receiptID和downloadID是否相同 成功回调，设置图片
                       if ([strongSelf.af_activeImageDownloadReceipt.receiptID isEqual:downloadID]) {
                           if (success) {
                               success(request, response, responseObject);
                           } else if(responseObject) {
                               strongSelf.image = responseObject;
                           }
                           //置空回调
                           [strongSelf clearActiveDownloadInformation];
                       }
                       
                   }
                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       //失败有failuerBlock就回调，
                       if ([strongSelf.af_activeImageDownloadReceipt.receiptID isEqual:downloadID]) {
                           if (failure) {
                               failure(request, response, error);
                           }
                           //置空回调对象
                           [strongSelf clearActiveDownloadInformation];
                       }
                   }];
        
        self.af_activeImageDownloadReceipt = receipt;
    }
}

- (void)cancelImageDownloadTask {
    if (self.af_activeImageDownloadReceipt != nil) {
        [[self.class sharedImageDownloader] cancelTaskForImageDownloadReceipt:self.af_activeImageDownloadReceipt];
        [self clearActiveDownloadInformation];
    }
}

- (void)clearActiveDownloadInformation {
    self.af_activeImageDownloadReceipt = nil;
}

- (BOOL)isActiveTaskURLEqualToURLRequest:(NSURLRequest *)urlRequest {
    return [self.af_activeImageDownloadReceipt.task.originalRequest.URL.absoluteString isEqualToString:urlRequest.URL.absoluteString];
}

@end
#endif
