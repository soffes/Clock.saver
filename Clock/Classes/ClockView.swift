import AppKit
import ScreenSaver

class ClockView: NSView {

	// MARK: - Properties

	class var modelName: String {
		fatalError("Unimplemented")
	}

	private var drawsLogo = false
    private var drawsSeconds = true

	private var logoImage: NSImage?

    var clockFrame: CGRect {
		return clockFrame(forBounds: bounds)
	}

	var style: ClockStyle!

	var styleName: String {
		set {}

		get {
			return style.description
		}
	}

	class var styles: [ClockStyle] {
		return []
	}

	override var frame: CGRect {
		didSet {
			setNeedsDisplay(bounds)
		}
	}

    var hourHandLength: Double { 0.263955343 }
    var hourHandThickness: Double { 0.023125997 }
    var minuteHandLength: Double { 0.391547049 }
    var minuteHandThickness: Double { 0.014354067 }
    var secondHandLength: Double { 0.391547049 }
    var counterweightLength: Double { 0.076555024 }
    var counterweightThickness: Double { 0.028708134 }

    var screwColor: NSColor { Color.black }

	// MARK: - Initializers

	convenience init() {
		self.init(frame: .zero)
	}

	required override init(frame: NSRect) {
		super.init(frame: frame)
		initialize()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		initialize()
	}

	// MARK: - NSView

	override func draw(_ rect: NSRect) {
		super.draw(rect)

		style.backgroundColor.setFill()
		NSBezierPath.fill(bounds)

		drawFaceBackground()
		drawTicks()
		drawNumbers()

		if drawsLogo {
			drawLogo()
		}

        drawComplications()
		drawHands()
	}

	// MARK: - Configuration

	func initialize() {
		NotificationCenter.default.addObserver(self, selector: #selector(preferencesDidChange),
                                               name: .PreferencesDidChange, object: nil)
		preferencesDidChange(nil)
	}

	func clockFrame(forBounds bounds: CGRect) -> CGRect {
		let size = bounds.size
		let clockSize = min(size.width, size.height) * 0.64

		let rect = CGRect(x: (size.width - clockSize) / 2.0, y: (size.height - clockSize) / 2.0, width: clockSize,
                          height: clockSize)
		return rect.integral
	}

	// MARK: - Drawing Hooks

	func drawTicks() {
		drawTicksDivider(color: style.backgroundColor.withAlphaComponent(0.1), position: 0.074960128)

		let color = style.minuteColor
		drawTicks(minorColor: color.withAlphaComponent(0.5), minorLength: 0.049441786, minorThickness: 0.004784689,
                  majorColor: color, majorThickness: 0.009569378, inset: 0.014)
	}

	func drawLogo() {
		drawLogo(color: style.logoColor, width: 0.156299841, y: 0.622009569)
	}

	func drawNumbers() {
		drawNumbers(fontSize: 0.071770334, radius: 0.402711324)
	}

	func draw(day: Int, hours: Double, minutes: Double, seconds: Double) {
		draw(day: day)
		draw(hours: -(.pi * 2 * hours) + .pi / 2)
		draw(minutes: -(.pi * 2 * minutes) + .pi / 2)
        draw(seconds: -(.pi * 2 * seconds) + .pi / 2)
	}

	func draw(day: Int) {}

	func draw(hours angle: Double) {
		style.hourColor.setStroke()
		drawHand(length: hourHandLength, thickness: hourHandThickness, angle: angle)
	}

	func draw(minutes angle: Double) {
		style.minuteColor.setStroke()
		drawHand(length: minuteHandLength, thickness: minuteHandThickness, angle: angle)
	}

	func draw(seconds angle: Double) {
		style.secondColor.set()

        if drawsSeconds {
            // Seconds hand
            drawHand(length: secondHandLength, thickness: 0.009569378, angle: angle)

            // Counterweight
            drawHand(length: -counterweightLength, thickness: counterweightThickness, angle: angle, lineCapStyle: .round)
        }

        // Nub
        let nubSize = clockFrame.size.width * 0.052631579
        let nubFrame = CGRect(x: (bounds.size.width - nubSize) / 2.0, y: (bounds.size.height - nubSize) / 2.0,
                              width: nubSize, height: nubSize)
        NSBezierPath(ovalIn: nubFrame).fill()

		// Screw
		let dotSize = clockFrame.size.width * 0.006379585
		screwColor.setFill()
		let screwFrame = CGRect(x: (bounds.size.width - dotSize) / 2.0, y: (bounds.size.height - dotSize) / 2.0,
                                width: dotSize, height: dotSize)
		let screwPath = NSBezierPath(ovalIn: screwFrame.integral)
		screwPath.fill()
	}

