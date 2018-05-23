//
//  Webservice.m
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "Webservice.h"
#import "AppDelegate.h"
#import "ParseOperation.h"

@interface Webservice()

@property(nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) ParseOperation *parser;

@end

@implementation Webservice

- (instancetype)init {
    if(self = [super init]) {

    }
    return self;
}

- (void)get:(NSURL *)url success:(Success)success {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection) {
                    // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                    // then your Info.plist has not been properly configured to match the target server.
                    //
                    abort();
                } else {
                    [self handleError:error];
                }
            }];
        } else {
            self.parser = [[ParseOperation alloc] initWithData:data];
            self.queue = [[NSOperationQueue alloc] init];
            __weak Webservice* weakSelf = self;
            self.parser.errorHandler = ^(NSError* parseError){
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [weakSelf handleError:error];
            };
            
            __weak ParseOperation *weakParser = self.parser;
            self.parser.completionBlock = ^(void){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    success(weakParser.proList);
                });
                
                weakSelf.queue = nil;
            };
            [self.queue addOperation:self.parser];
        }
    }];
    
    [sessionTask resume];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// -------------------------------------------------------------------------------
//    handleError:error
//  Reports any error with an alert which was received from connection or loading failures.
// -------------------------------------------------------------------------------
- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    
    // alert user that our current record was deleted, and then we leave this view controller
    //
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Cannot Show Top Paid Apps", @"")
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         // dissmissal of alert completed
                                                     }];
    
    [alert addAction:OKAction];
    
}

@end
