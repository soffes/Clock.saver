import AppKit

protocol ClockStyle: CustomStringConvertible {
	var rawValue: String { get }
	var backgroundColor: NSColor { get }
	var faceColor: NSColor { get }
	var hourColor: NSColor { get }
	var minuteColor: NSColor { get }
	var secondColor: NSColor { get }
	var logoColor: NSColor { get }

	static var `default`: ClockStyle { get }
}

extension ClockStyle {
    var backgroundColor: NSColor {
        return Color.darkBackground
    }

    var faceColor: NSColor {
        return backgroundColor
    }

    var hourColor: NSColor {
        return NSColor(white: 0.75, alpha: 1)
    }

    var minuteColor: NSColor {
        return Color.white
    }

    var secondColor: NSColor {
        return Color.yellow
    }

    var logoColor: NSColor {
        return minuteColor
    }
}
