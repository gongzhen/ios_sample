//
//  UserItem.m
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "UserItem.h"

@implementation UserItem

- (instancetype)initWithEmail:(NSString *)email password:(NSString *)password
{
    self = [super init];
    if (self) {
        _email = email;
        _passWord = password;
    }
    return self;
}
@end
