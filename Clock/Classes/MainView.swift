//
//  ClockView.swift
//  Clock.saver
//
//  Created by Sam Soffes on 7/15/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

import AppKit
import ScreenSaver

class MainView: ScreenSaverView {

	// MARK: - Properties

	private var clockView: ClockView? {
		willSet {
			let clockView = self.clockView
			clockView?.removeFromSuperview()
		}

		didSet {
			if let clockView = clockView {
				clockView.autoresizingMask = .ViewWidthSizable | .ViewHeightSizable
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

	convenience override init() {
		self.init(frame: CGRectZero, isPreview: false)
	}

	override init(frame: NSRect, isPreview: Bool) {
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
			clockView.setNeedsDisplayInRect(clockView.clockFrame)
		}
	}

	override func hasConfigureSheet() -> Bool {
		return true
	}

	override func configureSheet() -> NSWindow! {
		return preferencesWindowController.window
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}


	// MARK: - Private

	private func initialize() {
		setAnimationTimeInterval(1.0 / 4.0)
		wantsLayer = true

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferencesDidChange:", name: PreferencesDidChangeNotificationName, object: nil)
		preferencesDidChange(nil)
	}

	func preferencesDidChange(notification: NSNotification?) {
		let preferences = (notification?.object as? Preferences) ?? Preferences()
		let view = preferences.model(frame: bounds)
		view.styleName = preferences.styleName
		clockView = view
	}
}
