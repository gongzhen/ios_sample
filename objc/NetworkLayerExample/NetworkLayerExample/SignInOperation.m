//
//  SignInOperation.m
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "SignInOperation.h"

@interface SignInOperation() {
    NSString* _userName;
    NSString *_passWord;
}

@end

@implementation SignInOperation

- (instancetype)initWithUserName:(NSString *)userName password:(NSString *)password 
{
    self = [super init];
    if (self) {
        _userName = userName;
        _passWord = password;
    }
    return self;
}

@end
