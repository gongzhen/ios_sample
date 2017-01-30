//
//  FBUser.m
//  FBSDKObjC_Login
//
//  Created by gongzhen on 12/8/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "FBUser.h"

@interface FBUser ()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

static FBUser *_currentUser = nil;

@implementation FBUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _dictionary = dictionary;
        self.name = _dictionary[@"name"];
        self.username = _dictionary[@"username"];
        self.profileImageURL = _dictionary[@"profileImageURL"];
    }
    return self;
}

+ (FBUser *)currentUser {
    return _currentUser;
}

+(void)setCurrentUser:(FBUser *)currentUser {
    _currentUser = currentUser;
}

+ (void)logout {
    [FBUser setCurrentUser:nil];
}


@end
