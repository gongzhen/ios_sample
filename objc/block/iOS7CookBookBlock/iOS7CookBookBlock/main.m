//
//  main.m
//  iOS7CookBookBlock
//
//  Created by gongzhen on 4/2/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString* (^IntToStringConverter)(NSUInteger parameter);

@interface Solution : NSObject

@end

@implementation Solution

- (void)testBlock {
    
    IntToStringConverter inlineBlock = ^(NSUInteger parameter) {
        return [NSString stringWithFormat:@"%lu", parameter];
    };
    
    NSString* result = [self convertToString:123 block:inlineBlock];
    NSLog(@"result:%@", result);
}


- (void)testInlineBlock {        
    NSString* result = [self convertToString:456 block:^NSString *(NSUInteger parameter) {
        return [NSString stringWithFormat:@"%lu", parameter];
    }];
    NSLog(@"inline result:%@", result);
}

- (NSString *)convertToString:(NSUInteger)parameter block:(IntToStringConverter)parameterBlock {
    return parameterBlock(parameter);
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        Solution *obj = [Solution new];
        [obj testBlock];
        [obj testInlineBlock];
        
    }
    return 0;
}
