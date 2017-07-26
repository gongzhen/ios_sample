//
//  RegistrationViewController.h
//  ViewControllerTransition
//
//  Created by zhen gong on 7/15/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegistrationDelegate <NSObject>

- (void)registerProfessionalUser:(NSDictionary *)userObject;

@end

@interface RegistrationViewController : UIViewController

@property (weak, nonatomic) id <RegistrationDelegate> delegate;

@end
