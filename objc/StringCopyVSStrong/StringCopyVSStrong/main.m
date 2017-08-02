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

@property (copy, nonatomic) NSString *nameCopy;
@property (strong, nonatomic) NSString *nameStrong;

@end

@implementation Solution

- (id)init {
    if(self = [super init]) {
    
    }
    return self;
}

- (id)initWithCopyname:(NSString *)copyName strongName:(NSString *) strongName{
    if (self = [super init]) {
        _nameCopy = copyName;
        _nameStrong = strongName;
    }
    return self;
}

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

// https://stackoverflow.com/questions/26993427/should-i-use-copy-or-strong-with-arrays
- (void)testMutableStringChanged {
    NSMutableString *s = [@"test1" mutableCopy];
    NSArray *a1 = @[s];
    NSArray *a2 = [a1 copy];
    NSLog(@"\na1: %1$p, %1$@\na2: %2$p, %2$@", a1, a2);
    [s appendString:@"2"];
    NSLog(@"\na1: %1$p, %1$@\na2: %2$p, %2$@", a1, a2);
}

- (void)testMutableStringNotChanged {
    NSString *s1 = @"test1";
    NSString *s2 = @"test2";
    NSMutableArray *a1 = [@[s1] mutableCopy];
    NSArray *a2 = [a1 copy];
    NSLog(@"\na1: %1$p, %1$@\na2: %2$p, %2$@", a1, a2);
    [a1 addObject:s2];
    NSLog(@"\na1: %1$p, %1$@\na2: %2$p, %2$@", a1, a2);
}

@end

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
//        Solution* obj = [[Solution alloc] init];
//        [obj viewDidLoad];
//        [obj testImmutableStringCopy];
//        [obj testMutableStringMutableCopy];
        
        Solution *obj = [[Solution alloc] initWithCopyname:@"copyZhen" strongName:@"strongGong"];
        // https://stackoverflow.com/questions/27468595/objective-c-address-of-property-expression
        NSString* copyPtr = obj.nameCopy;
        NSString* strongPtr = obj.nameStrong;

        NSLog(@"copyStr:%@:[%p]", obj.nameCopy, &copyPtr);
        NSLog(@"strongStr:%@:[%p]", obj.nameStrong, &strongPtr);
        // NSString* immutableStr = @"immutableStr";
        NSMutableString *immutableStr = [NSMutableString stringWithFormat:@"mutableStr"];
        NSLog(@"immutableStr:%@:[%p]", immutableStr, &immutableStr);
        obj.nameCopy = immutableStr;
        obj.nameStrong = immutableStr;
        NSLog(@"copyStr:%@:[%p]", obj.nameCopy, &copyPtr);
        NSLog(@"strongStr:%@:[%p]", obj.nameStrong, &strongPtr);
        
        [immutableStr setString:@"immutableString changed"];
        NSLog(@"immutableStr:%@:[%p]", immutableStr, &immutableStr);
        NSLog(@"copyStr:%@:[%p] will not be changed with immutableString", obj.nameCopy, &copyPtr);
        NSLog(@"strongStr:%p:[%p] is changed with immutableString", obj.nameStrong, &strongPtr);
        
        [obj testMutableStringChanged];
        [obj testMutableStringNotChanged];
        
    }
    return 0;
}
