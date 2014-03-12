//
//  AppDelegate.m
//  ClockTest
//
//  Created by Sam Soffes on 3/8/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import "AppDelegate.h"
#import "SAMClockView.h"

@interface AppDelegate ()
@property (nonatomic) ScreenSaverView *clockView;
@end

@implementation AppDelegate


#pragma mark - Actions

- (IBAction)showConfiguration:(id)sender {
	[NSApp beginSheet:self.clockView.configureSheet modalForWindow:self.window modalDelegate:self didEndSelector:@selector(endSheet:) contextInfo:nil];
}


#pragma mark - Private

- (void)endSheet:(NSWindow *)sheet {
	[sheet close];
}


#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	self.clockView = [[SAMClockView alloc] init];
	self.clockView.frame = [self.window.contentView bounds];
	self.clockView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	[self.window.contentView addSubview:self.clockView];

	[self.clockView startAnimation];
	[NSTimer scheduledTimerWithTimeInterval:[self.clockView animationTimeInterval] target:self.clockView selector:@selector(animateOneFrame) userInfo:nil repeats:YES];
}

@end
