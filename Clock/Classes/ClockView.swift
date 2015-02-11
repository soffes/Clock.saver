//
//  ClockView.swift
//  Clock
//
//  Created by Sam Soffes on 7/15/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

import AppKit
import ScreenSaver

class ClockView: ScreenSaverView {

	// MARK: - Types

	enum Style: Int {
		case Light, Dark

		init(integer: Int) {
			if integer == 1 {
				self = .Dark
				return
			}

			self = .Light
		}
	}

	
	// MARK: - Properties
	
	var faceStyle: Style = .Light
	var backgroundStyle: Style = .Dark
	var drawsTicks = true
	var drawsNumbers = true
	var drawsDate = true
	var drawsLogo = false
	var logoImage: NSImage?
	var clockFrame = CGRectZero
	
	var clockWidth: CGFloat {
		return clockFrame.size.width
	}
	
	var backgroundColor: NSColor!
	var handColor: NSColor!
	var faceColor: NSColor!
	let secondsColor = NSColor(calibratedRed: 0.965, green: 0.773, blue: 0.180, alpha: 1)
	
	lazy var configureWindowController: ConfigureWindowController = {
		let controller = ConfigureWindowController()
		controller.loadWindow()
		return controller
	}()
	
	var defaults: ScreenSaverDefaults {
		return ScreenSaverDefaults.defaultsForModuleWithName(BundleIdentifier) as! ScreenSaverDefaults
	}
	
	override var frame: CGRect {
		didSet {
			clockFrame = clockFrameForBounds(bounds)
			setNeedsDisplayInRect(bounds)
		}
	}
	
	
	// MARK: - Initializers
	
	convenience override init() {
		self.init(frame: CGRectZero, isPreview: false)
	}
	
	override init(frame: NSRect, isPreview: Bool) {
		super.init(frame: frame, isPreview: isPreview)
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
		
		backgroundColor.setFill()
		NSBezierPath.fillRect(bounds)
	
		drawFaceBackground()
		
		if drawsTicks {
			drawTicks()
		}
		
		if drawsNumbers {
			drawNumbers()
		}
		
		if drawsLogo {
			drawLogo()
		}
		
		// Get time components
		let comps = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit, fromDate: NSDate())
		let seconds = Double(comps.second) / 60.0
		let minutes = (Double(comps.minute) / 60.0) + (seconds / 60.0)
		let hours = (Double(comps.hour) / 12.0) + ((minutes / 60.0) * (60.0 / 12.0))
		
		if drawsDate {
			drawDate(comps.day)
		}

		// Hours
		handColor.colorWithAlphaComponent(0.7).setStroke()
		let hoursAngle = -(M_PI * 2.0 * hours) + M_PI_2
		drawHand(length: 0.263955343, thickness: 0.023125997, angle: CGFloat(hoursAngle))
		
		// Minutes
		handColor.setStroke()
		let minutesAngle = -(M_PI * 2.0 * minutes) + M_PI_2;
		drawHand(length: 0.391547049, thickness: 0.014354067, angle: CGFloat(minutesAngle))
	
		// Seconds
		secondsColor.set()
		let secondsAngle = CGFloat(-(M_PI * 2.0 * seconds) + M_PI_2)
		drawHand(length: 0.391547049, thickness: 0.009569378, angle: secondsAngle)
		
