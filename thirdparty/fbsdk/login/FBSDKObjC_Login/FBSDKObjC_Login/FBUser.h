//
//  FBUser.h
//  FBSDKObjC_Login
//
//  Created by gongzhen on 12/8/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBUser : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *profileImageURL;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (FBUser *)currentUser;
+ (void)setCurrentUser:(FBUser *)currentUser;

+ (void)logout;

@end
