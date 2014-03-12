//
//  SAMClockView.h
//  Clock
//
//  Created by Sam Soffes on 3/8/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ScreenSaver/ScreenSaver.h>

extern NSString *const SAMClockConfigurationDidChangeNotificationName;

extern NSString *const SAMClockDefaultsModuleName;
extern NSString *const SAMClockStyleDefaultsKey;
extern NSString *const SAMClockTickMarksDefaultsKey;
extern NSString *const SAMClockNumbersDefaultsKey;
extern NSString *const SAMClockDateDefaultsKey;
extern NSString *const SAMClockLogoDefaultsKey;

typedef NS_ENUM(NSUInteger, SAMClockFaceStyle) {
	SAMClockFaceStyleLight,
	SAMClockFaceStyleDark
};

@interface SAMClockView : ScreenSaverView

@property (nonatomic) SAMClockFaceStyle faceStyle;
@property (nonatomic) BOOL drawsTicks;
@property (nonatomic) BOOL drawsNumbers;
@property (nonatomic) BOOL drawsDate;
@property (nonatomic) BOOL drawsLogo;

@end
