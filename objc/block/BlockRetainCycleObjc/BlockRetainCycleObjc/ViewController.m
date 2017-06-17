//
//  ViewController.m
//  BlockRetainCycleObjc
//
//  Created by zhen gong on 6/12/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"
#import "ReporterView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Regiestering notification "Notification"
    ReporterView* _reporterView = [[ReporterView alloc] init];
    // Post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification" object:nil];
    // call block method
    
    // solution 1:
//     __weak ReporterView *weakPtr = _reporterView;
    
    [_reporterView block:^{
        // DLog(@"ViewController call block method");
        // _reporterView and doBlock are both strong property.
        // just set to weak ptr for either one.
        // solution 1:
        // [weakPtr foo];
        
        // solution 2
        [_reporterView foo];
    }];
    //deallocate reportView
    _reporterView = nil;
    
    // problem: after deallocating reportView, the notificaton still send after 5 seconds.
    // You will see the message from console: [ReporterView handleNotification] [Line 31] Notification Received.
    // it comes from ReportView init method.
    // [_reporterView foo] this line. block method's parameter doBlock is strong type property block.
    //
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 5);
    dispatch_after(when, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DLog(@"After 5 seconds ... ViewController call block method");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification" object:nil];
    });
}
/**
without weakPtr dealloc is never called.
2017-06-12 14:54:24.899 BlockRetainCycleObjc[2067:52378] -[ReporterView handleNotification] [Line 31] Notification Received
2017-06-12 14:54:24.900 BlockRetainCycleObjc[2067:52378] -[ReporterView block:] [Line 41] ReporterView call block method
2017-06-12 14:54:30.359 BlockRetainCycleObjc[2067:52413] -[ViewController viewDidLoad]_block_invoke [Line 41] After 5 seconds ... ViewController call block method
2017-06-12 14:54:30.359 BlockRetainCycleObjc[2067:52413] -[ReporterView handleNotification] [Line 31] Notification Received
 
with weak ptr
2017-06-12 14:56:14.097 BlockRetainCycleObjc[2105:53811] -[ReporterView handleNotification] [Line 31] Notification Received
2017-06-12 14:56:14.098 BlockRetainCycleObjc[2105:53811] -[ReporterView block:] [Line 41] ReporterView call block method
2017-06-12 14:56:14.098 BlockRetainCycleObjc[2105:53811] -[ReporterView dealloc] [Line 49] dealloc
2017-06-12 14:56:19.545 BlockRetainCycleObjc[2105:53879] -[ViewController viewDidLoad]_block_invoke [Line 43] After 5 seconds ... ViewController call block method
 
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
