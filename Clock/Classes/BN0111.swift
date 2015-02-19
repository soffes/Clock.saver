//
//  BN0111.swift
//  Clock
//
//  Created by Sam Soffes on 2/19/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Cocoa

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
			case .WHBLG:
				return "Blue"
			case .BKORG:
				return "Orange"
			case .WHGYG:
				return "Grey"
			case .BKBKG:
				return "Black"
			case .BKLGYG:
				return "Light Grey"
			}
		}

		var backgroundColor: NSColor {
			switch self {
			case .WHBLG:
				return NSColor(SRGBRed: 0.380, green: 0.686, blue: 0.894, alpha: 1)
			case .BKORG:
				return NSColor(SRGBRed: 0.816, green: 0.416, blue: 0.231, alpha: 1)
			case .WHGYG:
				return NSColor(SRGBRed: 0.529, green: 0.545, blue: 0.553, alpha: 1)
			case .BKBKG:
				return darkBackgroundColor
			case .BKLGYG:
				return NSColor(SRGBRed: 0.788, green: 0.792, blue: 0.800, alpha: 1)
			}
		}

		var faceColor: NSColor {
			switch self {
			case .WHBLG, WHGYG:
				return NSColor(white: 0.996, alpha: 1)
			default:
				return darkBackgroundColor
			}
		}

		var hourColor: NSColor {
			switch self {
			case .WHBLG, WHGYG:
				return NSColor(white: 0.3, alpha: 1)
			default:
				return NSColor(white: 0.7, alpha: 1)
			}
		}

		var minuteColor: NSColor {
			switch self {
			case .WHBLG, WHGYG:
				return NSColor.blackColor()
			default:
				return NSColor.whiteColor()
			}
		}

		var secondColor: NSColor {
			return yellowColor
		}

		var logoColor: NSColor {
			return minuteColor
		}
	}


	// MARK: - ClockView

	override func initialize() {
		super.initialize()
		style = Style.BKLGYG
	}
}
