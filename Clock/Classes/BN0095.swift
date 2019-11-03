import AppKit

final class BN0095: ClockView {

    // MARK: - Types

    enum Style: String, ClockStyle, CaseIterable {
        case bkbkbkg = "BKBKBKG"
        case bkslbkg = "BKSLBKG"

        var description: String {
            switch self {
            case .bkslbkg:
                return "Silver"
            case .bkbkbkg:
                return "Black"
            }
        }

        static var `default`: ClockStyle {
            return Style.bkslbkg
        }

        var caseColor: NSColor? {
            switch self {
            case .bkslbkg:
                return NSColor(white: 0.7, alpha: 1)
            case .bkbkbkg:
                return nil
            }
        }
    }

    // MARK: - Properties

    private let startTime = Date()

    private let outerRingWidth = 0.013
    private let innerRingWidth = 0.102
    private let majorTicksInset = 0.024
    private let majorTicksLength = 0.047
    private let majorTicksThickness = 0.007
    private let minorTicksInset = 0.062
    private let minorTicksLength = 0.039
    private let minorTicksThickness = 0.004
    private let outerMinorTicksInset = 0.009
    private let dotRadius = 0.0065
    private let dotCenterInset = 0.085
    private let sheathLength = 0.069
    private let sheathThicknessDelta = 0.001
    private let lumOffset = 0.006
    private let lumThickness = 0.0075
    private let complicationRadius = 0.122
    private let complicationUpperYOffset = 0.040
    private let complicationUpperXOffset = 0.175
    private var complicationLowerYOffset: Double { complicationUpperXOffset }
    private let complicationTickLength = 0.017
    private let complicationTickInset = 0.006
    private let complicationHandLength = 0.082
    private let complicationHandThickness = 0.006
    private let complicationSheathRadius = 0.013
    private let complicationScrewOuterRadius = 0.005
    private let complicationScrewInnerRadius = 0.002
    private let complicationFontSize = 0.028
    private let complicationNumberRadius = 0.085
    private let caseWidth = 0.039
    private let dateOffset = 0.230
    private let dateWidth = 0.075
    private let dateHeight = 0.052
    private let dateFontSize = 0.034
    private let dateArrowWidth = 0.018
    private let dateArrowDip = 0.012

    private let borderColor = NSColor(white: 1, alpha: 0.1)
    private let ticksColor = NSColor(white: 1, alpha: 0.9)
    private let sheathColor = NSColor(white: 0.3, alpha: 1)
    private let lumColor = NSColor(white: 0.1, alpha: 0.3)
    private let complicationScrewColor = NSColor(white: 0.9, alpha: 1)

    override var hourHandLength: Double { 0.221 }
    override var minuteHandLength: Double { 0.377 }
    override var minuteHandThickness: Double { hourHandThickness }
    override var secondHandLength: Double { 0.397 }
    override  var counterweightLength: Double { 0.111 }
    override  var counterweightThickness: Double { 0.016 }

    // MARK: - ClockView

    override class var modelName: String {
        return "BN0095"
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
        if let style = self.style as? Style, let caseColor = style.caseColor {
            // Case
            caseColor.setStroke()
            let width = clockFrame.width * CGFloat(caseWidth)
            let frame = clockFrame.insetBy(dx: width / -2, dy: width / -2)
            let path = NSBezierPath(ovalIn: frame)
            path.lineWidth = width
            path.stroke()
        } else {
            // Border
            drawTicksDivider(color: borderColor, position: 0)
        }

        // Outer ring
        drawTicksDivider(color: borderColor, position: outerRingWidth)

        // Major outer
        let majorValues = Array(stride(from: 0, to: 60, by: 5))
        drawTicks(values: majorValues, color: ticksColor, length: outerRingWidth, thickness: majorTicksThickness,
                  inset: 0)

        // Minor outer
        let outerMinorValues = Array(21...39).filter { !majorValues.contains($0) }
        drawTicks(values: outerMinorValues, color: ticksColor, length: minorTicksThickness,
                  thickness: minorTicksThickness, inset: outerMinorTicksInset)

        // Inner ring
        drawTicksDivider(color: borderColor, position: innerRingWidth)

        // Major
        drawTicks(values: majorValues, color: ticksColor, length: majorTicksLength, thickness: majorTicksThickness,
                  inset: majorTicksInset)

        // Minor
        let minorValues = Array(1...59).filter { !majorValues.contains($0) }
        drawTicks(values: minorValues, color: ticksColor, length: minorTicksLength, thickness: minorTicksThickness,
                  inset: minorTicksInset)

        drawDots()
    }

