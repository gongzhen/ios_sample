//
    //  UIImageLoader.m
//  NSOperationObjC
//
//  Created by Admin  on 8/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import "UIImageLoader.h"

typedef void (^UIImageLoadedBlock)(UIImage *image);
typedef void (^NSURLAndDataWriteBlock)(NSURL* url, NSData* data);
typedef void (^UIImageLoaderURLCompletion)(NSError* error, NSURL *diskURL, UIImageLoadSource loadedFromSource);
typedef void (^UIImageLoaderDiskURLCompletion)(NSURL *diskURL);

@interface UIImageLoader()

@property NSURLSession * activeSession;
@property NSURL * activeCacheDirectory;
@property NSString * auth;

@end

@implementation UIImageLoader

+ (UIImageLoader *)sharedInstance {
    static UIImageLoader *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    // execute a block once and only once for the lifetime of application.
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id) init {
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    DLog(@"appSupportURL:%@", appSupportURL);
    NSString* bundleId = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
    DLog(@"bundleId:%@", bundleId);
    NSURL* defaultCacheDir = appSupportURL;
    if(bundleId) {
        defaultCacheDir = [defaultCacheDir URLByAppendingPathComponent:bundleId];
        DLog(@"defaultCacheDir:%@", defaultCacheDir);
    }
    defaultCacheDir = [defaultCacheDir URLByAppendingPathComponent:@"UIImageLoader"];
    self = [self initWithCacheDirectory:defaultCacheDir];
    return self;
}

- (instancetype)initWithCacheDirectory:(NSURL *)url {
    if(self = [super init]) {
        [self setCacheDirectory:url];
    }
    return self;
}


- (NSURLSession *)session {
    if(self.activeSession) {
        return self.activeSession;
    }
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.activeSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];;
    return self.activeSession;
}

- (void) setCacheDirectory:(NSURL *) cacheDirectory {
    self.activeCacheDirectory = cacheDirectory;
    [[NSFileManager defaultManager] createDirectoryAtURL:cacheDirectory withIntermediateDirectories:TRUE attributes:nil error:nil];
}

- (NSURL *)cacheDirectory {
    return self.activeCacheDirectory;
}

#pragma mark - public method 

//load an image with URL.
- (NSURLSessionDataTask * _Nullable) loadImageWithURL:(NSURL * _Nullable) url
                                             hasCache:(UIImageLoader_HasCacheBlock _Nullable) hasCache
                                       sendingRequest:(UIImageLoader_SendingRequestBlock _Nullable) sendingRequest
                                     requestCompleted:(UIImageLoader_RequestCompletedBlock _Nullable) requestCompleted {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return [self loadImageWithRequest:request hasCache:hasCache sendingRequest:sendingRequest requestCompleted:requestCompleted];
}

//load an image with custom request.
//auth headers will be added to your request if needed.

- (NSURLSessionDataTask *) loadImageWithRequest:(NSURLRequest *) request
                                       hasCache:(UIImageLoader_HasCacheBlock) hasCache
                                 sendingRequest:(UIImageLoader_SendingRequestBlock) sendingRequest
                               requestCompleted:(UIImageLoader_RequestCompletedBlock) requestCompleted {
    
    return [self cacheImageWithRequest:request hasCache:^(NSURL *diskURL) {
        
    } sendingRequest:^(BOOL didHaveCachedImage) {
        
    } requestComplete:^(NSError *error, NSURL *diskURL, UIImageLoadSource loadedFromSource) {
        if(loadedFromSource == UIImageLoadSourceNetworkToDisk) {
            [self loadImageInBackground:diskURL completion:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    requestCompleted(error, image, loadedFromSource);
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                requestCompleted(error, nil, loadedFromSource);
            });
        }
    }];
}

- (NSURLSessionDataTask *) cacheImageWithRequest:(NSURLRequest *) request
                                        hasCache:(UIImageLoaderDiskURLCompletion) hasCache
                                  sendingRequest:(UIImageLoader_SendingRequestBlock) sendingRequest
                                 requestComplete:(UIImageLoaderURLCompletion) requestComplete {
        
    NSMutableURLRequest * mutableRequest = [request mutableCopy];
    
    NSURL *cachedURL = [self localFileURLForURL:mutableRequest.URL];
    NSURLSessionDataTask *task = [[self session] dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if(error) {
            requestComplete(error,nil,UIImageLoadSourceNone);
            return;
        }
        
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode != 200) {
            requestComplete(error,nil,UIImageLoadSourceNone);
            return;
        }

        [self writeData:data toFile:cachedURL writeCompletion:^(NSURL *url, NSData *data) {
            DLog(@"cachedURL:%@", cachedURL);
            requestComplete(nil, cachedURL, UIImageLoadSourceNetworkToDisk);
        }];

    }];
    [task resume];
    return task;
}

#pragma mark - helper method

- (void)writeData:(NSData *)data toFile:(NSURL *)cachedURL writeCompletion:(NSURLAndDataWriteBlock)writeCompletion {
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(backgroundQueue, ^{
        [data writeToFile:cachedURL.path atomically:TRUE];
        if(writeCompletion) {
            writeCompletion(cachedURL, data);
        }
    });
}


- (NSURL *) localFileURLForURL:(NSURL *) url {
    if(!url) {
        return NULL;
    }
    NSString * path = [url.absoluteString stringByRemovingPercentEncoding];
    NSString * path2 = [path stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    path2 = [path2 stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    path2 = [path2 stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    path2 = [path2 stringByReplacingOccurrencesOfString:@"?" withString:@"-"];
    path2 = [path2 stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    path2 = [path2 stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    return [self.cacheDirectory URLByAppendingPathComponent:path2];
}

- (void) loadImageInBackground:(NSURL *) diskURL completion:(UIImageLoadedBlock) completion {
    dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(background, ^{
        UIImage * image = [[UIImage alloc] initWithContentsOfFile:diskURL.path];
        if(completion) {
            completion(image);
        }
    });
}

@end
