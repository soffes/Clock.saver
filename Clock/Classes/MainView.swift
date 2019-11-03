import AppKit
import ScreenSaver

final class MainView: ScreenSaverView {

	// MARK: - Properties

	private var clockView: ClockView? {
		willSet {
			let clockView = self.clockView
			clockView?.removeFromSuperview()
		}

		didSet {
			if let clockView = clockView {
				clockView.autoresizingMask = [.width, .height]
				addSubview(clockView)
			}
		}
	}

	private let preferencesWindowController: PreferencesWindowController = {
		let controller = PreferencesWindowController()
		controller.loadWindow()
		return controller
	}()

	// MARK: - Initializers

	override init?(frame: NSRect, isPreview: Bool) {
		super.init(frame: frame, isPreview: isPreview)
		initialize()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		initialize()
	}

	// MARK: - ScreenSaverView

	override func animateOneFrame() {
		if let clockView = clockView {
			clockView.setNeedsDisplay(clockView.clockFrame)
		}
	}

	override var hasConfigureSheet: Bool {
		return true
	}

	override var configureSheet: NSWindow? {
		return preferencesWindowController.window
	}

	// MARK: - Private

	private func initialize() {
		animationTimeInterval = 1.0 / 30.0
		wantsLayer = true

		NotificationCenter.default.addObserver(self, selector: #selector(preferencesDidChange),
                                               name: .PreferencesDidChange, object: nil)
		preferencesDidChange(nil)
	}

	@objc private func preferencesDidChange(_ notification: NSNotification?) {
		let preferences = (notification?.object as? Preferences) ?? Preferences()
		let view = preferences.model.init(frame: bounds)
		view.styleName = preferences.styleName
		clockView = view
	}
}
