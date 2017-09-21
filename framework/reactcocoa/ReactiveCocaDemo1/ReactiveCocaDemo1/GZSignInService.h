//
//  GZSignInService.h
//  ReactiveCocaDemo1
//
//  Created by Admin  on 9/20/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^RWSignInResponse)(BOOL);

@interface GZSignInService : NSObject

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock;

@end
