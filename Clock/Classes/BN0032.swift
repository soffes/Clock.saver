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

	enum Style: String, ClockStyle {
		case BKBKG = "BKBKG"
		case WHBKG = "WHBKG"

		var description: String {
			switch self {
			case .BKBKG:
				return "Black"
			case .WHBKG:
				return "White"
			}
		}

		var backgroundColor: NSColor {
			return darkBackgroundColor
		}

		var faceColor: NSColor {
			switch self {
			case .BKBKG:
				return backgroundColor
			case .WHBKG:
				return NSColor(white: 0.996, alpha: 1)
			}
		}

		var hourColor: NSColor {
			switch self {
			case .BKBKG:
				return NSColor(white: 0.7, alpha: 1)
			case .WHBKG:
				return NSColor(white: 0.3, alpha: 1)
			}
		}

		var minuteColor: NSColor {
			switch self {
			case .BKBKG:
				return NSColor.whiteColor()
			case .WHBKG:
				return NSColor.blackColor()
			}
		}

		var secondColor: NSColor {
			return yellowColor
		}

		var logoColor: NSColor {
			return minuteColor
		}

		static var defaultStyle: ClockStyle {
			return Style.BKBKG
		}
	}


	// MARK: - ClockView

	override var styleName: String {
		set {
			style = Style(rawValue: newValue) ?? Style.defaultStyle
		}

		get {
			return style.description
		}
	}

	override class var styles: [ClockStyle] {
		return [Style.BKBKG, Style.WHBKG]
	}

	override func initialize() {
		super.initialize()
		style = Style.defaultStyle
	}

	override func drawDay(day: Int) {
		let dateArrowColor = redColor
		let dateBackgroundColor = NSColor(SRGBRed: 0.894, green: 0.933, blue: 0.965, alpha: 1)
		let clockWidth = clockFrame.size.width
		let dateWidth = clockWidth * 0.057416268
		var dateFrame = CGRect(
			x: clockFrame.origin.x + ((clockWidth - dateWidth) / 2.0),
			y: clockFrame.origin.y + (clockWidth * 0.199362041),
			width: dateWidth,
			height: clockWidth * 0.071770335
		)

		dateBackgroundColor.setFill()
		NSBezierPath.fillRect(dateFrame)

		style.minuteColor.setFill()

		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = .Center

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
}
