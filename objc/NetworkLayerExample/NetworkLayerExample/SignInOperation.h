//
//  SignInOperation.h
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceOperation.h"

@class SignInItem;

typedef void(^success)(SignInItem * signinItem);
typedef void(^failure)(NSError * error);

@interface SignInOperation : ServiceOperation

@property(copy, nonatomic)success successBlock;
@property(copy, nonatomic)failure failureBlock;

- (instancetype)initWithEmail:(NSString *)email password:(NSString *)password;

@end
