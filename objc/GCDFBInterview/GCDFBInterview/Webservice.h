//
//  Webservice.h
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^Success)(NSDictionary *results);
typedef void (^Failure)(NSError *error);
typedef void (^SuccessImage)(NSData *data);

@interface Webservice : NSObject

- (void) get:(NSString *)route success:(Success)success failire:(Failure)failure;
- (void) getImage:(NSString *)route success:(SuccessImage)success failure:(Failure)failure;
- (void)cancelDownload;

@end
