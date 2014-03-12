//
//  SAMClockConfigureWindowController.m
//  Clock
//
//  Created by Sam Soffes on 3/11/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import "SAMClockConfigureWindowController.h"
#import "SAMClockView.h"

#import <ScreenSaver/ScreenSaver.h>

@implementation SAMClockConfigureWindowController

- (NSString *)windowNibName {
	return @"SAMClockConfiguration";
}


- (void)awakeFromNib {
	[super awakeFromNib];

	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"com.samsoffes.clock"];
	[self.stylePicker selectItemAtIndex:[defaults integerForKey:@"SAMClockStyle"]];
	self.tickMarksCheckbox.state = [defaults boolForKey:@"SAMClockTickMarks"];
}


- (IBAction)close:(id)sender {
	[NSApp endSheet:self.window];
}


- (IBAction)changeStyle:(id)sender {
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"com.samsoffes.clock"];
	[defaults setInteger:[self.stylePicker indexOfSelectedItem] forKey:@"SAMClockStyle"];
	[defaults synchronize];

	[[NSNotificationCenter defaultCenter] postNotificationName:SAMClockConfigurationDidChangeNotificationName object:nil];
}


- (IBAction)changeTickMarks:(id)sender {
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"com.samsoffes.clock"];
	[defaults setBool:[self.tickMarksCheckbox state] forKey:@"SAMClockTickMarks"];
	[defaults synchronize];

	[[NSNotificationCenter defaultCenter] postNotificationName:SAMClockConfigurationDidChangeNotificationName object:nil];
}

@end
