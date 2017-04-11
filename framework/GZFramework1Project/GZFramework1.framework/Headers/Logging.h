//
//  Logging.h
//  GZFramework1
//
//  Created by gongzhen on 4/9/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logging : NSObject

@property (nonatomic, assign) bool isDebug;

- (void)setDebug:(bool)isDebug;

- (void)log:(id)t;

@end
