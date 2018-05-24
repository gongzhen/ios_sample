//
//  ViewController.m
//  AutoCompleteSearchFB
//
//  Created by Zhen Gong on 5/17/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//  https://github.com/ming1016/study/wiki/%E7%BB%86%E8%AF%B4GCD%EF%BC%88Grand-Central-Dispatch%EF%BC%89%E5%A6%82%E4%BD%95%E7%94%A8
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

/**
 
 autocomplete* autoService;
 dispatch_block_t previsouBlock;
 */

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    /**
     
     dispatch_block_cancel(previuosBlock)
     
     _previousBlock = dispatch_block_create(0, ^{
     dispatch_async(default, ^{
         [self.autoService fetchDataFromServier^{
     self.content = data;
     dispatch_async(main_queue, ^{
     [self.tableView reloadData];
     })
         }]
     })
     })
     
     dispatch_after(popTime, dispatch_get_mainqueue, ^{
        
     })
     
     */
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

@end
