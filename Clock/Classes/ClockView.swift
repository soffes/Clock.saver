//
//  WatchView.swift
//  Clock.saver
//
//  Created by Sam Soffes on 2/17/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Cocoa
import ScreenSaver

class ClockView: NSView {

	// MARK: - Properties

	var drawsLogo = false
	var logoImage: NSImage?
	var clockFrame: CGRect {
		return clockFrameForBounds(bounds)
	}

	var backgroundColor: NSColor?
	var faceColor: NSColor?

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

		if let backgroundColor = backgroundColor {
			backgroundColor.setFill()
			NSBezierPath.fillRect(bounds)
		}

		drawFaceBackground()

		if drawsLogo {
			drawLogo()
		}

		// Get time components
		let comps = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit, fromDate: NSDate())
		let seconds = Double(comps.second) / 60.0
		let minutes = (Double(comps.minute) / 60.0) + (seconds / 60.0)
		let hours = (Double(comps.hour) / 12.0) + ((minutes / 60.0) * (60.0 / 12.0))

		drawDay(comps.day)
		drawHours(-(M_PI * 2.0 * hours) + M_PI_2)
		drawMinutes(-(M_PI * 2.0 * minutes) + M_PI_2)
		drawSeconds(-(M_PI * 2.0 * seconds) + M_PI_2)
	}


	// MARK: - Configuration

	func initialize() {
	}

	func clockFrameForBounds(bounds: CGRect) -> CGRect {
		return bounds
	}


	// MARK: - Drawing Hooks

	func drawLogo() {
	}

	func drawDay(day: Int) {
	}

	func drawHours(angle: Double) {
	}

	func drawMinutes(angle: Double) {
	}

	func drawSeconds(angle: Double) {
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
		faceColor?.setFill()

		let clockPath = NSBezierPath(ovalInRect: clockFrame)
		clockPath.lineWidth = 4
		clockPath.fill()
	}

	func drawTicks(#minorColor: NSColor, minorLength: Double, minorThickness: Double, majorColor _majorColor: NSColor?, majorLength _majorLength: Double?, majorThickness _majorThickness: Double?) {
		let majorColor = _majorColor == nil ? minorColor : _majorColor
		let majorLength = _majorLength == nil ? minorLength : _majorLength
		let majorThickness = _majorThickness == nil ? minorThickness : _majorThickness
		let center = CGPoint(x: clockFrame.midX, y: clockFrame.midY)

//		// Ticks divider
//		let dividerPosition = 0.074960128
//		backgroundColor.colorWithAlphaComponent(0.05).setStroke()
//		let ticksFrame = CGRectInset(clockFrame, clockFrame.size.width * dividerPosition, clockFrame.size.width * dividerPosition)
//		let ticksPath = NSBezierPath(ovalInRect: ticksFrame)
//		ticksPath.lineWidth = 1
//		ticksPath.stroke()
//
//		// Ticks
//		let tickLength = clockWidth * -0.049441786
//		let tickRadius = clockWidth * 0.437799043
//		for i in 0..<60 {
//			let isLarge = (i % 5) == 0
//			let progress = Double(i) / 60.0
//			let angle = CGFloat(-(progress * M_PI * 2) + M_PI_2)
//
//			let tickColor = isLarge ? handColor : handColor.colorWithAlphaComponent(0.5)
//			tickColor.setStroke()
//
//			let tickPath = NSBezierPath()
//			tickPath.moveToPoint(CGPoint(
//				x: center.x + cos(angle) * (tickRadius - tickLength),
//				y: center.y + sin(angle) * (tickRadius - tickLength)
//				))
//
//			tickPath.lineToPoint(CGPoint(
//				x: center.x + cos(angle) * tickRadius,
//				y: center.y + sin(angle) * tickRadius
//				))
//
//			tickPath.lineWidth = ceil(clockWidth * (isLarge ? 0.009569378 : 0.004784689))
//			tickPath.stroke()
//		}
	}

	func drawNumbers(fontSize: CGFloat) {
//		let center = CGPoint(x: clockFrame.midX, y: clockFrame.midY)
//
//		let textRadius = clockWidth * 0.402711324
//		let font = NSFont(name: "HelveticaNeue-Light", size: clockWidth * 0.071770334)!
//		for i in 0..<12 {
//			let string = NSAttributedString(string: "\(12 - i)", attributes: [
//				NSForegroundColorAttributeName: handColor,
//				NSKernAttributeName: -2,
//				NSFontAttributeName: font
//				])
//
//			let stringSize = string.size
//			let angle = CGFloat((Double(i) / 12.0 * M_PI * 2.0) + M_PI_2)
//			let rect = CGRect(
//				x: (center.x + cos(angle) * (textRadius - (stringSize.width / 2.0))) - (stringSize.width / 2.0),
//				y: center.y + sin(angle) * (textRadius - (stringSize.height / 2.0)) - (stringSize.height / 2.0),
//				width: stringSize.width,
//				height: stringSize.height
//			)
//
//			string.drawInRect(rect)
//		}
	}

	func preferencesDidChange(notification: NSNotification?) {
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
