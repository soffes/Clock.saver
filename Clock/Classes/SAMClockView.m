//
//  SAMClockView.m
//  Clock
//
//  Created by Sam Soffes on 3/8/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import "SAMClockView.h"
#import "SAMClockConfigureWindowController.h"

NSString *const SAMClockConfigurationDidChangeNotificationName = @"SAMClockConfigurationDidChangeNotification";

@interface SAMClockView ()
@property (nonatomic) BOOL preview;
@property (nonatomic, readonly) SAMClockConfigureWindowController *configureWindowController;
@end

@implementation SAMClockView

#pragma mark - Accessors

@synthesize configureWindowController = _configureWindowController;

- (SAMClockConfigureWindowController *)configureWindowController {
	if (!_configureWindowController) {
		_configureWindowController = [[SAMClockConfigureWindowController alloc] init];
		[_configureWindowController loadWindow];
	}
	return _configureWindowController;
}


#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - ScreenSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
	if ((self = [super initWithFrame:frame isPreview:isPreview])) {
		[self setAnimationTimeInterval:1.0 / 4.0];
		self.preview = isPreview;
		self.drawsTicks = YES;

		ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"com.samsoffes.clock"];
		[defaults registerDefaults:@{@"SAMClockTickMarks": @YES}];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configurationDidChange:) name:SAMClockConfigurationDidChangeNotificationName object:nil];
		[self configurationDidChange:nil];
	}
	return self;
}


- (void)startAnimation {
    [super startAnimation];
}


- (void)stopAnimation {
    [super stopAnimation];
}


- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];

	CGSize size = rect.size;

	NSColor *handColor;
	NSColor *backgroundColor;
	NSColor *clockBackgroundColor;
	NSColor *secondsColor = [NSColor colorWithCalibratedRed:0.965 green:0.773 blue:0.180 alpha:1];

	if (self.clockStyle == SAMClockViewStyleDark) {
		backgroundColor = [NSColor blackColor];
		handColor = [NSColor colorWithCalibratedRed:0.039f green:0.039f blue:0.043f alpha:1.0f];
		clockBackgroundColor = [NSColor colorWithCalibratedRed:0.996f green:0.996f blue:0.996f alpha:1.0f];
	} else {
		backgroundColor = [NSColor whiteColor];
		handColor = [NSColor colorWithCalibratedRed:0.988f green:0.992f blue:0.988f alpha:1.0f];
		clockBackgroundColor = [NSColor colorWithCalibratedRed:0.129f green:0.125f blue:0.141f alpha:1.0f];
	}

	// Screen background
	[backgroundColor setFill];
	[NSBezierPath fillRect:rect];

	// Clock background
	[clockBackgroundColor setFill];
	CGRect frame = [self clockFrameForBounds:self.bounds];
	NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:frame];
	path.lineWidth = 4.0f;
	[path fill];

	CGFloat twoPi = M_PI * 2.0f;
	CGFloat angleOffset = M_PI_2;
	CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));

	if (self.drawsTicks) {
		// Ticks divider
		[[backgroundColor colorWithAlphaComponent:0.05f] setStroke];
		path = [NSBezierPath bezierPathWithOvalInRect:CGRectInset(frame, frame.size.width * 0.1f, frame.size.width * 0.1f)];
		path.lineWidth = 1.0f;
		[path stroke];

		// Ticks
		CGFloat tickLength = frame.size.width * 0.05f;
		CGFloat tickRadius = frame.size.width / 2.1f;
		for (NSUInteger i = 0; i < 60; i++) {
			BOOL large = (i % 5) == 0;
			CGFloat angle = -((CGFloat)i / 60.0f * twoPi) + angleOffset;
			NSBezierPath *path = [NSBezierPath bezierPath];
			[path moveToPoint:CGPointMake(center.x + cosf(angle) * (tickRadius - tickLength), center.y + sinf(angle) * (tickRadius - tickLength))];
			[path lineToPoint:CGPointMake(center.x + cosf(angle) * tickRadius, center.y + sinf(angle) * tickRadius)];
			path.lineWidth = large ? 2.0f : 1.0f;
			[large ? handColor : [handColor colorWithAlphaComponent:0.7f] setStroke];
			[path stroke];
		}
	}

	// Get time components
	NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];

	// Hours
	[[handColor colorWithAlphaComponent:0.7f] setStroke];
	CGFloat angle = -(twoPi * ((CGFloat)comps.hour + ((CGFloat)comps.minute / 60.0f)) / 12.0f) + angleOffset;
	[self drawHandWithSize:CGSizeMake(self.preview ? 3.0f : 6.0f, frame.size.width * 0.5f * 0.49f) angle:angle];

	// Minutes
	[handColor setStroke];
	angle = -(twoPi * (CGFloat)comps.minute / 60.0f) + angleOffset;
	[self drawHandWithSize:CGSizeMake(self.preview ? 2.0f : 4.0f, frame.size.width * 0.5f * 0.7f) angle:angle];

	// Seconds
	[secondsColor set];
	angle = -(twoPi * (CGFloat)comps.second / 60.0f) + angleOffset;
	[self drawHandWithSize:CGSizeMake(self.preview ? 1.0f : 2.0f, frame.size.width * 0.5f * 0.75f) angle:angle];

	// Seconds nub
	[self drawHandWithSize:self.preview ? CGSizeMake(2.0f, -4.0f) : CGSizeMake(4.0f, -8.0f) angle:angle];

	// Seconds nub circle
	CGFloat nubSize = self.preview ? 3.0f : 10.0f;
	frame = CGRectMake(roundf((size.width - nubSize) / 2.0f), roundf((size.height - nubSize) / 2.0f), nubSize, nubSize);
	path = [NSBezierPath bezierPathWithOvalInRect:frame];
	[path fill];
}


- (void)animateOneFrame {
	[self setNeedsDisplay:YES];
}


- (BOOL)hasConfigureSheet {
    return YES;
}


- (NSWindow *)configureSheet {
    return self.configureWindowController.window;
}


#pragma mark - Private

// The size's height is the hand length. The size's width is the hand width, duh.
- (void)drawHandWithSize:(CGSize)size angle:(CGFloat)angle {
	CGRect frame = [self clockFrameForBounds:self.bounds];
	CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
	CGPoint point = CGPointMake(center.x + cosf(angle) * size.height, center.y + sinf(angle) * size.height);

	NSBezierPath *path = [NSBezierPath bezierPath];
	[path moveToPoint:center];
	[path lineToPoint:point];
	path.lineWidth = size.width;
	[path stroke];
}


- (CGRect)clockFrameForBounds:(CGRect)bounds {
	CGSize size = bounds.size;
	CGFloat clockSize = MIN(size.width, size.height) * 0.5;
	return CGRectMake(roundf((size.width - clockSize) / 2.0f), roundf((size.height - clockSize) / 2.0f), clockSize, clockSize);
}


- (void)configurationDidChange:(NSNotification *)notification {
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"com.samsoffes.clock"];

	self.clockStyle = [defaults integerForKey:@"SAMClockStyle"];
	self.drawsTicks = [defaults boolForKey:@"SAMClockTickMarks"];
}

@end
