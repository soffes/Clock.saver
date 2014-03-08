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

	[[NSColor blackColor] setFill];
	[NSBezierPath fillRect:rect];

//	NSDate *date = [NSDate date];

	[[NSColor colorWithCalibratedWhite:1.0f alpha:0.2f] setStroke];

	CGFloat clockSize = MIN(size.width, size.height) * 0.5;
	CGRect frame = CGRectMake(roundf((size.width - clockSize) / 2.0f), roundf((size.height - clockSize) / 2.0f), clockSize, clockSize);
	NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:frame];
	path.lineWidth = 4.0f;
	[path stroke];

	CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
	NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];

	// Seconds
	[[NSColor whiteColor] setStroke];
	path = [NSBezierPath bezierPath];
	[path moveToPoint:center];
	CGFloat angle = -(M_PI * 2.0f * (CGFloat)comps.second / 60.0f) + M_PI_2;
	CGFloat l = clockSize * 0.5f;
	CGPoint point = CGPointMake(center.x + cosf(angle) * l, center.y + sinf(angle) * l);
	[path lineToPoint:point];
	path.lineWidth = 1.0f;
	[path stroke];

	// Minutes
	[[NSColor colorWithCalibratedWhite:1.0f alpha:0.7f] setStroke];
	path = [NSBezierPath bezierPath];
	[path moveToPoint:center];
	angle = -(M_PI * 2.0f * (CGFloat)comps.minute / 60.0f) + M_PI_2;
	l = clockSize * 0.45f;
	point = CGPointMake(center.x + cosf(angle) * l, center.y + sinf(angle) * l);
	[path lineToPoint:point];
	path.lineWidth = 3.0f;
	[path stroke];

	// Hours
//	[[NSColor colorWithCalibratedWhite:1.0f alpha:0.2f] setStroke];
	path = [NSBezierPath bezierPath];
	[path moveToPoint:center];
	angle = -(M_PI * 2.0f * ((CGFloat)comps.hour + ((CGFloat)comps.minute / 60.0f)) / 12.0f) + M_PI_2;
	l = clockSize * 0.4f;
	point = CGPointMake(center.x + cosf(angle) * l, center.y + sinf(angle) * l);
	[path lineToPoint:point];
	path.lineWidth = 5.0f;
	[path stroke];
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
