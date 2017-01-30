//
//  ConfirmViewController.m
//  FBSDKObjC_Login
//
//  Created by gongzhen on 12/8/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ConfirmViewController.h"

@interface ConfirmViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *fbuserProfileView;
@property (weak, nonatomic) IBOutlet UILabel *fbuserNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *fbuserLoginButton;
@property (weak, nonatomic) IBOutlet UILabel *fbuserEmailLabel;


@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fbuserEmailLabel.text = _fbuserEmailText;
    _fbuserNameLabel.text = _fbuserNameText;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSURL *imageURL = [NSURL URLWithString:_imageURLString];
        DLog(@"urlString %@", _imageURLString);
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _fbuserProfileView.image = image;
            });
        }
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
