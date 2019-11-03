import AppKit

final class BN0021: ClockView {

	// MARK: - Types

	enum Style: String, ClockStyle, CaseIterable {
		case bkbkg = "BKBKG"
		case whbrg = "WHBRG"

		var description: String {
			switch self {
			case .bkbkg:
				return "Black"
			case .whbrg:
				return "Brown"
			}
		}

		var backgroundColor: NSColor {
			switch self {
			case .bkbkg:
				return Color.darkBackground
			case .whbrg:
				return NSColor(displayP3Red: 0.298, green: 0.231, blue: 0.204, alpha: 1)
			}
		}

		var faceColor: NSColor {
			switch self {
			case .bkbkg:
				return backgroundColor
			case .whbrg:
				return NSColor(white: 0.996, alpha: 1)
			}
		}

		var hourColor: NSColor {
			switch self {
			case .bkbkg:
				return NSColor(white: 0.7, alpha: 1)
			case .whbrg:
				return NSColor(white: 0.3, alpha: 1)
			}
		}

		var minuteColor: NSColor {
			switch self {
			case .bkbkg:
				return Color.white
			case .whbrg:
				return Color.black
			}
		}

		var secondColor: NSColor {
			return Color.yellow
		}

		var logoColor: NSColor {
			return minuteColor
		}

		static var `default`: ClockStyle {
			return Style.bkbkg
		}
	}

	// MARK: - ClockView

	override class var modelName: String {
		return "BN0021"
	}

	override var styleName: String {
		set {
			style = Style(rawValue: newValue) ?? Style.default
		}

		get {
			return style.description
		}
	}

	override class var styles: [ClockStyle] {
		return Style.allCases
	}

	override func initialize() {
		super.initialize()
		style = Style.default
	}

	override func drawTicks() {
		let color = style.minuteColor
		drawTicks(minorColor: color.withAlphaComponent(0.5), minorLength: 0.05, minorThickness: 0.003,
                  majorColor: color, majorLength: 0.09, majorThickness: 0.006)
	}

	override func drawNumbers() {
		drawNumbers(fontSize: 0.06, radius: 0.39)
	}
}
