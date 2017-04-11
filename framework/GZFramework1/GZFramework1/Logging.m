//
//  Logging.m
//  GZFramework1
//
//  Created by gongzhen on 4/9/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "Logging.h"

@implementation Logging

-(instancetype)init {
    if(self = [super init]) {
        self.isDebug = false;
    }
    return self;
}

-(void)setDebug:(bool)isDebug {
    _isDebug = isDebug;
    NSLog(@"Project is Debug: %d", _isDebug);
}

-(void)log:(id)t {
    if(_isDebug) {
        NSLog(@"Project log:%@", t);
    }
}
@end
