//
//  main.m
//  StringCopyVSStrong
//
//  Created by gongzhen on 3/30/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//  http://rajkandathi.com/objective-c-copy-vs-strong/
//
#import <Foundation/Foundation.h>

extern uint64_t dispatch_benchmark(size_t count, void(^block)(void));
static size_t const iterations = 10000;
typedef  void (^SimpleOperation)(void);

void (^calculateSimpleOperationTime)(NSString *, SimpleOperation) = ^(NSString* operationName, SimpleOperation operation){
    uint64_t t = dispatch_benchmark(iterations, ^{
        operation();
    });
    NSLog(@"%@ = %llu ns", operationName, t);
};

@interface Solution : NSObject

@property (strong, nonatomic) NSMutableArray *hugeArray;
@property (copy, nonatomic) NSArray *arrayUsingCopyAttribute;
@property (strong, nonatomic) NSArray *arrayUsingStrongAttribute;

// http://www.cocoachina.com/ios/20150512/11805.html
@property (nonatomic, strong) NSString *strongString;
@property (nonatomic, copy) NSString *copyedString;

@end

@implementation Solution

-(void)viewDidLoad {
    for(long i = 0; i < 1000000000; i++) {
        self.hugeArray[i] = @"TEST";
    }
    // Copy the huge array
    SimpleOperation copyOperation = ^{
        self.arrayUsingCopyAttribute = self.hugeArray;
    };
    calculateSimpleOperationTime(@"Copy", copyOperation);
    
    // retain the huge array
    SimpleOperation nonCopyOperation = ^{
        self.arrayUsingStrongAttribute = self.hugeArray;
    };
    calculateSimpleOperationTime(@"Strong", nonCopyOperation);
}

- (void)testImmutableStringCopy {
    NSString *string = [NSString stringWithFormat:@"abc"];
    // immutable string copy is shallow copy.
    NSString* stringCopy = [string copy]; // shallow copy
    self.strongString = string;
    self.copyedString = string;
    // string = [string stringByAppendingString:@"A"];
    // string = [string stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"A"];
    NSLog(@"origin string: %p, %p, %@", string, &string, string);
    NSLog(@"stringCopy:    %p, %p, %@", stringCopy, &stringCopy, stringCopy);
    NSLog(@"strong string: %p, %p, %@", _strongString, &_strongString, _strongString);
    NSLog(@"copy   string: %p, %p, %@", _copyedString, &_copyedString, _copyedString);
}

- (void)testMutableStringMutableCopy {
    NSMutableString *string = [NSMutableString stringWithFormat:@"abc"];
    NSString* stringCopy = string; // shallow copy
    self.strongString = string; // shallow copy/
    self.copyedString = string; // deep copy
    [string appendString:@"efg"];
    NSLog(@"origin string: %p, %p, %@", string, &string, string);
    NSLog(@"stringCopy:    %p, %p, %@", stringCopy, &stringCopy, stringCopy);
    NSLog(@"strong string: %p, %p, %@", _strongString, &_strongString, _strongString);
    NSLog(@"copy   string: %p, %p, %@", _copyedString, &_copyedString, _copyedString);
}

@end

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        Solution* obj = [[Solution alloc] init];
//        [obj viewDidLoad];
//        [obj testImmutableStringCopy];
        [obj testMutableStringMutableCopy];
    }
    return 0;
}
