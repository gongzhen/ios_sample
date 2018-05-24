//
//  ParseOperation.m
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "ParseOperation.h"

@interface ParseOperation ()

@property (nonatomic, strong) NSArray *proList;
@property (nonatomic, strong) NSData *dataToParse;

@end

@implementation ParseOperation

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self != nil) {
        _dataToParse = data;
    }
    return self;
}

//- (void)start;
//- (void)main;

- (void)main {
    NSError* error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:_dataToParse options:kNilOptions error:&error];
    if(error != nil) {
        return;
    }
    if([object isKindOfClass:[NSArray class]]) {
        self.proList = (NSArray *)object;
    }
}

@end
