//
//  SAMClockConfigureWindowController.h
//  Clock
//
//  Created by Sam Soffes on 3/11/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SAMClockConfigureWindowController : NSWindowController

@property IBOutlet NSPopUpButton *stylePicker;

- (IBAction)close:(id)sender;
- (IBAction)changeStyle:(id)sender;

@end
