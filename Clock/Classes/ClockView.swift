//
//  WatchView.swift
//  Clock.saver
//
//  Created by Sam Soffes on 2/17/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Cocoa
import ScreenSaver

protocol ClockStyle: Printable {
	var backgroundColor: NSColor { get }
	var faceColor: NSColor { get }
	var hourColor: NSColor { get }
	var minuteColor: NSColor { get }
	var secondColor: NSColor { get }
	var logoColor: NSColor { get }
}

class ClockView: NSView {

	// MARK: - Properties

	var drawsLogo = false
	var logoImage: NSImage?
	var clockFrame: CGRect {
		return clockFrameForBounds(bounds)
	}

	var style: ClockStyle!

	override var frame: CGRect {
		didSet {
			setNeedsDisplayInRect(bounds)
		}
	}


	// MARK: - Initializers

	convenience override init() {
		self.init(frame: CGRectZero)
	}

	override init(frame: NSRect) {
		super.init(frame: frame)
		initialize()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		initialize()
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}


	// MARK: - NSView

	override func drawRect(rect: NSRect) {
		super.drawRect(rect)

		style.backgroundColor.setFill()
		NSBezierPath.fillRect(bounds)

		drawFaceBackground()
		drawTicks()
		drawNumbers()

		if drawsLogo {
			drawLogo()
		}

		let comps = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit, fromDate: NSDate())
		let seconds = Double(comps.second) / 60.0
		let minutes = (Double(comps.minute) / 60.0) + (seconds / 60.0)
		let hours = (Double(comps.hour) / 12.0) + ((minutes / 60.0) * (60.0 / 12.0))