    override func drawNumbers() {
        drawNumbers(fontSize: 0.059, radius: 0.379)
    }

    override func drawLogo() {
        drawLogo(color: style.logoColor, width: 0.130, y: 0.680)
    }

    override func drawComplications() {
        let clockWidth = clockFrame.width

        let realComps = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date())
        let realSeconds = Double(realComps.second ?? 0) / 60

        let comps = Calendar.current.dateComponents([.hour, .minute, .second], from: startTime, to: Date())
        let seconds = Double(comps.second ?? 0) / 60
        let minutes = (Double(comps.minute ?? 0) / 30) + (seconds / 60)
        let hours = (Double(comps.hour ?? 0) / 12) + ((minutes / 60) * (60 / 12))

        // Minutes
        let topLeftCenter = CGPoint(x: clockFrame.midX - (CGFloat(complicationUpperXOffset) * clockWidth),
                                    y: clockFrame.midY + (CGFloat(complicationUpperYOffset) * clockWidth))
        drawStopwatchComplication(center: topLeftCenter, ticks: Array(stride(from: 0, to: 59, by: 2)),
                                  value: minutes, handColor: style.secondColor, numbers: [30, 10, 20])

        // Small Seconds
        let topRightCenter = CGPoint(x: clockFrame.midX + (CGFloat(complicationUpperXOffset) * clockWidth),
                                     y: clockFrame.midY + (CGFloat(complicationUpperYOffset) * clockWidth))
        drawStopwatchComplication(center: topRightCenter, ticks: Array(stride(from: 0, to: 59, by: 5)),
                                  value: realSeconds, handColor: style.minuteColor, numbers: [60, 20, 40])

