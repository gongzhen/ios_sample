//
//  FBSDKGraphRequestConnection.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBSDKGraphRequestConnection;

/**
 FBSDKGraphRequestHandler
 
 A block that is passed to addRequest to register for a callback with the results of that
 request once the connection completes.
 
 
 
 Pass a block of this type when calling addRequest.  This will be called once
 the request completes.  The call occurs on the UI thread.
 
 - Parameter connection:      The `FBSDKGraphRequestConnection` that sent the request.
 
 - Parameter result:          The result of the request.  This is a translation of
 JSON data to `NSDictionary` and `NSArray` objects.  This
 is nil if there was an error.
 
 - Parameter error:           The `NSError` representing any error that occurred.
 
 */
typedef void (^FBSDKGraphRequestHandler)(FBSDKGraphRequestConnection *connection,
                                         id result,
                                         NSError *error);

@interface FBSDKGraphRequestConnection : NSObject

@end
