//
//  FBSDKUIUtility.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/14/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#ifndef FBSDKUIUtility_h
#define FBSDKUIUtility_h
#import "FBSDKMacros.h"
#import "FBSDKMath.h"

#import <UIKit/UIKit.h>

FBSDK_STATIC_INLINE CGSize FBSDKTextSize(NSString *text,
                                         UIFont *font,
                                         CGSize constrainedSize,
                                         NSLineBreakMode lineBreakMode)
{
    if (!text) {
        return CGSizeZero;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{
                                 NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    CGSize size = [FBSDKMath ceilForSize:[attributedString boundingRectWithSize:constrainedSize
                                                                        options:(NSStringDrawingUsesDeviceMetrics |
                                                                                 NSStringDrawingUsesLineFragmentOrigin |
                                                                                 NSStringDrawingUsesFontLeading)
                                                                        context:NULL].size];
    return [FBSDKMath ceilForSize:size];
}

#endif /* FBSDKUIUtility_h */
