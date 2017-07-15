//
//  MSCustomElements.m
//  ColletionViewCellNestedTableView
//
//  Created by zhen gong on 7/12/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "MSCustomElements.h"
#import "Constant.h"

@implementation MSCustomElements

#pragma mark - life cycle
+ (id)sharedManager {
    static MSCustomElements *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSAttributedString *)attributedYellowStringWithFontSize:(CGFloat)fontSize fontStyle:(int)style string:(NSString *)string alignment:(NSTextAlignment)alignment adjustLineHeight:(BOOL)adjust andKerning:(NSNumber *)kerning {
    if (string == nil) string = @"";
    UIFont* font = [UIFont fontWithName: [self fontNameWithStyle:style] size: fontSize];
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString: string];
    UIColor* desiredColor = K_COLOR_YELLOW;
    NSMutableParagraphStyle* alignmentSetting = [[NSMutableParagraphStyle alloc] init];
    alignmentSetting.alignment = alignment;
    if (adjust) alignmentSetting.minimumLineHeight = font.lineHeight * 1.4;
    
    NSDictionary* attributes = @{
                                 NSFontAttributeName: font,
                                 NSKernAttributeName: kerning,
                                 NSForegroundColorAttributeName : desiredColor,
                                 NSParagraphStyleAttributeName : alignmentSetting
                                 };
    
    [attrStr addAttributes:attributes range:NSMakeRange(0, attrStr.length)];
    return attrStr;
}


- (NSString *)fontNameWithStyle:(int)style {
    NSString* fontName;
    switch (style) {
            case 0:
            fontName = K_FONT_SHREE;
            break;
            case 1:
            fontName = K_FONT_SHREE_BOLD;
            break;
            case 2:
            fontName = K_FONT_SHREE_ITALIC;
            break;
        default:
            break;
    }
    return fontName;
}

// attributed strings
- (NSAttributedString *)attributedStringWithFontSize:(CGFloat)fontSize fontStyle:(int)style string:(NSString *)string alignment:(NSTextAlignment)alignment adjustLineHeight:(BOOL)adjust andKerning:(NSNumber *)kerning {
    if (string == nil) string = @"";
    UIFont* font = [UIFont fontWithName: [self fontNameWithStyle:style] size: fontSize];
    return [self attributedStringWithKerningFromString: string kerningAmount: kerning alignment: alignment adjustLineHeight: adjust andFont: font];
}

- (NSAttributedString *)attributedStringWithKerningFromString:(NSString *)string kerningAmount:(NSNumber *)kerning alignment:(NSTextAlignment)alignment adjustLineHeight:(BOOL)adjust andFont:(UIFont *)font {
    if (string == nil) string = @"";
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString: string];
    UIColor* desiredColor = K_COLOR_WHITE;
    NSMutableParagraphStyle* alignmentSetting = [[NSMutableParagraphStyle alloc] init];
    alignmentSetting.alignment = alignment;
    if (adjust) alignmentSetting.minimumLineHeight = font.lineHeight * 1.4;
    
    NSDictionary* attributes = @{
                                 NSFontAttributeName: font,
                                 NSKernAttributeName: kerning,
                                 NSForegroundColorAttributeName : desiredColor,
                                 NSParagraphStyleAttributeName : alignmentSetting
                                 };
    
    [attrStr addAttributes:attributes range:NSMakeRange(0, attrStr.length)];
    return attrStr;
}

@end
