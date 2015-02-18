//
//  BN0032.swift
//  Clock.saver
//
//  Created by Sam Soffes on 2/17/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Cocoa

class BN0032: ClockView {
	
	// MARK: - Types

	enum Style: String {
		case BKBKG = "BKBKG"
		case WHBKG = "WHBKG"

		var backgroundColor: NSColor {
			switch self {
			case .BKBKG:
				return NSColor(calibratedRed: 0.129, green: 0.125, blue: 0.141, alpha: 1)
			case .WHBKG:
				return NSColor(calibratedWhite: 0.996, alpha: 1)
			}
		}

		var hourHandColor: NSColor {
			switch self {
			case .BKBKG:
				return NSColor(white: 0.7, alpha: 1)
			case .WHBKG:
				return NSColor(white: 0.3, alpha: 1)
			}
		}

		var minuteHandColor: NSColor {
			switch self {
			case .BKBKG:
				return NSColor.whiteColor()
			case .WHBKG:
				return NSColor.blackColor()
			}
		}

		var logoColor: NSColor {
			return minuteHandColor
		}
	}


	// MARK: - Properties

	var style: Style = .WHBKG


	// MARK: - ClockView

	override func initialize() {
		super.initialize()

		backgroundColor = style.backgroundColor
	}

	override func clockFrameForBounds(bounds: CGRect) -> CGRect {
		let size = bounds.size
		let clockSize = min(size.width, size.height) * 0.55

		var rect = CGRect(x: (size.width - clockSize) / 2.0, y: (size.height - clockSize) / 2.0, width: clockSize, height: clockSize)
		rect.integerize()

		return rect
	}

	override func drawLogo() {
		drawLogo(style.logoColor, width: 0.156299841, y: 0.622009569)
	}

	override func drawDay(day: Int) {
//		let dateArrowColor = redColor
//		let dateBackgroundColor = NSColor(calibratedRed: 0.894, green: 0.933, blue: 0.965, alpha: 1)
//		let dateWidth = clockWidth * 0.057416268
//		var dateFrame = CGRect(
//			x: clockFrame.origin.x + ((clockWidth - dateWidth) / 2.0),
//			y: clockFrame.origin.y + (clockWidth * 0.199362041),
//			width: dateWidth,
//			height: clockWidth * 0.071770335
//		)
//
//		dateBackgroundColor.setFill()
//		NSBezierPath.fillRect(dateFrame)
//
//		handColor.setFill()
//
//		let paragraph = NSMutableParagraphStyle()
//		paragraph.alignment = NSTextAlignment.CenterTextAlignment
//
//		let string = NSAttributedString(string: "\(day)", attributes: [
//			NSFontAttributeName: NSFont(name: "HelveticaNeue-Light", size: clockWidth * 0.044657098)!,
//			NSKernAttributeName: -1,
//			NSParagraphStyleAttributeName: paragraph
//			])
//
//		var stringFrame = dateFrame
//		stringFrame.origin.y -= dateFrame.size.height * 0.12
//		string.drawInRect(stringFrame)
//
//		dateArrowColor.setFill()
//		let y = dateFrame.maxY + (clockWidth * 0.015948963)
//		let height = clockWidth * 0.022328549
//		let pointDip = clockWidth * 0.009569378
//
//		let path = NSBezierPath()
//		path.moveToPoint(CGPoint(x: dateFrame.minX, y: y))
//		path.lineToPoint(CGPoint(x: dateFrame.minX, y: y - height))
//		path.lineToPoint(CGPoint(x: dateFrame.midX, y: y - height - pointDip))
//		path.lineToPoint(CGPoint(x: dateFrame.maxX, y: y - height))
//		path.lineToPoint(CGPoint(x: dateFrame.maxX, y: y))
//		path.lineToPoint(CGPoint(x: dateFrame.midX, y: y - pointDip))
//		path.fill()
	}

	override func drawHours(angle: Double) {
		style.hourHandColor.setStroke()
		drawHand(length: 0.263955343, thickness: 0.023125997, angle: angle)
	}

	override func drawMinutes(angle: Double) {
		style.minuteHandColor.setStroke()
		drawHand(length: 0.391547049, thickness: 0.014354067, angle: angle)
	}

	override func drawSeconds(angle: Double) {
		yellowColor.set()
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
}
