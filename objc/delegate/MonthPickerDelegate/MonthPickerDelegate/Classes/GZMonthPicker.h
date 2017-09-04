//
//  GZMonthPicker.h
//  MonthPickerDelegate
//
//  Created by zhen gong on 9/2/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GZMonthPicker;

@protocol GZMonthPickerDelegate <NSObject>

@optional

- (void)monthPickerWillChangeDate:(GZMonthPicker *)monthPicker;

- (void)monthPickerDidChangeDate:(GZMonthPicker *)monthPicker;

@end

@interface GZMonthPicker : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<GZMonthPickerDelegate> monthPickerDelegate;

@property (nonatomic, strong) NSDate* date;

/// The calendar currently being used
@property (nonatomic, strong, readonly) NSCalendar *calendar;

/// The minimum year that a month picker can show.
@property (nonatomic) NSInteger minimumYear;

/// The maximum year that a month picker can show.
@property (nonatomic) NSInteger maximumYear;

/// A Boolean value that determines whether the year is shown first.
@property (nonatomic) BOOL yearFirst;

/// A Boolean value that determines whether the month wraps
@property (nonatomic) BOOL wrapMonths;

/// en-US alias for `enableColourRow`.
@property (nonatomic, getter = enableColourRow, setter = setEnableColourRow:) BOOL enableColorRow;

/// A Boolean value that determines whether the current month & year are coloured.
@property (nonatomic) BOOL enableColourRow;

/// Font to be used for all rows.  Default: System Bold, size 24.
@property (nonatomic, strong) UIFont *font;

/// Colour to be used for all "non coloured" rows.  Default: Black.
@property (nonatomic, strong) UIColor *fontColour;

/// en-US alias for `fontColour`.
@property (nonatomic, strong, getter = fontColour, setter = setFontColour:) UIColor *fontColor;

-(id)init;

-(id)initWithDate:(NSDate *)date;

-(id)initWithDate:(NSDate *)date calendar:(NSCalendar *)calendar;

@end
