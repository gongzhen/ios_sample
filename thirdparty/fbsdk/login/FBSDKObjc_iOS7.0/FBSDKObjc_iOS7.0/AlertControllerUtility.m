//
//  AlertControllerUtility.m
//  FBSDKObjc_iOS7.0
//
//  Created by gongzhen on 12/22/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "AlertControllerUtility.h"

@interface AlertControllerUtility ()

@end

@implementation AlertControllerUtility

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                   }];
    [alertController addAction:action];
    return alertController;
}

@end
