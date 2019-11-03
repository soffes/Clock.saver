import AppKit

final class BN0111: ClockView {

	// MARK: - Types

    enum Style: String, ClockStyle, CaseIterable {
		case whblg = "WHBLG"
		case bkorg = "BKORG"
		case whgyg = "WHGYG"
		case bkbkg = "BKBKG"
		case bklgyg = "BKLGYG"

		var description: String {
			switch self {
			case .whblg:
				return "Blue"
			case .bkorg:
				return "Orange"
			case .whgyg:
				return "Grey"
			case .bkbkg:
				return "Black"
			case .bklgyg:
				return "Light Grey"
			}
		}

		var backgroundColor: NSColor {
			switch self {
			case .whblg:
				return NSColor(displayP3Red: 0.267, green: 0.682, blue: 0.918, alpha: 1)
			case .bkorg:
				return NSColor(displayP3Red: 0.984, green: 0.427, blue: 0.137, alpha: 1)
			case .whgyg:
				return NSColor(displayP3Red: 0.804, green: 0.788, blue: 0.784, alpha: 1)
			case .bkbkg:
				return Color.darkBackground
			case .bklgyg:
				return NSColor(displayP3Red: 0.788, green: 0.792, blue: 0.800, alpha: 1)
			}
		}

		var faceColor: NSColor {
			switch self {
			case .whblg, .whgyg:
				return NSColor(white: 0.996, alpha: 1)
			default:
				return Color.darkBackground
			}
		}

		var hourColor: NSColor {
			switch self {
			case .whblg, .whgyg:
				return NSColor(white: 0.3, alpha: 1)
			default:
				return NSColor(white: 0.7, alpha: 1)
			}
		}

		var minuteColor: NSColor {
			switch self {
			case .whblg, .whgyg:
				return Color.black
			default:
				return Color.white
			}
		}

		var secondColor: NSColor {
			return Color.yellow
		}

		var logoColor: NSColor {
			return minuteColor
		}

		static var `default`: ClockStyle {
			return Style.whblg
		}
	}

	// MARK: - ClockView

	override class var modelName: String {
		return "BN0111"
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
}
