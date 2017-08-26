//
//  NetworkManager.h
//  NSOperationObjC
//
//  Created by Admin  on 8/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FetchPhotoSuccess)(NSDictionary *datasourceDictionary);
typedef void (^FetchPhotoFailure)(NSError *error);

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedInstance;

- (void)fetchPhotoURLDetails:(FetchPhotoSuccess)success failure:(FetchPhotoFailure)failure;

@end