		drawTime(comps, hours: hours, minutes: minutes, seconds: seconds)
	}


	// MARK: - Configuration

	func initialize() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferencesDidChange:", name: PreferencesDidChangeNotificationName, object: nil)
		preferencesDidChange(nil)
	}

	func clockFrameForBounds(bounds: CGRect) -> CGRect {
		let size = bounds.size
		let clockSize = min(size.width, size.height) * 0.55

		var rect = CGRect(x: (size.width - clockSize) / 2.0, y: (size.height - clockSize) / 2.0, width: clockSize, height: clockSize)
		rect.integerize()

		return rect
	}


	// MARK: - Drawing Hooks

	func drawTicks() {
		drawTicksDivider(color: style.backgroundColor.colorWithAlphaComponent(0.05), position: 0.074960128)

		let color = style.minuteColor
		drawTicks(minorColor: color.colorWithAlphaComponent(0.5), minorLength: 0.049441786, minorThickness: 0.004784689, majorColor: color, majorThickness: 0.009569378)
	}

	func drawLogo() {
		drawLogo(style.logoColor, width: 0.156299841, y: 0.622009569)
	}

	func drawNumbers() {
		drawNumbers(fontSize: 0.071770334, radius: 0.402711324)
	}

	func drawTime(components: NSDateComponents, hours: Double, minutes: Double, seconds: Double) {
		drawDay(components.day)
		drawHours(-(M_PI * 2.0 * hours) + M_PI_2)
		drawMinutes(-(M_PI * 2.0 * minutes) + M_PI_2)
		drawSeconds(-(M_PI * 2.0 * seconds) + M_PI_2)
	}

	func drawDay(day: Int) {
	}

	func drawHours(angle: Double) {
		style.hourColor.setStroke()
		drawHand(length: 0.263955343, thickness: 0.023125997, angle: angle)
	}

	func drawMinutes(angle: Double) {
		style.minuteColor.setStroke()
		drawHand(length: 0.391547049, thickness: 0.014354067, angle: angle)
	}

	func drawSeconds(angle: Double) {
		style.secondColor.set()
		drawHand(length: 0.391547049, thickness: 0.009569378, angle: angle)

		// Counterweight
		drawHand(length: -0.076555024, thickness: 0.028708134, angle: angle, lineCapStyle: NSLineCapStyle.RoundLineCapStyle)
		let nubSize = clockFrame.size.width * 0.052631579
		let nubFrame = CGRect(x: (bounds.size.width - nubSize) / 2.0, y: (bounds.size.height - nubSize) / 2.0, width: nubSize, height: nubSize)
		NSBezierPath(ovalInRect: nubFrame).fill()

		// Screw
		let dotSize = clockFrame.size.width * 0.006379585
		NSColor.blackColor().setFill()
		var screwFrame = CGRect(x: (bounds.size.width - dotSize) / 2.0, y: (bounds.size.height - dotSize) / 2.0, width: dotSize, height: dotSize)
		screwFrame.integerize()
		let screwPath = NSBezierPath(ovalInRect: screwFrame)
		screwPath.fill()
	}


	// MARK: - Drawing Helpers

	func drawHand(#length: Double, thickness: Double, angle: Double, lineCapStyle: NSLineCapStyle = NSLineCapStyle.SquareLineCapStyle) {
		let center = CGPoint(x: clockFrame.midX, y: clockFrame.midY)
		let clockWidth = Double(clockFrame.size.width)
		let end = CGPoint(
			x: Double(center.x) + cos(angle) * clockWidth * length,
			y: Double(center.y) + sin(angle) * clockWidth * length
		)

		let path = NSBezierPath()
		path.lineWidth = CGFloat(clockWidth * thickness)
		path.lineCapStyle = lineCapStyle
		path.moveToPoint(center)
		path.lineToPoint(end)
		path.stroke()
	}

	func drawLogo(color: NSColor, width: CGFloat, y: CGFloat) {
		if let image = logoImage {
			let originalImageSize = image.size
			let imageWidth = clockFrame.size.width * width
			let imageSize = CGSize(
				width: imageWidth,
				height: originalImageSize.height * imageWidth / originalImageSize.width
			)
			let logoRect = CGRect(
				x: (bounds.size.width - imageSize.width) / 2.0,
				y: clockFrame.origin.y + (clockFrame.size.width * y),
				width: imageSize.width,
				height: imageSize.height
			)

			color.setFill()

			let graphicsContext = NSGraphicsContext.currentContext()!
			let cgImage = image.CGImageForProposedRect(nil, context: graphicsContext, hints: nil)?.takeUnretainedValue()
			let context: CGContext = unsafeBitCast(graphicsContext.graphicsPort, CGContext.self)

			CGContextSaveGState(context)
			CGContextClipToMask(context, logoRect, cgImage)
			CGContextFillRect(context, bounds)
			CGContextRestoreGState(context)
		}
	}

	func drawFaceBackground() {
		style.faceColor.setFill()

		let clockPath = NSBezierPath(ovalInRect: clockFrame)
		clockPath.lineWidth = 4
		clockPath.fill()
	}

	func drawTicksDivider(#color: NSColor, position: Double) {
		color.setStroke()
		let ticksFrame = CGRectInset(clockFrame, clockFrame.size.width * CGFloat(position), clockFrame.size.width * CGFloat(position))
		let ticksPath = NSBezierPath(ovalInRect: ticksFrame)
		ticksPath.lineWidth = 1
		ticksPath.stroke()
	}

	func drawTicks(#minorColor: NSColor, minorLength: Double, minorThickness: Double, majorColor _majorColor: NSColor? = nil, majorLength _majorLength: Double? = nil, majorThickness _majorThickness: Double? = nil) {
		let majorColor = _majorColor ?? minorColor
		let majorLength = _majorLength ?? minorLength
		let majorThickness = _majorThickness ?? minorThickness
		let center = CGPoint(x: clockFrame.midX, y: clockFrame.midY)

		// Ticks
		let clockWidth = clockFrame.size.width
		let tickRadius = clockWidth * 0.437799043
		for i in 0..<60 {
			let isMajor = (i % 5) == 0
			let tickLength = clockWidth * -CGFloat(isMajor ? majorLength : minorLength)
			let progress = Double(i) / 60.0
			let angle = CGFloat(-(progress * M_PI * 2) + M_PI_2)

			let tickColor = isMajor ? majorColor : minorColor
			tickColor.setStroke()

			let tickPath = NSBezierPath()
			tickPath.moveToPoint(CGPoint(
				x: center.x + cos(angle) * (tickRadius - tickLength),
				y: center.y + sin(angle) * (tickRadius - tickLength)
			))

			tickPath.lineToPoint(CGPoint(
				x: center.x + cos(angle) * tickRadius,
				y: center.y + sin(angle) * tickRadius
			))

			tickPath.lineWidth = CGFloat(ceil(Double(clockWidth) * (isMajor ? majorThickness : minorThickness)))
			tickPath.stroke()
		}
	}

	func drawNumbers(#fontSize: CGFloat, radius: Double) {
		let center = CGPoint(x: clockFrame.midX, y: clockFrame.midY)

		let clockWidth = clockFrame.size.width
		let textRadius = clockWidth * CGFloat(radius)
		let font = NSFont(name: "HelveticaNeue-Light", size: clockWidth * fontSize)!
		for i in 0..<12 {
			let string = NSAttributedString(string: "\(12 - i)", attributes: [
				NSForegroundColorAttributeName: style.minuteColor,
				NSKernAttributeName: -2,
				NSFontAttributeName: font
			])

			let stringSize = string.size
			let angle = CGFloat((Double(i) / 12.0 * M_PI * 2.0) + M_PI_2)
			let rect = CGRect(
				x: (center.x + cos(angle) * (textRadius - (stringSize.width / 2.0))) - (stringSize.width / 2.0),
				y: center.y + sin(angle) * (textRadius - (stringSize.height / 2.0)) - (stringSize.height / 2.0),
				width: stringSize.width,
				height: stringSize.height
			)

			string.drawInRect(rect)
		}
	}


	// MARK: - Private

	func preferencesDidChange(notification: NSNotification?) {
		let preferences = (notification?.object as? Preferences) ?? Preferences()
		drawsLogo = preferences.drawsLogo
		
		if drawsLogo {
			if let imageURL = NSBundle(identifier: BundleIdentifier)?.URLForResource("braun", withExtension: "pdf") {
				logoImage = NSImage(contentsOfURL: imageURL)
			}

			// For demo app
			// TODO: Make the demo app load the bundle so this can be removed.
			if logoImage == nil {
				logoImage = NSImage(named: "braun")
			}
		} else {
			logoImage = nil
		}

		setNeedsDisplayInRect(bounds)
	}
}
