//
//  ThirdPartyLoginManager.m
//  FBSDKObjC_Login
//
//  Created by gongzhen on 12/8/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ThirdPartyLoginManager.h"
#import "FBUser.h"

typedef NS_ENUM (NSUInteger, AuthenticationType) {
    NotAuthenticated,
    GoogleToken,
    FacebookToken
};

@interface FacebookService : NSObject

- (void)authenticateByFacebookToken:(NSString *)token completionHandler:(void(^)(FBUser *user, NSError *error))completion;

@end

@implementation FacebookService

- (void)authenticateByFacebookToken:(NSString *)token completionHandler:(void(^)(FBUser *user, NSError *error))completion {
    if (!token) {
        return;
    }
    NSData *httpBody = [self buildFacebookSessionBodyWithFacebookToken:token];
    DLog(@"httpBody %@", httpBody);
    [self authenticateUsingHttpBody:httpBody completionHandler:completion];
}

- (void)authenticateUsingHttpBody:(NSData *)httpBody completionHandler:(void(^)(FBUser *user, NSError* error))completion {
    
}

- (void)createHttpRequestUsingMethod:(NSString *)method forUrlString:(NSString *)urlString withBody:(NSData *)body includeHeaders:(NSDictionary *)requestHeaders  {
    
}

- (NSData *)buildFacebookSessionBodyWithFacebookToken:(NSString *)facebookToken {
    return [[NSString stringWithFormat:@"{\"facebook_mobile\": {\"access_token\": \"%@\"}}", facebookToken] dataUsingEncoding:NSUTF8StringEncoding];
}

@end

@interface ThirdPartyLoginManager()

@property (nonatomic, strong) FacebookService* facebookService;

@end

static ThirdPartyLoginManager *_instance = nil;

@implementation ThirdPartyLoginManager

+ (ThirdPartyLoginManager *)sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[ThirdPartyLoginManager alloc] init];
            
        }
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _facebookService = [[FacebookService alloc] init];
    }
    return self;
}

- (void)authenticateByFacebookToken:(NSString *)token
                  completionHandler:(void (^)(BOOL success, NSError *error))completion {
    [_facebookService authenticateByFacebookToken:token completionHandler:^(FBUser *user, NSError *error) {
        [self handleLoginResponseForUser:user withAuthType:FacebookToken error:error completionHandler:completion];
    }];
}

- (void)handleLoginResponseForUser:(FBUser *)user withAuthType:(AuthenticationType)authType error:(NSError *)error completionHandler:(void(^)(BOOL success, NSError *error))completion {
    
    
}

@end
