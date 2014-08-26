//
//  SAMClockView.m
//  Clock
//
//  Created by Sam Soffes on 3/8/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import "SAMClockView.h"
#import "SAMClockConfigureWindowController.h"

@implementation SAMClockView

#pragma mark - ScreenSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
	if ((self = [super initWithFrame:frame isPreview:isPreview])) {
		[self setAnimationTimeInterval:1.0];
		self.wantsLayer = YES;
	}
	return self;
}


- (void)startAnimation {
    [super startAnimation];
}


- (void)stopAnimation {
    [super stopAnimation];
}

- (NSColor*)colorWithHexColorString:(NSString*)inColorString
{
    NSColor* result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;

    if (nil != inColorString)
    {
        NSScanner* scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits

    result = [NSColor
              colorWithCalibratedRed:(CGFloat)redByte / 0xff
              green:(CGFloat)greenByte / 0xff
              blue:(CGFloat)blueByte / 0xff
              alpha:1.0];
    return result;
}


- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];

	NSDate *date = [NSDate date];
	NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:date];

    NSInteger s = comps.second;
    NSInteger m = comps.minute;
    NSInteger h = comps.hour;

    NSString *seconds = [NSString stringWithFormat:@"%ld", (long)s];
    NSString *minutes = [NSString stringWithFormat:@"%ld", (long)m];
    NSString *hours = [NSString stringWithFormat:@"%ld", (long)h];

    if (s <= 9) {
        seconds = [NSString stringWithFormat:@"0%ld", (long)s];
    }

    if (m <= 9) {
        minutes = [NSString stringWithFormat:@"0%ld", (long)m];
    }

    if (h <= 9) {
        hours = [NSString stringWithFormat:@"0%ld", (long)h];
    }

    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
    [textField setStringValue: [NSString stringWithFormat:@"#%@%@%@", hours, minutes, seconds]];

    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:textField.stringValue];

    [textString setAlignment:NSCenterTextAlignment range:NSMakeRange(0, textString.length)];
    [textString addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, textString.length)];

    int fontSize = 70;
    [textString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Lato-Hairline" size:fontSize] range:NSMakeRange(0, textString.length)];

    NSColor *bgColor = [self colorWithHexColorString:[NSString stringWithFormat:@"%ld%ld%ld", (long)h, (long)m, (long)s]];

	// Screen background
	[bgColor setFill];
	[NSBezierPath fillRect:rect];

    [textString drawInRect:CGRectIntegral(CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, (self.bounds.size.height / 2) + fontSize))];
}


- (void)animateOneFrame {
	[self setNeedsDisplay:YES];
}

@end
