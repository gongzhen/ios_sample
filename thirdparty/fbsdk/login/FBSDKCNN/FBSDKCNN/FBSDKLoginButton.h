//
//  FBSDKLoginButton.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/14/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "FBSDKButton.h"
#import "FBSDKLoginManagerLoginResult.h"

@protocol FBSDKLoginButtonDelegate;

@interface FBSDKLoginButton : FBSDKButton

/**
 Gets or sets the delegate.
 */
@property (weak, nonatomic) id<FBSDKLoginButtonDelegate> delegate;

@end

@protocol FBSDKLoginButtonDelegate <NSObject>

@required
/**
 Sent to the delegate when the button was used to login.
 - Parameter loginButton: the sender
 - Parameter result: The results of the login
 - Parameter error: The error (if any) from the login
 */
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error;


/**
 Sent to the delegate when the button was used to logout.
 - Parameter loginButton: The button that was clicked.
 */
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton;

@optional
/**
 Sent to the delegate when the button is about to login.
 - Parameter loginButton: the sender
 - Returns: YES if the login should be allowed to proceed, NO otherwise
 */
- (BOOL) loginButtonWillLogin:(FBSDKLoginButton *)loginButton;


@end
