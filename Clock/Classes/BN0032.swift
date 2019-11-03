import AppKit

final class BN0032: ClockView {
	
	// MARK: - Types

	enum Style: String, ClockStyle, CaseIterable {
		case bkbkg = "BKBKG"
		case whbkg = "WHBKG"

		var description: String {
			switch self {
			case .bkbkg:
				return "Black"
			case .whbkg:
				return "White"
			}
		}

		var backgroundColor: NSColor {
			return Color.darkBackground
		}

		var faceColor: NSColor {
			switch self {
			case .bkbkg:
				return backgroundColor
			case .whbkg:
				return NSColor(white: 0.996, alpha: 1)
			}
		}

		var hourColor: NSColor {
			switch self {
			case .bkbkg:
				return NSColor(white: 0.7, alpha: 1)
			case .whbkg:
				return NSColor(white: 0.3, alpha: 1)
			}
		}

		var minuteColor: NSColor {
			switch self {
			case .bkbkg:
				return Color.white
			case .whbkg:
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
		return "BN0032"
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

	override func draw(day: Int) {
		let dateArrowColor = Color.red
		let dateBackgroundColor = NSColor(displayP3Red: 0.894, green: 0.933, blue: 0.965, alpha: 1)
		let clockWidth = clockFrame.size.width
		let dateWidth = clockWidth * 0.057416268
		let dateFrame = CGRect(
			x: clockFrame.origin.x + ((clockWidth - dateWidth) / 2.0),
			y: clockFrame.origin.y + (clockWidth * 0.199362041),
			width: dateWidth,
			height: clockWidth * 0.071770335
		)

		dateBackgroundColor.setFill()
		NSBezierPath.fill(dateFrame)

		style.minuteColor.setFill()

		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = .center

		let string = NSAttributedString(string: "\(day)", attributes: [
			.font: NSFont(name: "HelveticaNeue-Light", size: clockWidth * 0.044657098)!,
            .kern: -0.5,
			.paragraphStyle: paragraph
		])

		var stringFrame = dateFrame
		stringFrame.origin.y -= dateFrame.size.height * 0.20
		string.draw(in: stringFrame)

		dateArrowColor.setFill()
		let y = dateFrame.maxY + (clockWidth * 0.015948963)
		let height = clockWidth * 0.022328549
		let pointDip = clockWidth * 0.009569378

		let path = NSBezierPath()
		path.move(to: CGPoint(x: dateFrame.minX, y: y))
		path.line(to: CGPoint(x: dateFrame.minX, y: y - height))
		path.line(to: CGPoint(x: dateFrame.midX, y: y - height - pointDip))
		path.line(to: CGPoint(x: dateFrame.maxX, y: y - height))
		path.line(to: CGPoint(x: dateFrame.maxX, y: y))
		path.line(to: CGPoint(x: dateFrame.midX, y: y - pointDip))
		path.fill()
	}
}
