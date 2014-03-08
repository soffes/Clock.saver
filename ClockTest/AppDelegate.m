//
//  AppDelegate.m
//  ClockTest
//
//  Created by Sam Soffes on 3/8/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import "AppDelegate.h"
#import "ClockView.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self.clockView startAnimation];
	[NSTimer scheduledTimerWithTimeInterval:[self.clockView animationTimeInterval] target:self.clockView selector:@selector(animateOneFrame) userInfo:nil repeats:YES];
}

@end