    func drawHands() {
        let comps = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date())
        let seconds = Double(comps.second ?? 0) / 60.0
        let minutes = (Double(comps.minute ?? 0) / 60.0) + (seconds / 60.0)
        let hours = (Double(comps.hour ?? 0) / 12.0) + ((minutes / 60.0) * (60.0 / 12.0))
        draw(day: comps.day ?? 0, hours: hours, minutes: minutes, seconds: seconds)
    }

    func drawComplications() {}

	// MARK: - Drawing Helpers

    func drawHand(length: Double, thickness: Double, angle: Double, lineCapStyle: NSBezierPath.LineCapStyle = .square,
                  in rect: CGRect? = nil)
    {
        let rect = rect ?? clockFrame
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let clockWidth = clockFrame.width
		let end = CGPoint(
			x: center.x + CGFloat(cos(angle)) * clockWidth * CGFloat(length),
			y: center.y + CGFloat(sin(angle)) * clockWidth * CGFloat(length)
		)

		let path = NSBezierPath()
		path.lineWidth = clockWidth * CGFloat(thickness)
		path.lineCapStyle = lineCapStyle
		path.move(to: center)
		path.line(to: end)
		path.stroke()
	}

	func drawLogo(color: NSColor, width: CGFloat, y: CGFloat) {
		if let image = logoImage {
			let originalImageSize = image.size
			let imageWidth = clockFrame.size.width * width
			let imageSize = CGSize(
				width: imageWidth,
				height: originalImageSize.height * imageWidth / originalImageSize.width
			)
			let logoRect = CGRect(
				x: (bounds.size.width - imageSize.width) / 2.0,
				y: clockFrame.origin.y + (clockFrame.size.width * y),
				width: imageSize.width,
				height: imageSize.height
			)

			color.setFill()

			let graphicsContext = NSGraphicsContext.current!
			let cgImage = image.cgImage(forProposedRect: nil, context: graphicsContext, hints: nil)!
			let context = graphicsContext.cgContext

			context.saveGState()
			context.clip(to: logoRect, mask: cgImage)
			context.fill(bounds)
			context.restoreGState()
		}
	}

	func drawFaceBackground() {
		style.faceColor.setFill()

		let clockPath = NSBezierPath(ovalIn: clockFrame)
		clockPath.lineWidth = 4
		clockPath.fill()
	}

	func drawTicksDivider(color: NSColor, position: Double) {
		color.setStroke()
		let ticksFrame = clockFrame.insetBy(dx: clockFrame.size.width * CGFloat(position),
                                            dy: clockFrame.size.width * CGFloat(position))
		let ticksPath = NSBezierPath(ovalIn: ticksFrame)
		ticksPath.lineWidth = 1
		ticksPath.stroke()
	}

    func drawTicks(minorColor: NSColor, minorLength: Double, minorThickness: Double, majorColor: NSColor? = nil,
                   majorLength: Double? = nil, majorThickness: Double? = nil, inset: Double = 0)
    {
        // Major
        let majorValues = Array(stride(from: 0, to: 60, by: 5))
        drawTicks(values: majorValues, color: majorColor ?? minorColor, length: majorLength ?? minorLength,
                  thickness: majorThickness ?? minorThickness, inset: inset)

        // Minor
        let minorValues = Array(1...59).filter { !majorValues.contains($0) }
        drawTicks(values: minorValues, color: minorColor, length: minorLength, thickness: minorThickness,
                  inset: inset)
	}

    func drawTicks(values: [Int], color: NSColor, length: Double, thickness: Double, inset: Double,
                   in rect: CGRect? = nil)
    {
        let rect = rect ?? clockFrame
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let clockWidth = clockFrame.width

        let tickRadius = (rect.width / 2) - (clockWidth * CGFloat(inset))
        for i in values {
            let tickLength = clockWidth * CGFloat(length)
            let progress = Double(i) / 60
            let angle = CGFloat(-(progress * .pi * 2) + .pi / 2)

            color.setStroke()

            let tickPath = NSBezierPath()
            tickPath.move(to: CGPoint(
                x: center.x + cos(angle) * (tickRadius - tickLength),
                y: center.y + sin(angle) * (tickRadius - tickLength)
            ))

            tickPath.line(to: CGPoint(
                x: center.x + cos(angle) * tickRadius,
                y: center.y + sin(angle) * tickRadius
            ))

            tickPath.lineWidth = ceil(clockWidth) * CGFloat(thickness)
            tickPath.stroke()
        }
    }

    func drawNumbers(fontSize: CGFloat, radius: Double, values: [Int] = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
                     in rect: CGRect? = nil)
    {
        let rect = rect ?? clockFrame
		let center = CGPoint(x: rect.midX, y: rect.midY)

		let clockWidth = clockFrame.size.width
		let textRadius = clockWidth * CGFloat(radius)
		let font = NSFont(name: "HelveticaNeue-Light", size: clockWidth * fontSize)!

        let count = CGFloat(values.count)
        for (i, text) in values.enumerated() {
			let string = NSAttributedString(string: String(text), attributes: [
				.foregroundColor: style.minuteColor,
				.font: font
			])

			let stringSize = string.size()
            let angle = -(CGFloat(i) / count * .pi * 2) + .pi / 2
			let rect = CGRect(
				x: (center.x + cos(angle) * (textRadius - (stringSize.width / 2))) - (stringSize.width / 2),
				y: center.y + sin(angle) * (textRadius - (stringSize.height / 2)) - (stringSize.height / 2),
				width: stringSize.width,
				height: stringSize.height
			)

			string.draw(in: rect)
		}
	}

	// MARK: - Private

	@objc private func preferencesDidChange(_ notification: NSNotification?) {
        drawsLogo = Preferences.shared.drawsLogo
        drawsSeconds = Preferences.shared.drawsSeconds
		
		if drawsLogo {
			if let imageURL = Bundle(for: ClockView.self).url(forResource: "braun", withExtension: "pdf") {
				logoImage = NSImage(contentsOf: imageURL)
			}
		} else {
			logoImage = nil
		}

		setNeedsDisplay(bounds)
	}
}