        // Hours
        let bottomCenter = CGPoint(x: clockFrame.midX,
                                   y: clockFrame.midY - (CGFloat(complicationLowerYOffset) * clockWidth))
        drawStopwatchComplication(center: bottomCenter, ticks: Array(stride(from: 0, to: 59, by: 5)), value: hours,
                                  handColor: style.secondColor, numbers: [12, 4, 8])
    }

    override func draw(hours angle: Double) {
        super.draw(hours: angle)

        lumColor.setStroke()
        drawHand(length: hourHandLength - lumOffset, thickness: lumThickness, angle: angle)

        sheathColor.setStroke()
        drawHand(length: sheathLength, thickness: hourHandThickness + sheathThicknessDelta, angle: angle)
    }

    override func draw(minutes angle: Double) {
        super.draw(minutes: angle)

        lumColor.setStroke()
        drawHand(length: minuteHandLength - lumOffset, thickness: lumThickness, angle: angle)

        sheathColor.setStroke()
        drawHand(length: sheathLength, thickness: minuteHandThickness + sheathThicknessDelta, angle: angle)
    }

    override func draw(seconds angle: Double) {
        // This draws the stopwatch seconds and not the real seconds
        let comps = Calendar.current.dateComponents([.hour, .minute, .second], from: startTime, to: Date())
        let seconds = Double(comps.second ?? 0) / 60
        super.draw(seconds: -(.pi * 2 * seconds) + .pi / 2)
    }

    override func draw(day: Int) {
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }

        context.saveGState()
        context.translateBy(x: clockFrame.midX, y: clockFrame.midY)
        context.rotate(by: .pi * 2 / 360 * -40)
        context.translateBy(x: -clockFrame.midX, y: -clockFrame.midY)

        let clockWidth = clockFrame.width
        let size = CGSize(width: clockWidth * CGFloat(dateWidth), height: clockWidth * CGFloat(dateHeight))
        let rect = CGRect(x: clockFrame.midX + (CGFloat(dateOffset) * clockWidth),
                          y: clockFrame.midY - (size.height / 2),
                          width: size.width,
                          height: size.height)
        borderColor.setStroke()

        let backgroundPath = NSBezierPath(roundedRect: rect, xRadius: 2, yRadius: 2)
        backgroundPath.lineWidth = 1
        backgroundPath.stroke()

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let string = NSAttributedString(string: "\(day)", attributes: [
            .font: NSFont(name: "HelveticaNeue-Light", size: clockWidth * 0.044657098)!,
            .kern: -0.5,
            .paragraphStyle: paragraph,
            .foregroundColor: style.minuteColor
        ])

        var stringFrame = rect
        stringFrame.origin.y += rect.size.height * 0.10
        string.draw(in: stringFrame)

        Color.red.setFill()

        let arrowWidth = clockWidth * CGFloat(dateArrowWidth)
        let arrowDip = clockWidth * CGFloat(dateArrowDip)
        let path = NSBezierPath()
        path.move(to: rect.origin)
        path.line(to: CGPoint(x: rect.minX - arrowWidth, y: rect.minY))
        path.line(to: CGPoint(x: rect.minX - arrowWidth + arrowDip, y: rect.midY))
        path.line(to: CGPoint(x: rect.minX - arrowWidth, y: rect.maxY))
        path.line(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.line(to: CGPoint(x: rect.minX + arrowDip, y: rect.midY))
        path.fill()

        context.restoreGState()
    }

    // MARK: - Private

    private func drawDots() {
        let center = CGPoint(x: clockFrame.midX, y: clockFrame.midY)
        let clockWidth = clockFrame.width
        let centerRadius = (clockWidth / 2) - (clockWidth * CGFloat(dotCenterInset))
        let dotRadius = CGFloat(self.dotRadius) * clockWidth

        ticksColor.setFill()

        for i in stride(from: 0, through: 55, by: 5) {
            let progress = Double(i) / 60
            let angle = CGFloat(-(progress * .pi * 2) + .pi / 2)
            let dotCenter = CGPoint(x: center.x + cos(angle) * centerRadius, y: center.y + sin(angle) * centerRadius)
            let rect = CGRect(x: dotCenter.x - dotRadius, y: dotCenter.y - dotRadius, width: dotRadius * 2,
                              height: dotRadius * 2)

            if i == 0 {
                let offset = CGFloat(majorTicksThickness) * clockWidth * 1.5

                var left = rect
                left.origin.x -= offset
                NSBezierPath(ovalIn: left).fill()

                var right = rect
                right.origin.x += offset
                NSBezierPath(ovalIn: right).fill()
                continue
            }

            NSBezierPath(ovalIn: rect).fill()
        }
    }

    private func drawStopwatchComplication(center: CGPoint, ticks: [Int], value: Double, handColor: NSColor,
                                           numbers: [Int])
    {
        let clockWidth = clockFrame.width
        let size = clockWidth * CGFloat(complicationRadius) * 2

        let rect = CGRect(x: center.x - (size / 2), y: center.y - (size / 2), width: size, height: size)

        // Border
        borderColor.setStroke()
        let path = NSBezierPath(ovalIn: rect)
        path.lineWidth = 1
        path.stroke()

        // Ticks
        drawTicks(values: ticks, color: ticksColor, length: complicationTickLength, thickness: minorTicksThickness,
                  inset: complicationTickInset, in: rect)

        // Numbers
        drawNumbers(fontSize: CGFloat(complicationFontSize), radius: complicationNumberRadius, values: numbers,
                    in: rect)

        // Hand
        let angle = -(.pi * 2 * value) + .pi / 2
        handColor.setStroke()
        drawHand(length: complicationHandLength, thickness: complicationHandThickness, angle: angle, in: rect)

        // Sheath
        sheathColor.setFill()
        let sheathSize = clockWidth * CGFloat(complicationSheathRadius) * 2
        let sheath = CGRect(x: center.x - (sheathSize / 2), y: center.y - (sheathSize / 2), width: sheathSize,
                            height: sheathSize)
        NSBezierPath(ovalIn: sheath).fill()

        // Screw
        complicationScrewColor.setFill()
        let outerScrewSize = clockWidth * CGFloat(complicationScrewOuterRadius) * 2
        let outerScrew = CGRect(x: center.x - (outerScrewSize / 2), y: center.y - (outerScrewSize / 2),
                                width: outerScrewSize, height: outerScrewSize)
        NSBezierPath(ovalIn: outerScrew).fill()

        screwColor.setFill()
        let screwSize = clockWidth * CGFloat(complicationScrewInnerRadius) * 2
        let screw = CGRect(x: center.x - (screwSize / 2), y: center.y - (screwSize / 2), width: screwSize,
                           height: screwSize)
        NSBezierPath(ovalIn: screw).fill()
    }
}
