//
//  ViewController.m
//  AsyncBlockOperation
//
//  Created by zhen gong on 9/16/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"
#import "AsyncBlockOperation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    AsyncBlockOperation *operation = [AsyncBlockOperation blockOperationWithBlock:^(AsyncBlockOperation *op) {
        [self doSomeAsyncTaskWithCompletionBlock:^{
            [op complete]; // complete operation
        }];
    }];
    [queue addOperation:operation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doSomeAsyncTaskWithCompletionBlock:(void (^)()) success {
    NSLog(@"doSomeAsyncTaskWithCompletionBlock");
}


@end
