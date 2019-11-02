import AppKit

final class BN0095: ClockView {

    // MARK: - Types

    enum Style: String, ClockStyle, CaseIterable {
        case bkslbkg = "BKSLBKG"
        case bkbkbkg = "BKBKBKG"

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
    }

    // MARK: - Properties

    private let outerRingWidth = 0.013
    private let innerRingWidth = 0.102
    private let majorTicksInset = 0.024
    private let majorTicksLength = 0.047
    private let majorTicksThickness = 0.007
    private let minorTicksInset = 0.062
    private let minorTicksLength = 0.039
    private let minorTicksThickness = 0.004

    private let ticksColor = NSColor(white: 1, alpha: 0.9)

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
        // Border
        drawTicksDivider(color: NSColor.white.withAlphaComponent(0.1), position: 0)

        // Outer ring
        drawTicksDivider(color: NSColor.white.withAlphaComponent(0.1), position: outerRingWidth)
        drawTicks(values: [0, 15, 30, 45], color: ticksColor, length: outerRingWidth, thickness: majorTicksThickness,
                  inset: 0)

        // Inner ring
        drawTicksDivider(color: NSColor.white.withAlphaComponent(0.1), position: innerRingWidth)

        // Minor
        let minorValues = [1...14, 16...29, 31...44, 46...59].flatMap { Array($0) }
        drawTicks(values: minorValues, color: ticksColor, length: minorTicksLength, thickness: minorTicksThickness,
                  inset: minorTicksInset)

        // Major
        drawTicks(values: [0, 15, 30, 45], color: ticksColor, length: majorTicksLength,
                  thickness: majorTicksThickness, inset: majorTicksInset)
    }

    override func drawNumbers() {
        drawNumbers(fontSize: 0.038, radius: 0.381)
    }
}
