//
//  SUCacheItem.m
//  FBSDKObjC_Login_Jianshu
//
//  Created by gongzhen on 12/9/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "SUCacheItem.h"

#define SUCACHEITEM_TOKEN_KEY @"token"
#define SUCACHEITEM_PROFILE_KEY @"profile"

@implementation SUCacheItem

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    SUCacheItem *item = [[SUCacheItem alloc] init];
    item.profile = [aDecoder decodeObjectOfClass:[FBSDKProfile class] forKey:SUCACHEITEM_PROFILE_KEY];
    item.token = [aDecoder decodeObjectOfClass:[FBSDKAccessToken class] forKey:SUCACHEITEM_TOKEN_KEY];
    return item;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.profile forKey:SUCACHEITEM_PROFILE_KEY];
    [aCoder encodeObject:self.token forKey:SUCACHEITEM_TOKEN_KEY];
}

@end