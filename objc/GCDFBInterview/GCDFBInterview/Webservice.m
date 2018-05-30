//
//  Webservice.m
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "Webservice.h"
#import "AppDelegate.h"

@interface Webservice()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;
@property(nonatomic, strong) NSOperationQueue *queue;

@end

@implementation Webservice

- (instancetype)init {
    if(self = [super init]) {

    }
    return self;
}

- (void)get:(NSString *)route success:(Success)success failire:(Failure)failure {
    NSURL *URL = [NSURL URLWithString:route];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection) {
                    // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                    // then your Info.plist has not been properly configured to match the target server.
                    //
                    failure(error);
                } else {
                    failure(error);
                }
            }];
        } else {
            NSError* error = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];;
            if(error != nil) {
                DLog(@"%@", error);
                failure(error);
            } else if([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *results = (NSDictionary *)object;
                success(results);
            }
        }
    }];
    
    [_sessionTask resume];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
}

- (void) getImage:(NSString *)route success:(SuccessImage)success failure:(Failure)failure; {
    NSString *imgURL;
    if ([route rangeOfString:@"http"].location != NSNotFound) {
        imgURL = route;
    } else {
        imgURL = [NSString stringWithFormat:@"https://s3.amazonaws.com/mobilestyles/%@", route];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgURL]];
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       if (error != nil)
                                                       {
                                                           if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
                                                           {
                                                               failure(error);
                                                           }
                                                       } else {
//                                                           DLog(@"response:%@", response);
//                                                           DLog(@"data:%@", data);
                                                           success(data);
                                                       }
                                                   }];
    
    [self.sessionTask resume];
}

- (void)cancelDownload {
    [self.sessionTask cancel];
    _sessionTask = nil;
}

@end
