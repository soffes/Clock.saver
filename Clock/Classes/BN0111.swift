//
//  BN0111.swift
//  Clock
//
//  Created by Sam Soffes on 2/19/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import AppKit

class BN0111: ClockView {

	// MARK: - Types

	enum Style: String, ClockStyle {
		case WHBLG = "WHBLG"
		case BKORG = "BKORG"
		case WHGYG = "WHGYG"
		case BKBKG = "BKBKG"
		case BKLGYG = "BKLGYG"

		var description: String {
			switch self {
			case .WHBLG: return "Blue"
			case .BKORG: return "Orange"
			case .WHGYG: return "Grey"
			case .BKBKG: return "Black"
			case .BKLGYG: return "Light Grey"
			}
		}

		var backgroundColor: NSColor {
			switch self {
			case .WHBLG: return NSColor(SRGBRed: 0.267, green: 0.682, blue: 0.918, alpha: 1)
			case .BKORG: return NSColor(SRGBRed: 0.984, green: 0.427, blue: 0.137, alpha: 1)
			case .WHGYG: return NSColor(SRGBRed: 0.804, green: 0.788, blue: 0.784, alpha: 1)
			case .BKBKG: return darkBackgroundColor
			case .BKLGYG: return NSColor(SRGBRed: 0.788, green: 0.792, blue: 0.800, alpha: 1)
			}
		}

		var faceColor: NSColor {
			switch self {
			case .WHBLG, .WHGYG: return lightBackgroundColor
			default: return darkBackgroundColor
			}
		}

		var hourColor: NSColor {
			switch self {
			case .WHBLG, .WHGYG: return NSColor(white: 0.3, alpha: 1)
			default: return NSColor(white: 0.7, alpha: 1)
			}
		}

		var minuteColor: NSColor {
			switch self {
			case .WHBLG, .WHGYG: return NSColor.blackColor()
			default: return .whiteColor()
			}
		}

		var secondColor: NSColor {
			return yellowColor
		}

		var logoColor: NSColor {
			return minuteColor
		}

		static var defaultStyle: ClockStyle {
			return Style.WHBLG
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
		return [Style.WHBLG, Style.BKORG, Style.WHGYG, Style.BKBKG, Style.BKLGYG]
	}

	override func initialize() {
		super.initialize()
		style = Style.defaultStyle
	}
}
