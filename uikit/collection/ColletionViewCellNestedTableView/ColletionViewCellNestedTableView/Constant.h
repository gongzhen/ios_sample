//
//  Constant.h
//  ColletionViewCellNestedTableView
//
//  Created by zhen gong on 7/12/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#ifndef Constant_h
#define Constant_h


//
//  Constants.h
//  Mobile Styles
//
//  Created by Reza Fatahi on 11/27/16.
//  Copyright © 2016 USA Link Systems. All rights reserved.
//


#ifndef Constants_h
#define Constants_h

// fonts
#define K_FONT_SHREE @"ShreeDev0714"
#define K_FONT_SHREE_BOLD @"ShreeDev0714-Bold"
#define K_FONT_SHREE_ITALIC @"ShreeDev0714-Italic"

// font sizes
#define K_FONT_SIZE_MAX 27.0f
#define K_FONT_SIZE_LARGE 19.0f
#define K_FONT_SIZE_MENU 16.5f
#define K_FONT_SIZE_SERVICES 15.0f
#define K_FONT_SIZE_REGULAR 11.5f
#define K_FONT_SIZE_SMALL 10.0f
#define K_FONT_SIZE_FINE 8.0f

// keys, strings
#define K_GOOGLE_MAPS_KEY @"AIzaSyCdkqLeBV-RT1mbsv37DbJIN4qddd4Qacc"
//#define K_STRIPE_KEY @"pk_test_YLIou4HBf0HeDdBaMUbch5th" // publishable key
#define K_STRIPE_KEY @"pk_live_F6ng78x03qh2ytpdyCGK9bru" // publishable key
#define K_MS_SOCIAL_KEY @"MSKEYREPOKAR123fili@flyingnaso!djk"
#define K_BASE_URL /*@"http://10.10.10.106:4969"*/ @"https://api.mobilestyles.com"
#define K_IMAGE_DEFAULT_PLACEHOLDER @"user"
#define K_CLOCK_IMAGE @"MS_Clock-Graphic"
#define K_SHOWTELL_SELFIE @"MS_Selfie-Icon"
#define K_SHOWTELL_STYLE @"MS_Style-Photo_Icon"
#define K_SHOWTELL_TELL @"MS_Tell-Me_Icon"
#define K_LOGO_IMG  @"MS_logo"
#define K_FACEBOOK_LOGIN @"MS_Facebook_Login_Icon"
#define K_GOOGLE_LOGIN @"MS_Google+_Login_Icon"
#define K_FACEBOOK_REGISTER @"MS_SignUp_Facebook"
#define K_GOOGLE_REGISTER @"MS_SignUp_Google"
#define K_PAGINATION_RIGHT_DASHBOARD @"MS_RightArrow_V2"
#define K_PAGINATION_LEFT_DASHBOARD @"MS_LeftArrow_V2"
#define K_EMPTY_RATING_STAR @"MS_Star_Outline"
#define K_FILLED_RATING_STAR @"MS_Star_Fill"
#define K_PORTFOLIO_CHECKMARK @"MS_Portfolio_Check-Mark"
#define K_LEFT_YELLOW_ARROW @"MS_Left_Yellow_Arrow"
#define K_RIGHT_YELLOW_ARROW @"MS_Right_Yellow_Arrow"

// views
#define K_HAMBURGER_BANNER_HEIGHT 66.0f
#define K_TITLE_BANNER_SINGLE_HEIGHT 80.0f
#define K_TITLE_BANNER_MULTI_HEIGHT 100.0f
#define K_REGULAR_BANNER_HEIGHT 60.0f
#define K_MEDIUM_BANNER_HEIGHT 50.0f
#define K_LARGE_BANNER_HEIGHT 80.0f
#define K_PROFESSIONAL_HEADER_SUBTITLE 12.0f
#define K_PROFESSIONAL_HEADER_REMAINING 70.0f
#define K_PROFESSIONAL_ORDER_CELL 80.0f
#define K_DELEGATIONS_ORDER_DETAIL_BUTTON_H_W 40.0f

// text areas
#define K_TITLE_HEIGHT 40.0f
#define K_SUBTITLE_HEIGHT 33.3f
#define K_MINISUB_HEIGHT 16.0f
#define K_TEXTFIELD_HEIGHT 40.0f
#define K_BUTTONFIELD_EXTENDED_HEIGHT 60.0f
#define K_BUTTONFIELD_HEIGHT 40.0f
#define K_FIELD_SMALL_HEIGHT 24.0f

// offsets, design variables
#define K_STANDARD_X_OFFSET 20.0f
#define K_STANDARD_FIELD_GAP 10.0f
#define K_THICK_FIELD_BORDER 2.0f
#define K_THIN_FIELD_BORDER 0.6f
#define K_MINIMAL_PADDING 3.0f

// colors
#define K_COLOR_WHITE [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0]
#define K_COLOR_BLACK [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0]
#define K_COLOR_YELLOW [UIColor colorWithRed:0.98 green:0.87 blue:0.07 alpha:1.0]
#define K_COLOR_LIGHT_GRAY [UIColor colorWithRed:0.30 green:0.30 blue:0.31 alpha:1.0]
#define K_COLOR_DARK_GRAY [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1.0]
#define K_COLOR_GREEN [UIColor colorWithRed:0.13 green:0.68 blue:0.29 alpha:1.0]
#define K_COLOR_RED [UIColor colorWithRed:0.76 green:0.13 blue:0.15 alpha:1.0]
#define K_COLOR_CLEAR [UIColor clearColor]

// kerning
#define K_KERNING_MAX @(2.0)
#define K_KERNING_REGULAR @(1.5)
#define K_KERNING_SMALL @(1.0)
#define K_KERNING_MIN @(0.5)

// keys constants
// used for identifiers
// and MSUserSession
#define ACTIVE_VIEW_SHOWING @"activeViewShowing"
#define ACTIVE_APPOINTMENT_STATE @"active"
#define ACTIVE_APPOINTMENT_OBJECT @"state"
#define MAIN_USER_OBJECT @"me"
#define HEADER_AUTH_TOKEN @"token"
#define PAYMENT_CONFIGURATIONS @"paymentConfigs"
#define USER_HAS_CREDIT_CARD @"hasCC"
#define __USER__ @"user"
#define __PROFESSIONAL__ @"professional"
#define __CUSTOMER__ @"customer"
#define __FAVORITES__ @"favorites"
#define __PORTFOLIO__ @"portfolio"
#define MS_DATE @"date"
#define USER_SESSION @"session"
#define CONTEXT_SWITCH @"switch"
#define DEVICE_TOKEN @"device_token"
#define PORTFOLIO_SIZES @"portfolio_sizes"

// convenience macros
// used for readability
// common dictionary operations



#endif /* Constants_h */


#endif /* Constant_h */
