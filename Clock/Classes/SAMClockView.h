//
//  SAMClockView.h
//  Clock
//
//  Created by Sam Soffes on 3/8/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

@import Cocoa;
@import ScreenSaver;

extern NSString *const SAMClockConfigurationDidChangeNotificationName;
extern NSString *const SAMClockDefaultsModuleName;
extern NSString *const SAMClockStyleDefaultsKey;
extern NSString *const SAMClockBackgroundStyleDefaultsKey;
extern NSString *const SAMClockTickMarksDefaultsKey;
extern NSString *const SAMClockNumbersDefaultsKey;
extern NSString *const SAMClockDateDefaultsKey;
extern NSString *const SAMClockLogoDefaultsKey;

typedef NS_ENUM(NSUInteger, SAMClockStyle) {
	SAMClockStyleLight,
	SAMClockStyleDark
};

@interface SAMClockView : ScreenSaverView

@property (nonatomic) SAMClockStyle faceStyle;
@property (nonatomic) SAMClockStyle backgroundStyle;
@property (nonatomic) BOOL drawsTicks;
@property (nonatomic) BOOL drawsNumbers;
@property (nonatomic) BOOL drawsDate;
@property (nonatomic) BOOL drawsLogo;

@end
