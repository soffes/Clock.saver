//
//  AppDelegate.h
//  ClockTest
//
//  Created by Sam Soffes on 3/8/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

@class SAMClockView;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property IBOutlet SAMClockView *clockView;

- (IBAction)showConfiguration:(id)sender;

@end
