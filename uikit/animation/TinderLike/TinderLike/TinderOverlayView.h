//
//  TinderOverlayView.h
//  TinderLike
//
//  Created by zhen gong on 5/25/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TinderOverlayMode) {
    TinderOverlayModeLeft,
    TinderOverlayModeRight
};

@interface TinderOverlayView : UIView

@property(nonatomic)TinderOverlayMode mode;

@end
