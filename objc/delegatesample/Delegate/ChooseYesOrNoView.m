//
//  ChooseYesOrNoView.m
//  Delegate
//
//  Created by zhen gong on 5/22/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ChooseYesOrNoView.h"

@implementation ChooseYesOrNoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (ChooseYesOrNoView *) display
{
    UIView *chooseView = [[UIView alloc]initWithFrame: CGRectMake(50,50,200,100)];
    [self addSubview:chooseView];
    UILabel *pleaseChooseLabel = [[UILabel alloc]initWithFrame: CGRectMake(0,0,260,20)];
    pleaseChooseLabel.text = @"Please choose Yes or No";
    [chooseView addSubview:pleaseChooseLabel];
    
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    yesButton.tag = 1;
    [yesButton addTarget:self
                  action:@selector(buttonTapped:)
        forControlEvents:UIControlEventTouchDown];
    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    yesButton.frame = CGRectMake(50, 60, 60, 40);
    [self addSubview:yesButton];
    
    UIButton *noButton = [UIButton buttonWithType:UIButtonTypeSystem];
    noButton.tag = 0;
    [noButton addTarget:self
                 action:@selector(buttonTapped:)
       forControlEvents:UIControlEventTouchDown];
    [noButton setTitle:@"No" forState:UIControlStateNormal];
    noButton.frame = CGRectMake(160, 60, 60, 40);
    [self addSubview:noButton];
    
    return self;
}

- (void) buttonTapped: (UIButton*) sender
{
    BOOL response;
    if(sender.tag==1) response = YES;
    else response = NO;
    if([self.delegate respondsToSelector:@selector(chooseYesOrNoResponse:)]) {
        [self.delegate chooseYesOrNoResponse:response];
    }
}

@end
