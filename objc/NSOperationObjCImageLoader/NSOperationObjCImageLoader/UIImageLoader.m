//
    //  UIImageLoader.m
//  NSOperationObjC
//
//  Created by Admin  on 8/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import "UIImageLoader.h"
#import "UIImageMemoryCache.h"
#import "UIImageCacheData.h"

typedef void (^UIImageLoadedBlock)(UIImage *image);
typedef void (^NSURLAndDataWriteBlock)(NSURL* url, NSData* data);
typedef void (^UIImageLoaderURLCompletion)(NSError* error, NSURL *diskURL, UIImageLoadSource loadedFromSource);
typedef void (^UIImageLoaderDiskURLCompletion)(NSURL *diskURL);

//errors
NSString * const UIImageLoaderErrorDomain = @"com.gngrwzrd.UIImageLoader";
const NSInteger UIImageLoaderErrorNilURL = 1;

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
//    DLog(@"appSupportURL:%@", appSupportURL);
    NSString* bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//    DLog(@"bundleId:%@", bundleId);
    NSURL* defaultCacheDir = appSupportURL;
    if(bundleId) {
        defaultCacheDir = [defaultCacheDir URLByAppendingPathComponent:bundleId];
//        DLog(@"defaultCacheDir:%@", defaultCacheDir);
    }
    defaultCacheDir = [defaultCacheDir URLByAppendingPathComponent:@"UIImageLoader"];
    self = [self initWithCacheDirectory:defaultCacheDir];
    return self;
}

- (instancetype)initWithCacheDirectory:(NSURL *)url {
    if(self = [super init]) {
        self = [super init];
        self.cacheImagesInMemory = FALSE;
        self.trustAnySSLCertificate = FALSE;
        self.useServerCachePolicy = TRUE;
        self.logCacheMisses = TRUE;
        self.defaultCacheControlMaxAge = 0;
        self.memoryCache = [[UIImageMemoryCache alloc] init];
        self.cacheDirectory = url;
        self.defaultCacheControlMaxAgeForErrors = 0;
        self.maxAttemptsForErrors = 0;
    }
    return self;
}

- (void) setSession:(NSURLSession *) session {
    self.activeSession = session;
    if(session.delegate && self.trustAnySSLCertificate) {
        if(![session.delegate respondsToSelector:@selector(URLSession:didReceiveChallenge:completionHandler:)]) {
            NSLog(@"[UIImageLoader] WARNING: You set a custom NSURLSession and require trustAnySSLCertificate but your "
                  @"session delegate doesn't respond to URLSession:didReceiveChallenge:completionHandler:");
        }
    }
}

- (NSURLSession *)session {
    if(self.activeSession) {
        return self.activeSession;
    }
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.activeSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];;
    return self.activeSession;
}

- (void) URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if(self.trustAnySSLCertificate) {
        completionHandler(NSURLSessionAuthChallengeUseCredential,[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,nil);
    }
}

- (void) setCacheDirectory:(NSURL *) cacheDirectory {
    self.activeCacheDirectory = cacheDirectory;
    [[NSFileManager defaultManager] createDirectoryAtURL:cacheDirectory withIntermediateDirectories:TRUE attributes:nil error:nil];
}

- (NSURL *)cacheDirectory {
    return self.activeCacheDirectory;
}

- (void) setAuthUsername:(NSString *) username password:(NSString *) password; {
    if(username == nil || password == nil) {
        self.auth = nil;
        return;
    }
    NSString * authString = [NSString stringWithFormat:@"%@:%@",username,password];
    NSData * authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * encoded = [authData base64EncodedStringWithOptions:0];
    self.auth = [NSString stringWithFormat:@"Basic %@",encoded];
}

- (void) setAuthorization:(NSMutableURLRequest *) request {
    if(self.auth) {
        [request setValue:self.auth forHTTPHeaderField:@"Authorization"];
    }
}

- (void) clearCachedFilesModifiedOlderThan1Day; {
    [self clearCachedFilesModifiedOlderThan:86400];
}

- (void) clearCachedFilesModifiedOlderThan1Week; {
    [self clearCachedFilesModifiedOlderThan:604800];
}

