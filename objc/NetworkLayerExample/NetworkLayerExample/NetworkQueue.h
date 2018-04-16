//
//  NetworkQueue.h
//  NetworkLayerExample
//
//  Created by Admin  on 4/15/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkQueue : NSObject

@property(strong, nonatomic) NSOperationQueue *queue;

- (void)addOperation:(NSOperation *)op;
+(instancetype)sharedMamager;

@end
