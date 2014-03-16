//
//  SAMClockConfigureWindowController.m
//  Clock
//
//  Created by Sam Soffes on 3/11/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import "SAMClockConfigureWindowController.h"
#import "SAMClockView.h"


@implementation SAMClockConfigureWindowController

#pragma mark - NSObject

- (void)awakeFromNib {
	[super awakeFromNib];

	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:SAMClockDefaultsModuleName];
	[self.faceStylePicker selectItemAtIndex:[defaults integerForKey:SAMClockStyleDefaultsKey]];
	[self.backgroundStylePicker selectItemAtIndex:[defaults integerForKey:SAMClockBackgroundStyleDefaultsKey]];
	self.tickMarksCheckbox.state = [defaults boolForKey:SAMClockTickMarksDefaultsKey];
	self.numbersCheckbox.state = [defaults boolForKey:SAMClockNumbersDefaultsKey];
	self.dateCheckbox.state = [defaults boolForKey:SAMClockDateDefaultsKey];
	self.logoCheckbox.state = [defaults boolForKey:SAMClockLogoDefaultsKey];
}

#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"SAMClockConfiguration";
}


#pragma mark - Actions

- (IBAction)close:(id)sender {
	[NSApp endSheet:self.window];
}


- (IBAction)popUpChanged:(id)sender {
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:SAMClockDefaultsModuleName];
	[defaults setInteger:[sender indexOfSelectedItem] forKey:[self defaultsKeyForControl:sender]];
	[defaults synchronize];

	[[NSNotificationCenter defaultCenter] postNotificationName:SAMClockConfigurationDidChangeNotificationName object:nil];
}


- (IBAction)checkboxChanged:(id)sender {
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:SAMClockDefaultsModuleName];
	[defaults setBool:[sender state] forKey:[self defaultsKeyForControl:sender]];
	[defaults synchronize];

	[[NSNotificationCenter defaultCenter] postNotificationName:SAMClockConfigurationDidChangeNotificationName object:nil];
}


#pragma mark - Private

- (NSString *)defaultsKeyForControl:(id)sender {
	NSArray *keys = @[SAMClockStyleDefaultsKey, SAMClockBackgroundStyleDefaultsKey, SAMClockTickMarksDefaultsKey,
					  SAMClockNumbersDefaultsKey, SAMClockDateDefaultsKey, SAMClockLogoDefaultsKey];
	return keys[[sender tag]];
}

@end
