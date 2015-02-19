//
//  BN0021.swift
//  Clock
//
//  Created by Sam Soffes on 2/19/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Cocoa

class BN0021: ClockView {

	// MARK: - Types

	enum Style: String, ClockStyle {
		case BKBKG = "BKBKG"
		case WHBRG = "WHBRG"

		var description: String {
			switch self {
			case .BKBKG:
				return "Black"
			case .WHBRG:
				return "Brown"
			}
		}

		var backgroundColor: NSColor {
			switch self {
			case .BKBKG:
				return darkBackgroundColor
			case .WHBRG:
				return NSColor(SRGBRed: 0.298, green: 0.231, blue: 0.204, alpha: 1)
			}
		}

		var faceColor: NSColor {
			switch self {
			case .BKBKG:
				return backgroundColor
			case .WHBRG:
				return NSColor(white: 0.996, alpha: 1)
			}
		}

		var hourColor: NSColor {
			switch self {
			case .BKBKG:
				return NSColor(white: 0.7, alpha: 1)
			case .WHBRG:
				return NSColor(white: 0.3, alpha: 1)
			}
		}

		var minuteColor: NSColor {
			switch self {
			case .BKBKG:
				return NSColor.whiteColor()
			case .WHBRG:
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
		return [Style.BKBKG, Style.WHBRG]
	}

	override func initialize() {
		super.initialize()
		style = Style.defaultStyle
	}

	override func drawTicks() {
		let color = style.minuteColor
		drawTicks(minorColor: color.colorWithAlphaComponent(0.5), minorLength: 0.05, minorThickness: 0.003, majorColor: color, majorLength: 0.09, majorThickness: 0.006)
	}

	override func drawNumbers() {
		drawNumbers(fontSize: 0.06, radius: 0.39)
	}
}
