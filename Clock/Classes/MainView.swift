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

	var clockView: ClockView!

	let preferencesWindowController: PreferencesWindowController = {
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
		clockView.setNeedsDisplayInRect(clockView.clockFrame)
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

		clockView = BN0032(frame: bounds)
		clockView.autoresizingMask = .ViewWidthSizable | .ViewHeightSizable
		addSubview(clockView)
	}


	func preferencesDidChange(notification: NSNotification?) {
		// TODO: Update model
		setNeedsDisplayInRect(bounds)
	}
}
