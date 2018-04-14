//
//  SignInRequest.h
//  NetworkLayerExample
//
//  Created by Admin  on 4/13/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInRequest : NSObject

-(instancetype)initWithEmail:(NSString *)email password:(NSString *)password;

@end
