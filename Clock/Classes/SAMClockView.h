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

typedef NS_ENUM(NSUInteger, SAMClockViewStyle) {
	SAMClockViewStyleDark,
	SAMClockViewStyleLight
};

@interface SAMClockView : ScreenSaverView

@property (nonatomic) SAMClockViewStyle clockStyle;
@property (nonatomic) BOOL drawsTicks;

@end
