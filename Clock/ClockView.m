//
//  ClockView.m
//  Clock
//
//  Created by Sam Soffes on 3/8/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import "ClockView.h"

@implementation ClockView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
	if ((self = [super initWithFrame:frame isPreview:isPreview])) {
		[self setAnimationTimeInterval:1.0 / 30.0];
		self.clockStyle = ClockViewStyleWhite;
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
	NSColor *baseColor;
	NSColor *backgroundColor;
	NSColor *clockBackgroundColor;

	if (self.clockStyle == ClockViewStyleWhite) {
		backgroundColor = [NSColor blackColor];
		baseColor = [NSColor colorWithCalibratedRed:0.039f green:0.039f blue:0.043f alpha:1.0f];
		clockBackgroundColor = [NSColor colorWithCalibratedRed:0.996f green:0.996f blue:0.996f alpha:1.0f];
	} else {
		backgroundColor = [NSColor whiteColor];
		baseColor = [NSColor colorWithCalibratedRed:0.988f green:0.992f blue:0.988f alpha:1.0f];
		clockBackgroundColor = [NSColor colorWithCalibratedRed:0.129f green:0.125f blue:0.141f alpha:1.0f];
	}

	[backgroundColor setFill];
	[NSBezierPath fillRect:rect];

	[clockBackgroundColor setFill];

	CGFloat clockSize = MIN(size.width, size.height) * 0.5;
	CGRect frame = CGRectMake(roundf((size.width - clockSize) / 2.0f), roundf((size.height - clockSize) / 2.0f), clockSize, clockSize);
	NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:frame];
	path.lineWidth = 4.0f;
	[path fill];

	CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
	NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];

	// Hours
	[[baseColor colorWithAlphaComponent:0.7f] setStroke];
	path = [NSBezierPath bezierPath];
	[path moveToPoint:center];
	CGFloat angle = -(M_PI * 2.0f * ((CGFloat)comps.hour + ((CGFloat)comps.minute / 60.0f)) / 12.0f) + M_PI_2;
	CGFloat l = clockSize * 0.5f * 0.49f;
	CGPoint point = CGPointMake(center.x + cosf(angle) * l, center.y + sinf(angle) * l);
	[path lineToPoint:point];
	path.lineWidth = 6.0f;
	[path stroke];

	// Minutes
	[baseColor setStroke];
	path = [NSBezierPath bezierPath];
	[path moveToPoint:center];
	angle = -(M_PI * 2.0f * (CGFloat)comps.minute / 60.0f) + M_PI_2;
	l = clockSize * 0.50f * 0.70f;
	point = CGPointMake(center.x + cosf(angle) * l, center.y + sinf(angle) * l);
	[path lineToPoint:point];
	path.lineWidth = 4.0f;
	[path stroke];

	// Seconds
	path = [NSBezierPath bezierPath];
	[[NSColor colorWithCalibratedRed:0.965 green:0.773 blue:0.180 alpha:1] set];
	[path moveToPoint:center];
	angle = -(M_PI * 2.0f * (CGFloat)comps.second / 60.0f) + M_PI_2;
	l = clockSize * 0.5f * 0.75f;
	point = CGPointMake(center.x + cosf(angle) * l, center.y + sinf(angle) * l);
	[path lineToPoint:point];
	path.lineWidth = 2.0f;
	[path stroke];

	// Seconds nub
	path = [NSBezierPath bezierPath];
	[path moveToPoint:center];
	angle = angle;
	l = -8.0f;
	point = CGPointMake(center.x + cosf(angle) * l, center.y + sinf(angle) * l);
	[path lineToPoint:point];
	path.lineWidth = 4.0f;
	[path stroke];

	// Seconds nub circle
	frame = CGRectMake(roundf((size.width - 10.0f) / 2.0f), roundf((size.height - 10.0f) / 2.0f), 10.0f, 10.0f);
	path = [NSBezierPath bezierPathWithOvalInRect:frame];
	[path fill];
}


- (void)animateOneFrame {
	[self setNeedsDisplay:YES];
}


- (BOOL)hasConfigureSheet {
    return NO;
}

- (NSWindow *)configureSheet {
    return nil;
}

@end
