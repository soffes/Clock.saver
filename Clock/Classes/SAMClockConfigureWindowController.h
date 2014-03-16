//
//  SAMClockConfigureWindowController.h
//  Clock
//
//  Created by Sam Soffes on 3/11/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

@import Cocoa;
@import ScreenSaver;

@interface SAMClockConfigureWindowController : NSWindowController

@property IBOutlet NSPopUpButton *faceStylePicker;
@property IBOutlet NSPopUpButton *backgroundStylePicker;
@property IBOutlet NSButton *tickMarksCheckbox;
@property IBOutlet NSButton *numbersCheckbox;
@property IBOutlet NSButton *dateCheckbox;
@property IBOutlet NSButton *logoCheckbox;

- (IBAction)popUpChanged:(id)sender;
- (IBAction)checkboxChanged:(id)sender;
- (IBAction)close:(id)sender;

@end