- (void) clearCachedFilesModifiedOlderThan:(NSTimeInterval) timeInterval; {
    dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(background, ^{
        NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.cacheDirectory.path error:nil];
        for(NSString * file in files) {
            NSURL * path = [self.cacheDirectory URLByAppendingPathComponent:file];
            NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path.path error:nil];
            NSDate * modified = attributes[NSFileModificationDate];
            NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:modified];
            if(diff > timeInterval) {
                NSLog(@"deleting cached file: %@",path.path);
                [[NSFileManager defaultManager] removeItemAtPath:path.path error:nil];
            }
        }
    });
}


- (void) clearCachedFilesCreatedOlderThan1Day; {
    [self clearCachedFilesCreatedOlderThan:86400];
}
    
- (void) clearCachedFilesCreatedOlderThan1Week; {
    [self clearCachedFilesCreatedOlderThan:604800];
}

- (void) clearCachedFilesCreatedOlderThan:(NSTimeInterval) timeInterval; {
    dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(background, ^{
        NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.cacheDirectory.path error:nil];
        for(NSString * file in files) {
            NSURL * path = [self.cacheDirectory URLByAppendingPathComponent:file];
            NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path.path error:nil];
            NSDate * created = attributes[NSFileCreationDate];
            NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:created];
            if(diff > timeInterval) {
                NSLog(@"deleting cached file: %@",path.path);
                [[NSFileManager defaultManager] removeItemAtPath:path.path error:nil];
            }
        }
    });
}

- (void) purgeDiskCache; {
    dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(background, ^{
        NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.cacheDirectory.path error:nil];
        for(NSString * file in files) {
            NSURL * path = [self.cacheDirectory URLByAppendingPathComponent:file];
            NSLog(@"deleting cached file: %@",path.path);
            [[NSFileManager defaultManager] removeItemAtPath:path.path error:nil];
        }
    });
}
    
- (void) purgeMemoryCache; {
    [self.memoryCache purge];
}
    
