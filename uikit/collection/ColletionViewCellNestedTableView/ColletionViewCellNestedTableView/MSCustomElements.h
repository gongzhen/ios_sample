//
//  MSCustomElements.h
//  ColletionViewCellNestedTableView
//
//  Created by zhen gong on 7/12/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSCustomElements : NSObject

+ (id)sharedManager;

// font name
- (NSString *)fontNameWithStyle:(int)style;

- (NSAttributedString *)attributedYellowStringWithFontSize:(CGFloat)fontSize fontStyle:(int)style string:(NSString *)string alignment:(NSTextAlignment)alignment adjustLineHeight:(BOOL)adjust andKerning:(NSNumber *)kerning;

- (NSAttributedString *)attributedStringWithFontSize:(CGFloat)fontSize fontStyle:(int)style string:(NSString *)string alignment:(NSTextAlignment)alignment adjustLineHeight:(BOOL)adjust andKerning:(NSNumber *)kerning;

@end
