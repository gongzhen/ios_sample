//
//  BrowseExamplesViewController.m
//  StripeTextField
//
//  Created by Admin  on 11/9/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import <Stripe/Stripe.h>
#import "BrowseExamplesViewController.h"
#import "Constants.h"
//#import "CardExampleViewController.h"
//#import "ApplePayExampleViewController.h"
//#import "SofortExampleViewController.h"
//#import "ThreeDSExampleViewController.h"

@interface BrowseExamplesViewController () <ExampleViewControllerDelegate>
@end

@implementation BrowseExamplesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - STPBackendCharging

- (void)createBackendChargeWithSource:(NSString *)sourceID completion:(STPSourceSubmissionHandler)completion {
    if (!BackendBaseURL) {
        NSError *error = [NSError errorWithDomain:StripeDomain
                                             code:STPInvalidRequestError
                                         userInfo:@{NSLocalizedDescriptionKey: @"You must set a backend base URL in Constants.m to create a charge."}];
        completion(STPBackendChargeResultFailure, error);
        return;
    }
    
    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *urlString = [BackendBaseURL stringByAppendingPathComponent:@"create_charge"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postBody = [NSString stringWithFormat:@"source=%@&amount=%@", sourceID, @1099];
    NSData *data = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:data
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                          if (!error && httpResponse.statusCode != 200) {
                                                              error = [NSError errorWithDomain:StripeDomain
                                                                                          code:STPInvalidRequestError
                                                                                      userInfo:@{NSLocalizedDescriptionKey: @"There was an error connecting to your payment backend."}];
                                                          }
                                                          if (error) {
                                                              completion(STPBackendChargeResultFailure, error);
                                                          } else {
                                                              completion(STPBackendChargeResultSuccess, nil);
                                                          }
                                                      }];
    
    [uploadTask resume];
}

#pragma mark - ExampleViewControllerDelegate

- (void)exampleViewController:(UIViewController *)controller didFinishWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)exampleViewController:(UIViewController *)controller didFinishWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}

@end

