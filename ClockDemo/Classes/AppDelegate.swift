//
//  AppDelegate.swift
//  Clock
//
//  Created by Sam Soffes on 7/15/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

import Cocoa
import ScreenSaver

@NSApplicationMain
class AppDelegate: NSObject {
	
	// MARK: - Properties

	@IBOutlet var window: NSWindow!
	
	let view: ScreenSaverView = {
		let view = MainView()
		view.autoresizingMask = .ViewWidthSizable | .ViewHeightSizable
		return view
	}()


	// MARK: - Initializers

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	
	// MARK: - Actions
	
	@IBAction func showPreferences(sender: NSObject!) {
		NSApp.beginSheet(view.configureSheet(), modalForWindow: window, modalDelegate: self, didEndSelector: "endSheet:", contextInfo: nil)
	}
	
	
	// MARK: - Private
	
	func endSheet(sheet: NSWindow) {
		sheet.close()
	}

	func preferencesDidChange(notification: NSNotification?) {
		let preferences = (notification?.object as? Preferences) ?? Preferences()
		window.title = "Clock.saver — \(preferences.modelName)\(preferences.styleName)"
	}
}


extension AppDelegate: NSApplicationDelegate {
	func applicationDidFinishLaunching(notification: NSNotification) {
		// Add the clock view to the window
		view.frame = window.contentView.bounds
		window.contentView.addSubview(view)
		
		// Start animating the clock
		view.startAnimation()
		NSTimer.scheduledTimerWithTimeInterval(view.animationTimeInterval(), target: view, selector: "animateOneFrame", userInfo: nil, repeats: true)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferencesDidChange:", name: PreferencesDidChangeNotificationName, object: nil)
		preferencesDidChange(nil)
	}
}


extension AppDelegate: NSWindowDelegate {
	func windowWillClose(notification: NSNotification) {
		// Quit the app if the main window is closed
		NSApplication.sharedApplication().terminate(window)
	}
}
