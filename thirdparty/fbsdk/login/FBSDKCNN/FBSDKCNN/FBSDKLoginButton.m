//
//  FBSDKLoginButton.m
//  FBSDKCNN
//
//  Created by gongzhen on 1/14/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "FBSDKLoginButton.h"
#import "FBSDKCoreKit+Internal.h"
#import "FBSDKLoginManager.h"
#import "FBSDKGraphRequest.h"
#import "FBSDKGraphRequest+Internal.h"

@interface FBSDKLoginButton() <FBSDKButtonImpressionTracking, UIActionSheetDelegate>
@end

@implementation FBSDKLoginButton
{
    BOOL _hasShownTooltipBubble;
    FBSDKLoginManager *_loginManager;
    NSString *_userID;
    NSString *_userName;
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

//- (FBSDKDefaultAudience)defaultAudience
//{
//    return _loginManager.defaultAudience;
//}
//

//- (void)setDefaultAudience:(FBSDKDefaultAudience)defaultAudience
//{
//    _loginManager.defaultAudience = defaultAudience;
//}

//- (FBSDKLoginBehavior)loginBehavior
//{
//    return _loginManager.loginBehavior;
//}

//- (void)setLoginBehavior:(FBSDKLoginBehavior)loginBehavior
//{
//    _loginManager.loginBehavior = loginBehavior;
//}

#pragma mark - UIView

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
//    if (self.window && ((self.tooltipBehavior == FBSDKLoginButtonTooltipBehaviorForceDisplay)
//                        || !_hasShownTooltipBubble)) {
//        [self performSelector:@selector(_showTooltipIfNeeded) withObject:nil afterDelay:0];
//        _hasShownTooltipBubble = YES;
//    }
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGSize size = self.bounds.size;
    CGSize longTitleSize = [self sizeThatFits:size title:[self _longLogInTitle]];
    NSString *title = (longTitleSize.width <= size.width ?
                       [self _longLogInTitle] :
                       [self _shortLogInTitle]);
    if (![title isEqualToString:[self titleForState:UIControlStateNormal]]) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    
    [super layoutSubviews];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if ([self isHidden]) {
        return CGSizeZero;
    }

    CGSize selectedSize = [self sizeThatFits:size title:[self _logOutTitle]];
    CGSize normalSize = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, size.height) title:[self _longLogInTitle]];
    if (normalSize.width > size.width) {
        return normalSize = [self sizeThatFits:size title:[self _shortLogInTitle]];
    }
    return CGSizeMake(MAX(normalSize.width, selectedSize.width), MAX(normalSize.height, selectedSize.height));
}

#pragma mark - UIActionSheetDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0) {
//        [_loginManager logOut];
//        [self.delegate loginButtonDidLogOut:self];
//    }
}
#pragma clang diagnostic pop

#pragma mark - FBSDKButtonImpressionTracking

- (NSDictionary *)analyticsParameters
{
    return nil;
}

- (NSString *)impressionTrackingEventName
{
    return FBSDKAppEventNameFBSDKLoginButtonImpression;
}

- (NSString *)impressionTrackingIdentifier
{
    return @"login";
}

#pragma mark - FBSDKButton

- (void)configureButton
{
    _loginManager = [[FBSDKLoginManager alloc] init];
    
    NSString *logInTitle = [self _shortLogInTitle];
    NSString *logOutTitle = [self _logOutTitle];
    
    [self configureWithIcon:nil
                      title:logInTitle
            backgroundColor:[super defaultBackgroundColor]
           highlightedColor:nil
              selectedTitle:logOutTitle
               selectedIcon:nil
              selectedColor:[super defaultBackgroundColor]
   selectedHighlightedColor:nil];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self _updateContent];
    
    [self addTarget:self action:@selector(_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(_accessTokenDidChangeNotification:)
//                                                 name:FBSDKAccessTokenDidChangeNotification
//                                               object:nil];
}


#pragma mark - Helper Methods

- (NSString *)_logOutTitle
{
    return NSLocalizedStringWithDefaultValue(@"LoginButton.LogOut", @"FacebookSDK", [FBSDKInternalUtility bundleForStrings],
                                             @"Log out",
                                             @"The label for the FBSDKLoginButton when the user is currently logged in");
    ;
}

- (NSString *)_longLogInTitle
{
    return NSLocalizedStringWithDefaultValue(@"LoginButton.LogInLong", @"FacebookSDK", [FBSDKInternalUtility bundleForStrings],
                                             @"Log in with Facebook",
                                             @"The long label for the FBSDKLoginButton when the user is currently logged out");
}

- (NSString *)_shortLogInTitle
{
    return NSLocalizedStringWithDefaultValue(@"LoginButton.LogIn", @"FacebookSDK", [FBSDKInternalUtility bundleForStrings],
                                             @"Log in",
                                             @"The short label for the FBSDKLoginButton when the user is currently logged out");
}

- (void)_updateContent
{
    self.selected = ([FBSDKAccessToken currentAccessToken] != nil);
    if ([FBSDKAccessToken currentAccessToken]) {
        if (![[FBSDKAccessToken currentAccessToken].userID isEqualToString:_userID]) {
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me?fields=id,name"
                                                                           parameters:nil
                                                                                flags:FBSDKGraphRequestFlagDisableErrorRecovery];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                NSString *userID = [FBSDKTypeUtility stringValue:result[@"id"]];
                if (!error && [[FBSDKAccessToken currentAccessToken].userID isEqualToString:userID]) {
                    _userName = [FBSDKTypeUtility stringValue:result[@"name"]];
                    _userID = userID;
                }
            }];
        }
    }
}

+ (void)_accessTokenDidChangeNotification:(NSNotification *)notification
{
//    NSString *accessTokenString = [FBSDKAccessToken currentAccessToken].tokenString;
//    if ([accessTokenString isEqualToString:_cache.accessTokenString]) {
//        return;
//    }
//    [_cache resetForAccessTokenString:accessTokenString];
//    [[NSNotificationCenter defaultCenter] postNotificationName:FBSDKLikeActionControllerDidResetNotification object:nil];
}

@end
