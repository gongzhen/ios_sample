//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by Admin  on 1/23/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "ViewController.h"
#import "SignInService.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;

@property (strong, nonatomic) SignInService *signInService;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.signInService = [SignInService new];
    self.signInFailureText.hidden = YES;
    [SignInService return:@"hello user"];
    NSLog(@"button clicked");
    RACSignal *validUsernameSignal = [self.usernameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        NSLog(@"Username:%@", value);
        return @([self isValidUsername:value]);
    }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        NSLog(@"Password:%@", value);
        return @([self isValidPassword:value]);
    }];
    
    RAC(self.passwordTextField, backgroundColor) = [validPasswordSignal map:^id _Nullable(NSNumber*  _Nullable value) {
        return [value boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    RAC(self.usernameTextField, backgroundColor) = [validUsernameSignal map:^id _Nullable(NSNumber*  _Nullable value) {
        return [value boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal] reduce:^id _Nonnull (NSNumber *usernameValid, NSNumber *passwordValid){
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        NSLog(@"signupActive:%d", [signupActive boolValue]);
        self.signInButton.enabled = [signupActive boolValue];
    }];
    
    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(__kindof UIControl * _Nullable x) {
           NSLog(@"button clicked");
           self.signInButton.enabled = NO;
           self.signInFailureText.hidden = YES;
       }] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
           return [self signInSignal];
       }] subscribeNext:^(NSNumber * _Nullable signedIn) {
           self.signInButton.enabled = YES;
           BOOL success = [signedIn boolValue];
           self.signInFailureText.hidden = success;
           NSLog(@"subscribeNext:%d", [signedIn boolValue]);
           if(success) {
               [self performSegueWithIdentifier:@"signInSuccess" sender:self];
           }
       }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}

- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self.signInService signInWithUsername:self.usernameTextField.text
                                      password:self.passwordTextField.text
                                      complete:^(BOOL success) {
                                          [subscriber sendNext:@(success)];
                                          [subscriber sendCompleted];
        }];
        return nil;
    }];
}


@end
