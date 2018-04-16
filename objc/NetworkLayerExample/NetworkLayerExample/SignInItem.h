//
//  SignInItem.h
//  NetworkLayerExample
//
//  Created by Admin  on 4/15/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInItem : NSObject

@property(copy, nonatomic) NSString *token;
@property(copy, nonatomic) NSString* uniqueId;
- (instancetype)initWithToken:(NSString *)token password:(NSString *)uniqueId;

@end
