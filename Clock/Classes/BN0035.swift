import AppKit

final class BN0035: ClockView {

	// MARK: - Types

	enum Style: String, ClockStyle {
		case bkbkg = "BKBKG"
		case whbkg = "WHBKG"
		case slbrg = "SLBRG"

		var description: String {
			switch self {
			case .bkbkg:
				return "Black"
			case .whbkg:
				return "White"
			case .slbrg:
				return "Silver/Brown"
			}
		}

		var backgroundColor: NSColor {
			switch self {
			case .bkbkg, .whbkg:
				return Color.darkBackground
			case .slbrg:
				return Color.leather
			}
		}

		var faceColor: NSColor {
			switch self {
			case .bkbkg:
				return backgroundColor
			case .whbkg:
				return NSColor(white: 0.996, alpha: 1)
			case .slbrg:
				return NSColor(white: 0.83, alpha: 1)
			}
		}

		var minuteColor: NSColor {
			switch self {
			case .bkbkg:
				return Color.white
			case .whbkg, .slbrg:
				return Color.black
			}
		}

		static var `default`: ClockStyle {
			return Style.bkbkg
		}

		static var all: [ClockStyle] {
			return [Style.bkbkg, Style.whbkg, Style.slbrg]
		}
	}

	// MARK: - ClockView

	override class var modelName: String {
		return "BN0035"
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
		return Style.all
	}

	override func initialize() {
		super.initialize()
		style = Style.default
	}

	// MARK: - Drawing

	override var fontName: String {
		return "HelveticaNeue"
	}

//	override func draw(day: Int) {
//		let dateArrowColor = Color.red
//		let dateBackgroundColor = NSColor(srgbRed: 0.894, green: 0.933, blue: 0.965, alpha: 1)
//		let clockWidth = clockFrame.size.width
//		let dateWidth = clockWidth * 0.057416268
//		let dateFrame = CGRect(
//			x: clockFrame.origin.x + ((clockWidth - dateWidth) / 2.0),
//			y: clockFrame.origin.y + (clockWidth * 0.199362041),
//			width: dateWidth,
//			height: clockWidth * 0.071770335
//		)
//
//		dateBackgroundColor.setFill()
//		NSBezierPath.fill(dateFrame)
//
//		style.minuteColor.setFill()
//
//		let paragraph = NSMutableParagraphStyle()
//		paragraph.alignment = .center
//
//		let string = NSAttributedString(string: "\(day)", attributes: [
//			.font: NSFont(name: "HelveticaNeue-Light", size: clockWidth * 0.044657098)!,
//			.kern: -1,
//			.paragraphStyle: paragraph
//			])
//
//		var stringFrame = dateFrame
//		stringFrame.origin.y -= dateFrame.size.height * 0.12
//		string.draw(in: stringFrame)
//
//		dateArrowColor.setFill()
//		let y = dateFrame.maxY + (clockWidth * 0.015948963)
//		let height = clockWidth * 0.022328549
//		let pointDip = clockWidth * 0.009569378
//
//		let path = NSBezierPath()
//		path.move(to: CGPoint(x: dateFrame.minX, y: y))
//		path.line(to: CGPoint(x: dateFrame.minX, y: y - height))
//		path.line(to: CGPoint(x: dateFrame.midX, y: y - height - pointDip))
//		path.line(to: CGPoint(x: dateFrame.maxX, y: y - height))
//		path.line(to: CGPoint(x: dateFrame.maxX, y: y))
//		path.line(to: CGPoint(x: dateFrame.midX, y: y - pointDip))
//		path.fill()
//	}
}
