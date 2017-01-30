//
//  main.m
//  NSStringSearch
//
//  Created by gongzhen on 1/27/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSString* methodName = @"consumer/payment/:provider/cards/:id";
        NSMutableString *url = [NSMutableString new];
        
        NSDictionary *params = @{@"id": @"card_19gdv0I1HaTXKarVwGFXDHCa", @"provider": @"stripe"};
        
        NSRange searchRange = NSMakeRange(0, methodName.length);
        NSRange foundRange;
        NSRange endSlash;
        while(searchRange.location < methodName.length) {
            searchRange.length = methodName.length - searchRange.location;
            foundRange = [methodName rangeOfString:@"/:" options:NSCaseInsensitiveSearch range:searchRange];
            if (foundRange.location != NSNotFound) {
                [url appendString:[methodName substringWithRange:NSMakeRange(searchRange.location, (foundRange.location - searchRange.location + 1))]];
                NSUInteger startIndex = foundRange.location + 2;
                NSRange restStringRange = NSMakeRange(startIndex, methodName.length - startIndex);
                endSlash = [methodName rangeOfString:@"/" options:NSCaseInsensitiveSearch range:restStringRange];
                if (endSlash.location == NSNotFound) {
                    NSString *key = [methodName substringFromIndex:startIndex];
                    if ([params objectForKey:key]) {
                        DLog(@"%@", key);
                        [url appendString:[params objectForKey:key]];
                    }
                    break;
                } else {
                    NSString *key = [methodName substringWithRange:NSMakeRange(startIndex, endSlash.location - startIndex)];
                    if ([params objectForKey:key]) {
                        DLog(@"%@", key);
                        [url appendString:[params objectForKey:key]];
                        [url appendString:@"/"];
                        DLog(@"%@", url);
                    }
                    searchRange.location = endSlash.location + 1;
                }
            } else {
                break;
            }
        }
        
        DLog(@"%@", url);
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/:" options:NSRegularExpressionCaseInsensitive error:&error];
        methodName = [regex stringByReplacingMatchesInString:methodName options:0 range:NSMakeRange(0, methodName.length) withTemplate:@"/"];
        DLog(@"%@", methodName);
    }
    return 0;
}
