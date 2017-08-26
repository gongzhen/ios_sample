//
//  NetworkManager.m
//  NSOperationObjC
//
//  Created by Admin  on 8/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import "NetworkManager.h"

static NSString *const dataSourceURL = @"http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist";

@implementation NetworkManager

+ (NetworkManager *)sharedInstance {
    static NetworkManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    // execute a block once and only once for the lifetime of application.
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)fetchPhotoURLDetails:(FetchPhotoSuccess)success failure:(FetchPhotoFailure)failure {
    NSURL *url = [NSURL URLWithString:dataSourceURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil) {
            failure(error);
            return;
        }
        
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        if(statusCode > 299 || statusCode < 200) {
            NSError *statusError = [NSError errorWithDomain:@"Fetch Image" code:1 userInfo:@{NSLocalizedDescriptionKey: @"statusCode error"}];
            failure(statusError);
            return;
        }
        
        if(data == nil) {
            NSError *dataError = [NSError errorWithDomain:@"Fetch Image" code:1 userInfo:@{NSLocalizedDescriptionKey: @"data is nil"}];
            failure(dataError);
            return;
        }
        
        NSError *plistError = nil;
        
        NSDictionary* datasourceDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainers format:nil error:&plistError];
        if(plistError != nil) {
            failure(plistError);
            return;
        }
        success(datasourceDictionary);        
    }] resume];
}


@end
