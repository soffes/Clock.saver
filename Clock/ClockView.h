//
//  ClockView.h
//  Clock
//
//  Created by Sam Soffes on 3/8/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

typedef NS_ENUM(NSUInteger, ClockViewStyle) {
	ClockViewStyleWhite,
	ClockViewStyleBlack
};

@interface ClockView : ScreenSaverView

@property (nonatomic) ClockViewStyle clockStyle;
@end
