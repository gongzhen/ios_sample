//
//  CaknowClient.m
//  CaknowGZ
//
//  Created by gongzhen on 3/14/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "CaknowClient.h"
#import "GarageViewController.h"
#import "PostConsumerEntity.h"

// Internal
static NSString * const kCaknowClientAPIURL = @"https://staging.caknow.com/";
static NSString * const kRefreshToken = @"refreshToken";
static NSString * const kAccessToken = @"accessToken";

@interface CaknowClient()

@property (nonatomic, copy) NSString *service;

@end

@implementation CaknowClient

+ (CaknowClient *)sharedInstance {
    static CaknowClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
//        NSURL *baseURL = [NSURL URLWithString:kCaknowClientAPIURL];
//        _service = baseURL.host;
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(Boolean verified, NSError * error))completion {
    NSDictionary *parameters = @{@"email": [username lowercaseString], @"password": password};
    [[HttpRequestManager sharedInstance] create:@"consumer"
                                     parameters:parameters
                                        success:^(id resultObj) {
                                            PostConsumerEntity *postConsumerEntity = resultObj;
                                            [self saveAccessToken:postConsumerEntity.token service:kAccessToken];
                                            [self saveAccessToken:postConsumerEntity.refreshToken service:kRefreshToken];
                                            [[HttpRequestManager sharedInstance] setAccessToken:[self getAccessToken:kAccessToken]];
                                            completion(postConsumerEntity.verified, nil);
                                        } failure:^(NSError *error) {
                                            completion(false, error);
                                        }];
}

#pragma mark Access Token
static NSDictionary *OAuthKeychainDictionaryForService(NSString *service) {
    return @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
             (__bridge id)kSecAttrService:service};
}

- (NSString *)getAccessToken:(NSString *)service {
    NSMutableDictionary *dictionary = [OAuthKeychainDictionaryForService(service) mutableCopy];
    dictionary[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    dictionary[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    
    CFDataRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dictionary, (CFTypeRef *)&result);
    NSData *data = (__bridge_transfer NSData *)result;
    
    if (status == noErr && data)
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    else
        return nil;
}

- (BOOL)saveAccessToken:(NSString *)accessToken service:(NSString *)service {
    NSMutableDictionary *dictionary = [OAuthKeychainDictionaryForService(service) mutableCopy];
    NSMutableDictionary *updateDictionary = [NSMutableDictionary dictionary];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
    updateDictionary[(__bridge id)kSecValueData] = data;
    
    OSStatus status;
    if ([self accessToken]) {
        status = SecItemUpdate((__bridge CFDictionaryRef)dictionary, (__bridge CFDictionaryRef)updateDictionary);
    } else {
        [dictionary addEntriesFromDictionary:updateDictionary];
        status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    }
    
    if (status == noErr) {
        return YES;
    }    
    return NO;
}

- (BOOL)removeAccessToken:(NSString *)service {
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)OAuthKeychainDictionaryForService(service));
    if (status == noErr)
        return YES;
    else
        return NO;
}

@end
