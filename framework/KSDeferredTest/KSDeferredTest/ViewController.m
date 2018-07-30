//
//  ViewController.m
//  KSDeferredTest
//
//  Created by Zhen Gong on 7/2/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "ViewController.h"
#import <KSDeferred/KSDeferred.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    KSDeferred *deferred = [KSDeferred defer];
    
    for(NSInteger i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[self getPromise:i] then:^id _Nullable(id  _Nullable value) {
                NSLog(@"value:%@", value);
                return value;
            } error:^id _Nullable(NSError * _Nullable error) {
                NSLog(@"error:%@", error);
                return error;
            }];
        });
    }
}

- (KSPromise *)getPromise:(NSInteger)idx {
    return [KSPromise promise:^(resolveType resolve, rejectType reject) {
        [self doAsyncThing:idx callback:^(id value, NSError *error) {
            if(error) {
                reject(error);
            } else {
                resolve(value);
            }
        }];
    }];
}

- (void)doAsyncThing:(NSInteger)idx callback:(void(^)(id value, NSError *error))callback {
    if(idx % 2 == 0) {
        callback([NSString stringWithFormat:@"Even Number:%ld", idx], nil);
    } else {
        NSError *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Odd Number:%ld", idx] code:0 userInfo:@{}];
        callback(nil, error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