		// Counterweight & screw
		drawHandAccessories(secondsAngle)
	}
	
	
	// MARK: - ScreenSaverView
	
	override func animateOneFrame() {
		setNeedsDisplayInRect(clockFrame)
	}
	
	override func hasConfigureSheet() -> Bool {
		return true
	}
	
	override func configureSheet() -> NSWindow! {
		return configureWindowController.window
	}
	
	
	// MARK: - Private

	private func initialize() {
		setAnimationTimeInterval(1.0 / 4.0)
		wantsLayer = true

		defaults.registerDefaults([
			ClockStyleDefaultsKey: Style.Light.rawValue,
			BackgroundStyleDefaultsKey: Style.Dark.rawValue,
			TickMarksDefaultsKey: true,
			NumbersDefaultsKey: true,
			DateDefaultsKey: true,
			LogoDefaultsKey: false
			])

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "configurationDidChange:", name: ConfigurationDidChangeNotificationName, object: nil)
		configurationDidChange(nil)
	}

	private func clockFrameForBounds(bounds: CGRect) -> CGRect {
		let size = bounds.size
		let clockSize = min(size.width, size.height) * 0.55
		
		var rect = CGRect(x: (size.width - clockSize) / 2.0, y: (size.height - clockSize) / 2.0, width: clockSize, height: clockSize)
		rect.integerize()
		
		return rect
	}
	
	private func drawFaceBackground() {
		faceColor.setFill()
		
		let clockPath = NSBezierPath(ovalInRect: clockFrame)
		clockPath.lineWidth = 4
		clockPath.fill()
	}
	
	private func drawTicks() {
		let center = CGPoint(x: clockFrame.midX, y: clockFrame.midY)
		
		// Ticks divider
		let dividerPosition: CGFloat = 0.074960128
		backgroundColor.colorWithAlphaComponent(0.05).setStroke()
		let ticksFrame = CGRectInset(clockFrame, clockFrame.size.width * dividerPosition, clockFrame.size.width * dividerPosition)
		let ticksPath = NSBezierPath(ovalInRect: ticksFrame)
		ticksPath.lineWidth = 1
		ticksPath.stroke()
		
		// Ticks
		let tickLength = clockWidth * -0.049441786
		let tickRadius = clockWidth * 0.437799043
		for i in 0..<60 {
			let isLarge = (i % 5) == 0
			let progress = Double(i) / 60.0
			let angle = CGFloat(-(progress * M_PI * 2) + M_PI_2)
			
			let tickColor = isLarge ? handColor : handColor.colorWithAlphaComponent(0.5)
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
			
			tickPath.lineWidth = ceil(clockWidth * (isLarge ? 0.009569378 : 0.004784689))
			tickPath.stroke()
		}
	}
	
	private func drawNumbers() {
		let center = CGPoint(x: clockFrame.midX, y: clockFrame.midY)
		
		let textRadius = clockWidth * 0.402711324
		let font = NSFont(name: "HelveticaNeue-Light", size: clockWidth * 0.071770334)!
		for i in 0..<12 {
			let string = NSAttributedString(string: "\(12 - i)", attributes: [
				NSForegroundColorAttributeName: handColor,
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
	
	private func drawDate(day: Int) {
		let dateArrowColor = NSColor(calibratedRed: 0.847, green: 0.227, blue: 0.286, alpha: 1)
		let dateBackgroundColor = NSColor(calibratedRed: 0.894, green: 0.933, blue: 0.965, alpha: 1)
		let dateWidth = clockWidth * 0.057416268
		var dateFrame = CGRect(
			x: clockFrame.origin.x + ((clockWidth - dateWidth) / 2.0),
			y: clockFrame.origin.y + (clockWidth * 0.199362041),
			width: dateWidth,
			height: clockWidth * 0.071770335
		)
		
		dateBackgroundColor.setFill()
		NSBezierPath.fillRect(dateFrame)

		handColor.setFill()
		
		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = NSTextAlignment.CenterTextAlignment
		
		let string = NSAttributedString(string: "\(day)", attributes: [
			NSFontAttributeName: NSFont(name: "HelveticaNeue-Light", size: clockWidth * 0.044657098)!,
			NSKernAttributeName: -1,
			NSParagraphStyleAttributeName: paragraph
		])
		
		var stringFrame = dateFrame
		stringFrame.origin.y -= dateFrame.size.height * 0.12
		string.drawInRect(stringFrame)
		
		dateArrowColor.setFill()
		let y = dateFrame.maxY + (clockWidth * 0.015948963)
		let height = clockWidth * 0.022328549
		let pointDip = clockWidth * 0.009569378
		
		let path = NSBezierPath()
		path.moveToPoint(CGPoint(x: dateFrame.minX, y: y))
		path.lineToPoint(CGPoint(x: dateFrame.minX, y: y - height))
		path.lineToPoint(CGPoint(x: dateFrame.midX, y: y - height - pointDip))
		path.lineToPoint(CGPoint(x: dateFrame.maxX, y: y - height))
		path.lineToPoint(CGPoint(x: dateFrame.maxX, y: y))
		path.lineToPoint(CGPoint(x: dateFrame.midX, y: y - pointDip))
		path.fill()
	}
	
	private func drawLogo() {
		if let image = logoImage {
			let originalImageSize = image.size
			let imageWidth = clockWidth * 0.156299841
			let imageSize = CGSize(
				width: imageWidth,
				height: originalImageSize.height * imageWidth / originalImageSize.width
			)
			let logoRect = CGRect(
				x: (bounds.size.width - imageSize.width) / 2.0,
				y: clockFrame.origin.y + (clockWidth * 0.622009569),
				width: imageSize.width,
				height: imageSize.height
			)

			if faceStyle == .Dark {
				NSColor.whiteColor().setFill()
			} else {
				NSColor.blackColor().setFill()
			}

			let graphicsContext = NSGraphicsContext.currentContext()!
			let cgImage = image.CGImageForProposedRect(nil, context: graphicsContext, hints: nil)?.takeUnretainedValue()
			let context: CGContext = unsafeBitCast(graphicsContext.graphicsPort, CGContext.self)

			CGContextSaveGState(context)
			CGContextClipToMask(context, logoRect, cgImage)
			CGContextFillRect(context, bounds)
			CGContextRestoreGState(context)
		}
	}

	private func drawHand(#length: CGFloat, thickness: CGFloat, angle: CGFloat, lineCapStyle: NSLineCapStyle = NSLineCapStyle.SquareLineCapStyle) {
		let center = CGPoint(x: clockFrame.midX, y: clockFrame.midY)
		let end = CGPoint(
			x: center.x + cos(angle) * clockWidth * length,
			y: center.y + sin(angle) * clockWidth * length
		)
		
		let path = NSBezierPath()
		path.lineWidth = clockWidth * thickness
		path.lineCapStyle = lineCapStyle
		path.moveToPoint(center)
		path.lineToPoint(end)
		path.stroke()
	}
	
	private func drawHandAccessories(secondsAngle: CGFloat) {
		secondsColor.set()
		
		// Counterweight
		drawHand(length: -0.076555024, thickness: 0.028708134, angle: secondsAngle, lineCapStyle: NSLineCapStyle.RoundLineCapStyle)
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
	
	func configurationDidChange(notification: NSNotification?) {
		faceStyle = ClockView.Style(integer: defaults.integerForKey(ClockStyleDefaultsKey))
		backgroundStyle = ClockView.Style(integer: defaults.integerForKey(BackgroundStyleDefaultsKey))
		drawsTicks = defaults.boolForKey(TickMarksDefaultsKey)
		drawsNumbers = defaults.boolForKey(NumbersDefaultsKey)
		drawsDate = defaults.boolForKey(DateDefaultsKey)
		drawsLogo = defaults.boolForKey(LogoDefaultsKey)
		
		if drawsLogo {
			if let imageURL = NSBundle(identifier: BundleIdentifier)?.URLForResource("braun", withExtension: "pdf") {
				logoImage = NSImage(contentsOfURL: imageURL)
			}

			// For demo app
			if logoImage == nil {
				logoImage = NSImage(named: "braun")
			}
		} else {
			logoImage = nil
		}
		
		handColor = NSColor(calibratedRed: 0.039, green: 0.039, blue: 0.043, alpha: 1)
		faceColor = NSColor(calibratedWhite: 0.996, alpha: 1)
		
		if faceStyle == Style.Dark {
			handColor = NSColor(calibratedRed: 0.988, green: 0.992, blue: 0.988, alpha: 1)
			faceColor = NSColor(calibratedRed: 0.129, green: 0.125, blue: 0.141, alpha: 1)
		}
		
		backgroundColor = NSColor.whiteColor()
		
		if backgroundStyle == Style.Light {
			if faceStyle == Style.Dark {
				backgroundColor = NSColor(calibratedWhite: 0.996, alpha: 1)
			}
		} else {
			if faceStyle == Style.Light {
				backgroundColor = NSColor.blackColor()
			} else {
				backgroundColor = NSColor(calibratedRed: 0.129, green: 0.125, blue: 0.141, alpha: 1)
			}
		}
		
		setNeedsDisplayInRect(bounds)
	}
}
