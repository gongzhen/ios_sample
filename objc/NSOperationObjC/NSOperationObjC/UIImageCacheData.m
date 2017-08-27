//
//  UIImageCacheData.m
//  NSOperationObjC
//
//  Created by zhen gong on 8/26/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import "UIImageCacheData.h"

@implementation UIImageCacheData

- (instancetype)init {
    if(self = [super init]) {
        self.maxage = 0;
        self.etag = nil;
        self.lastModified = nil;
        self.errorMaxage = 0;
        self.errorLast = nil;
        self.errorAttempts = 0;
    }
    return self;
}
    
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        NSKeyedUnarchiver *un = (NSKeyedUnarchiver *)aDecoder;
        self.maxage = [un decodeDoubleForKey:@"maxage"];
        self.etag = [un decodeObjectForKey:@"etag"];
        self.nocache = [un decodeBoolForKey:@"nocache"];
        self.lastModified = [un decodeObjectForKey:@"lastModified"];
        self.errorLast = [un decodeObjectForKey:@"errorLast"];
        self.errorMaxage = [un decodeDoubleForKey:@"errorMaxage"];
        self.errorAttempts = [un decodeIntegerForKey:@"errorAttempts"];
    }
    return self;
}
    
- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSKeyedArchiver * ar = (NSKeyedArchiver *)aCoder;
    [ar encodeObject:self.etag forKey:@"etag"];
    [ar encodeDouble:self.maxage forKey:@"maxage"];
    [ar encodeBool:self.nocache forKey:@"nocache"];
    [ar encodeObject:self.lastModified forKey:@"lastModified"];
    [ar encodeInteger:self.errorAttempts forKey:@"errorAttempts"];
    [ar encodeObject:self.errorLast forKey:@"errorLast"];
    [ar encodeDouble:self.errorMaxage forKey:@"errorMaxage"];
}

@end
