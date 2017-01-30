//
//  FBSDKButton+Subclass.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/13/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "FBSDKButton.h"

@protocol FBSDKButtonImpressionTracking <NSObject>

- (NSDictionary *)analyticsParameters;
- (NSString *)impressionTrackingEventName;
- (NSString *)impressionTrackingIdentifier;

@end

@interface FBSDKButton (Subclass)

- (void)logTapEventWithEventName:(NSString *)eventName
                      parameters:(NSDictionary *)parameters;
- (void)checkImplicitlyDisabled;
- (void)configureButton;
- (void)configureWithIcon:(FBSDKIcon *)icon
                    title:(NSString *)title
          backgroundColor:(UIColor *)backgroundColor
         highlightedColor:(UIColor *)highlightedColor;
- (void)configureWithIcon:(FBSDKIcon *)icon
                    title:(NSString *)title
          backgroundColor:(UIColor *)backgroundColor
         highlightedColor:(UIColor *)highlightedColor
            selectedTitle:(NSString *)selectedTitle
             selectedIcon:(FBSDKIcon *)selectedIcon
            selectedColor:(UIColor *)selectedColor
 selectedHighlightedColor:(UIColor *)selectedHighlightedColor;

- (UIColor *)defaultBackgroundColor;
- (UIColor *)defaultDisabledColor;
- (UIFont *)defaultFont;
- (UIColor *)defaultHighlightedColor;
- (FBSDKIcon *)defaultIcon;
- (UIColor *)defaultSelectedColor;
- (BOOL)isImplicitlyDisabled;
- (CGSize)sizeThatFits:(CGSize)size title:(NSString *)title;

@end
