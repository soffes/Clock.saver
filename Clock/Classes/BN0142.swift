//
//  BN0142.swift
//  Clock
//
//  Created by Sam Soffes on 7/19/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import AppKit

class BN0142: ClockView {

	// MARK: - Types

	enum Style: String, ClockStyle {
		case BKBKG = "BKBKG"
		case BKBRG = "BKBRG"
		case WHBLG = "WHBLG"

		var description: String {
			switch self {
			case .BKBKG: return "Black"
			case .BKBRG: return "Brown"
			case .WHBLG: return "Blue"
			}
		}

		var backgroundColor: NSColor {
			switch self {
			case .BKBKG: return darkBackgroundColor
			case .BKBRG: return NSColor(SRGBRed: 0.443, green: 0.376, blue: 0.345, alpha: 1)
			case .WHBLG: return blueColor
			}
		}

		var faceColor: NSColor {
			switch self {
			case .BKBKG, .BKBRG: return darkBackgroundColor
			default: return lightBackgroundColor
			}
		}

		var hourColor: NSColor {
			switch self {
			case .BKBKG, .BKBRG: return NSColor(white: 0.7, alpha: 1)
			default: return NSColor(white: 0.3, alpha: 1)
			}
		}

		var minuteColor: NSColor {
			switch self {
			case .BKBKG, .BKBRG: return .whiteColor()
			default: return .blackColor()
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
		return [Style.BKBKG, Style.BKBRG, Style.WHBLG]
	}

	override func initialize() {
		super.initialize()
		style = Style.defaultStyle
	}
}