- (void) setMemoryCacheMaxBytes:(NSUInteger) maxBytes; {
    self.memoryCache.maxBytes = maxBytes;
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
    UIImage *image = [self.memoryCache.cache objectForKey:request.URL.path];
//    DLog(@"image:%@ for request.URL.path:%@", image, request.URL.path);
    if(image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hasCache(image, UIImageLoadSourceMemory);
        });
        return nil;
    }
    
    return [self cacheImageWithRequest:request hasCache:^(NSURL *diskURL) {
//        DLog(@"hashCache:%@", hasCache);
        [self loadImageInBackground:diskURL completion:^(UIImage *image) {
            if(self.cacheImagesInMemory) {
                [self.memoryCache cacheImage:image forURL:request.URL];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                hasCache(image,UIImageLoadSourceDisk);
            });
        }];
    } sendingRequest:^(BOOL didHaveCachedImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            sendingRequest(didHaveCachedImage);
        });
    } requestComplete:^(NSError *error, NSURL *diskURL, UIImageLoadSource loadedFromSource) {
        if(loadedFromSource == UIImageLoadSourceNetworkToDisk) {
//            DLog(@"loadedFromSource:%ld=>diskURL:%@", loadedFromSource, diskURL);
            [self loadImageInBackground:diskURL completion:^(UIImage *image) {
                if(self.cacheImagesInMemory) {
                    [self.memoryCache cacheImage:image forURL:request.URL];
                }
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
    if(self.useServerCachePolicy) {
        return [self cacheImageWithRequestUsingCacheControl:request hasCache:hasCache sendingRequest:sendingRequest requestCompleted:requestComplete];
    }
    
    if(!request.URL || request.URL.absoluteString.length < 1) {
        requestComplete([NSError errorWithDomain:UIImageLoaderErrorDomain code:UIImageLoaderErrorNilURL userInfo:@{NSLocalizedDescriptionKey:@"The request URL is nil or empty."}],nil,UIImageLoadSourceNone);
    }
    
    // make mutable request
    NSMutableURLRequest * mutableRequest = [request mutableCopy];
    [self setAuthorization:mutableRequest];
    
    NSURL *cachedURL = [self localFileURLForURL:mutableRequest.URL];
//    DLog(@"cachedURL:%@", cachedURL);
    if([[NSFileManager defaultManager] fileExistsAtPath:cachedURL.path]) {
        hasCache(cachedURL);
        return nil;
    }
    
    if(self.logCacheMisses) {
//        DLog(@"[UIImageLoader] cache miss for url: %@",mutableRequest.URL);
    }
    
    sendingRequest(FALSE);
    
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
        
        if(data) {
            [self writeData:data toFile:cachedURL writeCompletion:^(NSURL *url, NSData *data) {
                DLog(@"cachedURL:%@", cachedURL);
                requestComplete(nil, cachedURL, UIImageLoadSourceNetworkToDisk);
            }];
        }
    }];
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)cacheImageWithRequestUsingCacheControl:(NSURLRequest *)request
                                                        hasCache:(UIImageLoaderDiskURLCompletion)hasCache
                                                  sendingRequest:(UIImageLoader_SendingRequestBlock)sendingRequest
                                                requestCompleted:(UIImageLoaderURLCompletion)requestCompleted {
    if(!request.URL || request.URL.absoluteString.length < 1) {
        requestCompleted([NSError errorWithDomain:UIImageLoaderErrorDomain code:UIImageLoaderErrorNilURL userInfo:@{NSLocalizedDescriptionKey:@"The request URL is nil or empty."}],nil,UIImageLoadSourceNone);
    }
    
    //make mutable request
    NSMutableURLRequest * mutableRequest = [request mutableCopy];
    [self setAuthorization:mutableRequest];
    
    //get cache file urls
    NSURL * cacheInfoFile = [self localCacheControlFileURLForURL:request.URL];
    NSURL * cachedImageURL = [self localFileURLForURL:request.URL];
//    DLog(@"cacheInfoFile:%@ cachedImageURL:%@", cacheInfoFile, cachedImageURL);
    //setup blank cache object
    UIImageCacheData * cached = nil;
    
    //load cached info file if it exists.
//     DLog(@"cacheInfoFile.path:%@", cacheInfoFile.path);
    if([[NSFileManager defaultManager] fileExistsAtPath:cacheInfoFile.path]) {
        cached = [NSKeyedUnarchiver unarchiveObjectWithFile:cacheInfoFile.path];
    } else {
        cached = [[UIImageCacheData alloc] init];
    }

    //check max age
    NSDate * now = [NSDate date];
    NSDate * createdDate = [self createdDateForFileURL:cachedImageURL];
    NSTimeInterval diff = [now timeIntervalSinceDate:createdDate];
    BOOL cacheValid = FALSE;
    
    //check cache expiration
    if(!cached.nocache && cached.maxage > 0 && diff < cached.maxage) {
        cacheValid = TRUE;
    }
    
    //check error attempts and max error age
    if(cached.errorLast) {
        NSDate * cacheInfoFileCreatedDate = [self createdDateForFileURL:cacheInfoFile];
        NSTimeInterval errorDiff = [now timeIntervalSinceDate:cacheInfoFileCreatedDate];
        if(!cached.nocache && cached.errorAttempts >= self.maxAttemptsForErrors && cached.errorMaxage > 0 && errorDiff < cached.errorMaxage) {
            requestCompleted(cached.errorLast,nil,UIImageLoadSourceNone);
            return nil;
        }
    }
    
    
    BOOL didSendCacheCompletion = FALSE;
    
    //file exists.
    if([[NSFileManager defaultManager] fileExistsAtPath:cachedImageURL.path]) {
        if(cacheValid) {
            DLog(@"cachedImageURL:%@", cachedImageURL.path);
            hasCache(cachedImageURL);
            return nil;
        } else {
            didSendCacheCompletion = TRUE;
            //call hasCache completion and continue load below
            hasCache(cachedImageURL);
        }
    } else {
        if(self.logCacheMisses) {
            NSLog(@"[UIImageLoader] cache miss for url: %@",request.URL);
        }
    }
    
    //ignore built in cache from networking code. handled here instead.
    mutableRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    //add etag if available
    if(cached.etag) {
        [mutableRequest setValue:cached.etag forHTTPHeaderField:@"If-None-Match"];
    }
    
    //add last modified if available
    if(cached.lastModified) {
        [mutableRequest setValue:cached.lastModified forHTTPHeaderField:@"If-Modified-Since"];
    }
    
    //reset error cache info file if necessary.
    if(cached.errorLast) {
        cached.errorLast = nil;
    }
    if(cached.errorAttempts >= self.maxAttemptsForErrors) {
        cached.errorAttempts = 0;
    }
    
    sendingRequest(didSendCacheCompletion);
    
    NSURLSessionDataTask * task = [[self session] dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary * headers = [httpResponse allHeaderFields];
        
        //304 Not Modified use cache
        if(httpResponse.statusCode == 304) {
            
            if(headers[@"Cache-Control"]) {
                [self setCacheControlForCacheInfo:cached fromCacheControlString:headers[@"Cache-Control"]];
                [self writeCacheControlData:cached toFile:cacheInfoFile];
            } else {
                cached.maxage = self.defaultCacheControlMaxAge;
                [self writeCacheControlData:cached toFile:cacheInfoFile];
            }
            
            requestCompleted(nil,cachedImageURL,UIImageLoadSourceNetworkNotModified);
            return;
        }
        
        //4XX, 5XX errors we can possibly cache.
        if(httpResponse.statusCode > 399 && httpResponse.statusCode < 600) {
            NSString * errorString = [NSString stringWithFormat:@"Request failed with error code %li", (long)httpResponse.statusCode];
            NSDictionary * info = @{NSLocalizedDescriptionKey:errorString};
            NSError * error = [[NSError alloc] initWithDomain:UIImageLoaderErrorDomain code:httpResponse.statusCode userInfo:info];
            if(self.defaultCacheControlMaxAgeForErrors > 0) {
                cached.errorAttempts++;
            }
            cached.errorLast = error;
            cached.errorMaxage = self.defaultCacheControlMaxAgeForErrors;
            [self writeCacheControlData:cached toFile:cacheInfoFile];
            requestCompleted(error,nil,UIImageLoadSourceNone);
            
            return;
        }
        
        //error
        if(httpResponse.statusCode < 200 && httpResponse.statusCode > 299 && error) {
            requestCompleted(error,nil,UIImageLoadSourceNone);
            return;
        }
        
        //check for Cache-Control
        if(headers[@"Cache-Control"]) {
            [self setCacheControlForCacheInfo:cached fromCacheControlString:headers[@"Cache-Control"]];
        } else {
            cached.maxage = self.defaultCacheControlMaxAge;
        }
        
        //check for ETag
        if(headers[@"ETag"]) {
            cached.etag = headers[@"ETag"];
        }
        
        //check for Last Modified
        if(headers[@"Last-Modified"]) {
            cached.lastModified = headers[@"Last-Modified"];
        }
        
        //save cached info file
        [self writeCacheControlData:cached toFile:cacheInfoFile];
        
        //save image to disk
        [self writeData:data toFile:cachedImageURL writeCompletion:^(NSURL *url, NSData *data) {
            requestCompleted(nil,cachedImageURL,UIImageLoadSourceNetworkToDisk);
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

- (NSURL *)localCacheControlFileURLForURL:(NSURL *) url {
    if(!url) {
        return NULL;
    }
    NSURL * localImageFile = [self localFileURLForURL:url];
    NSString * path = [localImageFile.path stringByAppendingString:@".cc"];
    return [NSURL fileURLWithPath:path];
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

- (NSDate *) createdDateForFileURL:(NSURL *) url {
    NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:nil];
    if(!attributes) {
        return nil;
    }
    return attributes[NSFileCreationDate];
}

- (void) setCacheControlForCacheInfo:(UIImageCacheData *) cacheInfo fromCacheControlString:(NSString *) cacheControl {
    if([cacheControl isEqualToString:@"no-cache"]) {
        cacheInfo.nocache = TRUE;
        return;
    }
    
    NSScanner * scanner = [[NSScanner alloc] initWithString:cacheControl];
    NSString * prelim = nil;
    [scanner scanUpToString:@"=" intoString:&prelim];
    [scanner scanString:@"=" intoString:nil];
    
    double maxage = -1;
    [scanner scanDouble:&maxage];
    if(maxage > -1) {
        cacheInfo.maxage = (NSTimeInterval)maxage;
    }
}

- (void) writeCacheControlData:(UIImageCacheData *) cache toFile:(NSURL *) cachedURL {
    dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(background, ^{
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:cache];
        [data writeToFile:cachedURL.path atomically:TRUE];
        NSDictionary * attributes = @{NSFileModificationDate:[NSDate date]};
        [[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:cachedURL.path error:nil];
    });
}

@end
