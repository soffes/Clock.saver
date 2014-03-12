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

typedef NS_ENUM(NSUInteger, SAMClockViewStyle) {
	SAMClockViewStyleLightFace,
	SAMClockViewStyleDarkFace
};

@interface SAMClockView : ScreenSaverView

@property (nonatomic) SAMClockViewStyle clockStyle;
@property (nonatomic) BOOL drawsTicks;
@property (nonatomic) BOOL drawsNumbers;
@property (nonatomic) BOOL drawsDate;

@end
