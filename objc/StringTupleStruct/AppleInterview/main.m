//
//  main.m
//  AppleInterview
//
//  Created by zhen gong on 4/20/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tuple : NSObject
@property(copy, nonatomic) NSString *first;
@property(copy, nonatomic) NSString *second;

@end

@implementation Tuple

- (instancetype)initWithFirst:(NSString *)first second:(NSString *)second {
    if(self = [super init]) {
        _first = [first copy];
        _second = [second copy];
    }
    return self;
}

@end

@interface Solution : NSObject

-(NSMutableArray *)findCouples:(NSArray *)couples guest:(NSSet *)guest;

@end

@implementation Solution

-(NSMutableArray *)findCouples:(NSArray *)couples guest:(NSSet *)guest {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(id obj in couples) {
        if([obj isKindOfClass:[Tuple class]] == YES) {
            if([guest containsObject:((Tuple *)obj).first] == YES && [guest containsObject:((Tuple *)obj).second] == YES) {
                [result addObject:obj];
            }
        }
    }
    return result;
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        Tuple* tuple1 = [[Tuple alloc] initWithFirst:@"Chris" second:@"Haha"];
        Tuple* tuple2 = [[Tuple alloc] initWithFirst:@"John" second:@"Kassie"];
        NSArray *couples = [[NSArray alloc] initWithObjects: tuple1, tuple2,nil];
        NSSet *guest = [[NSSet alloc] initWithObjects:@"Chris", @"Haha", @"John", @"Lucy", nil];
        Solution *obj = [[Solution alloc] init];
        NSMutableArray *result = [obj findCouples:couples guest:guest];
        for(id obj in result) {
            if([obj isKindOfClass:[Tuple class]] == YES) {
                DLog(@"%@", ((Tuple *)obj).first);
                DLog(@"%@", ((Tuple *)obj).second);
            }
        }
    }
    return 0;
}
