//
//  ViewController.m
//  GCDFBInterview
//
//  Created by Zhen Gong on 5/28/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "ViewController.h"
#import "Webservice.h"

@interface ViewController () <UITextFieldDelegate>

@property(strong, nonatomic) Webservice* webService;
@property (strong, nonatomic) UITextField* searchField;
@property (strong, nonatomic) UILabel* textLabel;

@end

static NSString *const TopPaidAppsFeed = @"https://jsonplaceholder.typicode.com/posts/1";

@implementation ViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webService = [[Webservice alloc] init];
    self.view.backgroundColor = UIColor.whiteColor;
    CGFloat width = self.view.frame.size.width - 40;
    CGFloat yOffset = self.view.frame.size.height / 3;
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(20, yOffset, width, 40)];
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, yOffset + 60, width, 40)];
    self.searchField.delegate = self;
    self.searchField.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:self.searchField];
    [self.view addSubview:self.textLabel];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/*
 Get string from user's input. Sending request to server for each character.
 When two characters's time interval is less than 200 milliseconds, then cancel the previous request.
 When the time interval of last character is larger than 200 milliseconds, then send the last request.
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    /// DLog(@"text:%@====string:%@", textField.text, string);
    if(string != nil && string.length != 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.webService get:TopPaidAppsFeed success:^(NSDictionary *results) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.textLabel.text = [NSString stringWithFormat:@"%@:%@", textField.text, [results objectForKey:@"body"]];
                });
            } failire:^(NSError *error) {
                
            }];
        });
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}


@end
