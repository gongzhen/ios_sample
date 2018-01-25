//
//  SignInService.h
//  ReactiveCocoa
//
//  Created by Admin  on 1/23/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SignInResponse)(BOOL);

@interface SignInService : NSObject

/// Returns a stream containing only the given value.
+ (__kindof NSString *)return:(NSString *)value;

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(SignInResponse)completeBlock;

@end
