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
	static var all: [ClockStyle] { get }
}
