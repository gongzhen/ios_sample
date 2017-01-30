//
//  SUCache.m
//  FBSDKObjC_Login_Jianshu
//
//  Created by gongzhen on 12/9/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "SUCache.h"

#import <Foundation/Foundation.h>
#import <Security/Security.h>

static NSString *const kCacheVersion = @"v2";

#define USER_DEFAULTS_INSTALLED_KEY @"com.facebook.sdk.samples.switchuser.installed"

@implementation SUCache

+ (void)initialize
{
    if (self == [SUCache class]) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULTS_INSTALLED_KEY]) {
            [SUCache clearCache];
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_DEFAULTS_INSTALLED_KEY];
    }
}

+ (NSString *)keychainKeyForSlot:(NSInteger)slot
{
    return [NSString stringWithFormat:@"%@%lu", kCacheVersion, (unsigned long)slot];
}

+ (void)saveItem:(SUCacheItem *)item slot:(NSInteger)slot
{
    // Delete any old values
    [self deleteItemInSlot:slot];
    
    NSString *key = [self keychainKeyForSlot:slot];
    NSString *error;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
    if (error) {
        NSLog(@"Failed to serialize item for insertion into keychain:%@", error);
        return;
    }
    NSDictionary *keychainQuery = @{
                                    (__bridge id)kSecAttrAccount : key,
                                    (__bridge id)kSecValueData : data,
                                    (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                    (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                    };
    OSStatus result = SecItemAdd((__bridge CFDictionaryRef)keychainQuery, nil);
    if(result != noErr){
        NSLog(@"Failed to add item to keychain");
        return;
    }
}

+ (void)deleteItemInSlot:(NSInteger)slot
{
    NSString *key = [self keychainKeyForSlot:slot];
    NSDictionary *keychainQuery = @{
                                    (__bridge id)kSecAttrAccount : key,
                                    (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                    (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                    };
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef) keychainQuery);
    if(result != noErr){
        return;
    }
}

+ (SUCacheItem *)itemForSlot:(NSInteger)slot
{
    NSString *key = [self keychainKeyForSlot:slot];
    NSDictionary *keychainQuery = @{
                                    (__bridge id)kSecAttrAccount : key,
                                    (__bridge id)kSecReturnData : (__bridge id)kCFBooleanTrue,
                                    (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword
                                    };
    
    CFDataRef serializedDictionaryRef;
    OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&serializedDictionaryRef);
    if(result == noErr) {
        NSData *data = (__bridge_transfer NSData*)serializedDictionaryRef;
        if (data) {
            return [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return nil;
}

+ (void)clearCache
{
    NSArray *secItemClasses = @[(__bridge id)kSecClassGenericPassword,
                                (__bridge id)kSecClassInternetPassword,
                                (__bridge id)kSecClassCertificate,
                                (__bridge id)kSecClassKey,
                                (__bridge id)kSecClassIdentity];
    for (id secItemClass in secItemClasses) {
        NSDictionary *spec = @{(__bridge id)kSecClass: secItemClass};
        SecItemDelete((__bridge CFDictionaryRef)spec);
    }
}

@end