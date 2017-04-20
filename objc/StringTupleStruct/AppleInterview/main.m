//
//  main.m
//  AppleInterview
//
//  Created by zhen gong on 4/20/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>

struct Tuple {
    char* first;
    char* second;
};
typedef struct Tuple Tuple;

Tuple TupleMake(char *first, char *second) {
    Tuple tuple;
    // tuple.first = first;
    // tuple.second = second;
    tuple.first = strdup(first);
    tuple.second = strdup(second);
//    strcpy(tuple.first, first); // bad access
//    strcpy(tuple.second, second);
    return tuple;
}

@interface Solution : NSObject

-(NSMutableArray *)findCouples:(NSArray *)couples guest:(NSSet *)guest;

@end

@implementation Solution

-(NSMutableArray *)findCouples:(NSArray *)couples guest:(NSSet *)guest {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(NSValue *value in couples) {
        Tuple tuple;
        [value getValue:&tuple];
        NSString *first = [NSString stringWithUTF8String:tuple.first];
        NSString *second = [NSString stringWithUTF8String:tuple.second];
        if([guest containsObject:first] && [guest containsObject:second]) {
            [result addObject:[NSValue valueWithBytes:&tuple objCType:@encode(Tuple)]];
        }
    }
    return result;
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        Tuple tuple1 = TupleMake("Chris", "Haha");
        Tuple tuple2 = TupleMake("John", "Kassie");
        NSMutableArray *couples = [[NSMutableArray alloc] initWithObjects: [NSValue valueWithBytes:&tuple1 objCType:@encode(Tuple)], [NSValue valueWithBytes:&tuple2 objCType:@encode(Tuple)], nil];
        NSSet *guest = [[NSSet alloc] initWithObjects:@"Chris", @"Haha", @"John", @"Lucy", nil];
        Solution *obj = [[Solution alloc] init];
        NSMutableArray *result = [obj findCouples:couples guest:guest];
        for(NSValue *value in result) {
            Tuple tuple;
            [value getValue:&tuple];
            NSString *first = [NSString stringWithUTF8String:tuple.first];
            NSString *second = [NSString stringWithUTF8String:tuple.second];
            DLog(@"result:%@", first);
            DLog(@"result:%@", second);
        }
    }
    return 0;
}
