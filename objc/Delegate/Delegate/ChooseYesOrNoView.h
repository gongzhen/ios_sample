//
//  ChooseYesOrNoView.h
//  Delegate
//
//  Created by zhen gong on 5/22/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseYesOrNoViewDelegate <NSObject>

- (void) chooseYesOrNoResponse: (BOOL) response;

@end

@interface ChooseYesOrNoView : UIView

@property (nonatomic, weak) id delegate;

- (ChooseYesOrNoView *) display;

@end
