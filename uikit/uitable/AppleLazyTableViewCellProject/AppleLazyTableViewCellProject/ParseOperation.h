//
//  ParseOperation.h
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseOperation : NSOperation

@property (nonatomic, copy) void (^errorHandler)(NSError *error);
@property (nonatomic, strong, readonly) NSArray *proList;

- (instancetype)initWithData:(NSData *)data;
@end
