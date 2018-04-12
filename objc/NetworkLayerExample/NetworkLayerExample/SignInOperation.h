//
//  SignInOperation.h
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserItem;

typedef void(^success)(UserItem * userItem);
typedef void(^failure)(NSError * error);

@interface SignInOperation : NSObject

@property(copy, nonatomic)success successBlock;
@property(copy, nonatomic)failure failureBlock;

- (instancetype)initWithUserName:(NSString *)userName password:(NSString *)password;

@end
