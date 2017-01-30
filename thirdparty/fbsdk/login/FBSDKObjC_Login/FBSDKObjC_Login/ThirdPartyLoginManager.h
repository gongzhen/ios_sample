//
//  ThirdPartyLoginManager.h
//  FBSDKObjC_Login
//
//  Created by gongzhen on 12/8/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBUser.h"

@interface ThirdPartyLoginManager : NSObject

+ (ThirdPartyLoginManager *)sharedInstance;

// Login method
- (void)authenticateByFacebookToken:(NSString *)token
                  completionHandler:(void (^)(BOOL success, NSError *error))completion;

@end
