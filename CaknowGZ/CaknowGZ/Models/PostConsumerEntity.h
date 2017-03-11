//
//  PostConsumerEntity.h
//  CaknowGZ
//
//  Created by gongzhen on 3/10/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "BaseEntity.h"

@interface PostConsumerEntity : BaseEntity

// "copy" is needed when the object is mutable. Using copy instance of the class will contain its own copy..You don't want that value to reflect any changes made by other owners of objects.
// http://stackoverflow.com/questions/2255861/property-and-retain-assign-copy-nonatomic-in-objective-c
// http://stackoverflow.com/questions/387959/nsstring-property-copy-or-retain?rq=1

@property (nonatomic, copy, readonly) NSString *_id;
@property (nonatomic, copy, readonly) NSString *refreshToken;
@property (nonatomic, copy, readonly) NSString *token;
@property (nonatomic, copy, readonly) NSString *stripeCusToken;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *fName;
@property (nonatomic, copy, readonly) NSString *lName;
@property (nonatomic, assign) BOOL verified;

@end
